---
title: "Elasticsearch: 'ignore_malformed', The Antidote for Mapping Exceptions"
date: 2023-06-17T17:56:24+01:00
draft: false
tags:
- Elasticsearch
- Data Ingestion
description: Learn how to address mapping exceptions in Elasticsearch with the ignore_malformed setting. Prevent dropped documents during ingestion and ensure data integrity
---
<!--more-->

<!--- caption --->
<!-- Elasticsearch -->

Ignore fields that are not compliant with index mappings and avoid dropping documents during ingestion with Elasticsearch.

How an almost unknown setting called `ignore_malformed` can make the difference between dropping a document entirely because a single field is malformed or just ignoring that field and ingesting the document anyway. 

## Disclaimer

<!-- disclaimer about working at Elastic -->
> Disclaimer: The views and opinions expressed in this article are solely my own and do not necessarily reflect the views of Elastic, where I am currently employed. This article is for informational purposes only and should not be understood as an endorsement of any particular company, product, or policy. It should not be mistaken for official communication from Elastic. I share my perspectives based on my personal experiences and learning, and these are subject to change over time.

## Introduction
<!-- definition of ES -->

> Elasticsearch is the distributed search and analytics engine at the heart of the Elastic Stack.
> ...
> Elasticsearch is where the indexing, search, and analysis magic happens.

Elasticsearch is a quite complex tool with many features. In this article, I assume that you are already familiar with Elasticsearch in general and specifically with the concepts of index, mappings, and with the API used for ingesting documents in Elasticsearch. Those concepts are the same either if you are using the latest version of the stack or if you are using a rather old version of Elasticsearch. 

If that's not the case, I encourage you to look into the [Elasticsearch documentation](https://www.elastic.co/guide/en/enterprise-search/current/index.html) and then come back later.

Are you back? Great! Let's go.

In this article, I'll explain how the setting `ignore_malformed` can make the difference between a 100% dropping rate and a 100% success rate (even if just ignoring some malformed fields).

## My Personal experience
As a Senior Software Engineer working at Elastic in the Cloud Native monitoring team, I have been on the first line of support for anything related to Beats running on Kubernetes, and Cloud Native integrations like Nginx ingress controller.

During my experience, I have seen all sorts of issues. Customers have very different requirements but most of them encounter (at some point in their experience) a very common problem with Elasticsearch: mapping exceptions. 


## How mappings work
I like to think of Elasticsearch as a document-based NoSQL database where it is not mandatory to define the schema of your indices up front. Elasticsearch will infer the schema from the first document or any subsequent documents that contains a new field. 

Alternatively, you can provide a schema (called `mapping` in the Elasticsearch lingo) upfront and all your documents need to follow that schema.

In reality, the situation is not black and white. You can also provide a partial schema that covers only some of the fields (maybe the most common) for every document and leave Elasticsearch to figure out the schema of the more dynamic fields.

## What happens when data is malformed?
No matter if you specified a mapping upfront or Elasticsearch inferred the mapping automatically. If a document present even just a field that doesn't match the mapping of an index, Elasticsearch will drop the entire document and return a warning in the client logs. 

A big problem arises if a customer doesn't look at those logs and misses the warnings. They might never figure out that anything went wrong, or even worse, Elasticsearch might even stop ingesting data entirely if all the subsequent documents are malformed.

The above situation sounds very catastrophic but entirely possible especially if you don't have full control over the quality of your data. Think about user-generated documents.

Likely there is a quite unknown setting in Elasticsearch that solves exactly the above problem. This field has been there since [Elasticsearch 2.0](https://www.elastic.co/guide/en/elasticsearch/reference/2.0/ignore-malformed.html). We are talking ancient history here since the latest version at the time of writing is 8.8. 

How is it possible that not many people are aware of this field and even fewer customers are currently using it?

## An example use case
To make it easier to interact with Elasticsearch, I am going to use here Kibana (a front-end tool for Elasticsearch) and the [devtools console](https://www.elastic.co/guide/en/kibana/current/console-kibana.html). 

<!-- same doc -->
The following examples are taken from the official [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.8/ignore-malformed.html#ignore-malformed).

I am here to expand on the example by providing a few more details about what happens behind the scenes.

First, we want to define 2 fields, both with type `integer` but only one of them has `ignore_malformed` defined.

```json
PUT my-index-000001
{
  "mappings": {
    "properties": {
      "number_one": {
        "type": "integer",
        "ignore_malformed": true
      },
      "number_two": {
        "type": "integer"
      }
    }
  }
}
```

If you try to get the resulting mapping with the command

```json
GET my-index-000001/_mapping
```

you will the result

```json
{
    "my-index-000001": {
        "mappings": {
            "properties": {
                "number_one": {
                    "type": "integer",
                    "ignore_malformed": true
                },
                "number_two": {
                    "type": "integer"
                },
                "text": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                }
            }
        }
    }
}
```

Then we ingest two sample documents

```json
PUT my-index-000001/_doc/1
{
  "text":       "Some text value",
  "number_one": "foo" 
}

PUT my-index-000001/_doc/2
{
  "text":       "Some text value",
  "number_two": "foo" 
}
```

Document 1 is correctly ingested, while document 2 instead returns the following error message.

```json
{
  "error": {
    "root_cause": [
      {
        "type": "document_parsing_exception",
        "reason": "[3:17] failed to parse field [number_two] of type [integer] in document with id '2'. Preview of field's value: 'foo'"
      }
    ],
    "type": "document_parsing_exception",
    "reason": "[3:17] failed to parse field [number_two] of type [integer] in document with id '2'. Preview of field's value: 'foo'",
    "caused_by": {
      "type": "number_format_exception",
      "reason": "For input string: \"foo\""
    }
  },
  "status": 400
}
```

If you then search on the same index with the following query

```json
GET my-index-000001/_search
{
  "fields": [
    "*"
  ],
  "_source": true
}
```

You will get see that only the first document (with id=1) has been ingested correctly. 

```json
{
    "took": 14,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": null,
        "hits": [
            {
                "_index": "my-index-000001",
                "_id": "1",
                "_score": null,
                "_ignored": [
                    "number_one"
                ],
                "_source": {
                    "text": "Some text value",
                    "number_one": "foo"
                },
                "fields": {
                    "text": [
                        "Some text value"
                    ],
                    "text.keyword": [
                        "Some text value"
                    ]
                },
                "ignored_field_values": {
                    "number_one": [
                        "foo"
                    ]
                },
                "sort": [
                    "1"
                ]
            }
        ]
    }
}
```

From the above JSON response, you can notice a couple of things:

- there is now a field `_ignored` of type array with the list of all fields that have been ignored while ingesting this document.
- there is a field `ignored_field_values` with a dictionary of ignored fields and their values.
- the field `source` contains the original document unmodified. This is especially useful if you want later to fix the problem with the mapping.

## Conclusion
You can start using `ignore_malformed` from today on your indices by just adding to your index settings, to a single field while creating the mapping, or to an index template to make the default option for all indices with a particular index pattern. For the sake of brevity, I won't show here how to use this setting either for an index, an index template, or a component template. Either refer to the official documentation or stay tuned for more articles on the topic.

Elastic is currently going through an effort to make this setting the default from Elasticsearch 8.9. 

I am personally working on this feature, and I can reassure you that it is a game changer.

I'm going to post more articles in the future on this tiny but mighty setting. Stay tuned.

## Resources
- [ignore-malformed documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.8/ignore-malformed.html)
