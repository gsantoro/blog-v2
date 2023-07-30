---
title: "CueLang: a better alternative for Kubernetes manifests"
date: 2023-07-08T18:59:59+01:00
draft: false
tags:
- Kubernetes
- DevOps
- Containers
description: Discover CUE language, a better alternative to YAML for Kubernetes manifests. Simplify configuration management and schema validation
---
<!--more-->
<!--- subtitle --->
<!-- Is CUE language a better alternative to YAML? -->

<!--- caption --->
<!-- Photo by David Herron on Unsplash -->

## Meaning of the photo
According to [Wikipedia](https://en.wikipedia.org/wiki/Cue_stick):

> A **cue stick** (or simply **cue**, more specifically **billiards cue**, **pool cue**, or **snooker cue**) is an item of sporting equipment essential to the games of pool, snooker and carom billiards

## Is the tooling for YAML enough?
<!-- better tooling -->
How is it possible that the tooling for YAML is so lacking?

I always thought that given YAML is so ubiquitous, there would be better tooling than what we currently got in 2023. 

<!-- where do we use YAML -->
Between the many use of YAML, you can run your applications with Kubernetes, deploy your cloud infrastructure with [Pulumi](https://www.pulumi.com/), and write automation pipelines with [GitHub actions](https://github.com/features/actions).

Personally, I even use YAML to write my automation scripts with [Taskfile](https://taskfile.dev/), a more user-friendly alternative to Makefile. More on this later.

<!-- Was writing Json so bad? -->
Was writing JSON so bad that we had to invent a new language, losing in the process the schema validation?

When I started writing Kubernetes manifests in YAML, I found myself many times wondering if my YAML was valid and if I should have added one tab to a list of items. I think I miss JSON sometimes.

<!-- alternative to YAML -->
Given that DevOps Engineers write more YAML than any other language, and Kubernetes manifests are so verbose, I always thought someone would create a better alternative.

## CUE language
<!-- introduction -->
I believe they finally did create a better alternative than YAML, or at least I finally discovered it.

<!-- definition -->
Let me introduce [CUE language](https://cuelang.org/).

> **CUE** is an open-source language, with a rich set of APIs and tooling, for defining, generating, and validating all kinds of data: configuration, APIs, database schemas, code, … you name it.

CUE stands for `Configure Unify Execute`. 

<!-- uses -->
From the official [CueLang website](https://cuelang.org/) you can find all the official use cases of CueLang (that I reported here to make it easier for you to consume):

> - Data validation. Validate text-based data files or programmatic data such as incoming RPCs or database documents.
> - Configuration. Just add validation to existing data (CUE, YAML, JSON), reduce boilerplate in large-scale configurations, or both.
> - Schema Definition. Define schema to communicate an API or standard and validate backward compatibility.
> - Generate Code and Schema. Keep validation code in sync across code bases, Protobuf definitions, and OpenAPI definitions.
> - Scripting. Automate the use of your data without writing yet another tool.
> - Querying. Find the locations of instances of CUE types and values in data.  

<!-- Literature on CueLang -->
Given the extensive use of CueLang, I would expect that it would be mentioned more online.

I think the choice of the name is a bit unfortunate since `cue` is such a common verb in English that searching online for `cue` would return completely unrelated content.

For this reason, the community is using instead the word `CueLang` or `CUE` (all uppercase) to mean the CUE language and not the verb `to cue`.

## Personal note
<!-- history: dagger.io -->
I first heard about CueLang more than 6 months ago when I bumped into [Dagger.io](https://dagger.io/) while looking for a better alternative to Makefile. Dagger wasn't a good match for me, but I liked CueLang as an idea. I didn't look too much into CueLang at that time, since I have never heard it before and I didn't need Dagger.io.

I ended up discovering [Taskfile](https://taskfile.dev/) instead, and since then I use it every single day to automate anything from setting infrastructure to running integration tests and everything in between. I'll probably write about Taskfile in the future, that's not the point right now.

<!-- history: viktor farcic -->
Since that time with Dagger.io, I haven't heard about CueLang until this week, when I watched a great [video](https://youtu.be/m6g0aWggdUQ) by [Viktor Farcic](https://twitter.com/vfarcic). In this video, Viktor compared multiple alternatives for writing Kubernetes manifests including [Helm](https://helm.sh/), [Kustomize](https://kustomize.io/), [Carvel Ytt](https://carvel.dev/ytt/), [CDK8S](https://cdk8s.io/), and CueLang. 

It's a great video, I highly suggest you have a look.

Spoiler alert, CueLang was the winner.

<!-- YAML engineer -->
Having used or at least tried all the other alternatives, and never been fully happy with any of them, I was at least curious to look deeper into CueLang. Especially if that meant making my life as a `YAML Engineer` (this is what I call myself these days) a bit less miserable. 

<!-- who uses CueLang -->
So I did a bit of research, and this is what I found out:
- [CueLang](https://github.com/cue-lang/cue) has over 4k stars on GitHub. It might not seem like a lot but it is a niche tool. That's a lot more than 1.4k stars for a similar tool [Carvel YTT](https://github.com/carvel-dev/ytt). Sorry, Carvel.
- CueLang integrates with JSON, YAML, Go, Protobuf, OpenAPI, and Kubernetes. More information about [integrations](https://cuelang.org/docs/integrations/).
- [Istio](https://istio.io/) uses CUE to generate OpenAPI.
- You can define [tasks and scripts with CueLang](https://cuetorials.com/patterns/scripts-and-tasks/).

It looks great! How is it not used everywhere?

<!-- dagger.io and cue in 2023 -->
Looking back at Dagger.io, CueLang seems to be gone from their [quickstart documentation](https://docs.dagger.io/) since it hasn't been ported to Dagger Engine 0.3 as highlighted by this [PR](https://github.com/dagger/dagger/pull/3565) that was closed for inactivity on December 2022.

I assume that CUE has still to maturate as a language. I hope I am doing my part to spread the word.

## Documentation for CueLang
A great short [article on how to use CueLang](https://eltonminetto.dev/en/post/2022-11-08-intro-cuelang/) to write and validate Kubernetes manifests has been written by Elton Minetto. 

Then there is the official [CueLang documentation](https://cuelang.org/), which I find good as a starting point and for reference but unfortunately, it doesn't give lots of details about its use for Kubernetes.

A great resource with lots of documentation is [Cuetorials](https://cuetorials.com/). There is a lot to unpack from this resource. 

Finally another great tutorial at [Validate Your YAML (with CUE)](https://earthly.dev/blog/yaml-validate-and-lint-cue-lang/) from Earthly.

## Conclusion
I'm still just at the beginning of my learning path into CueLang but it looks very promising.

I hope to write a more hands-on tutorial about CueLang when I learn more about it.

For now, I would appreciate to learn your opinion on the topic. Is CueLang a great tool? Have you used it? Where and how?
