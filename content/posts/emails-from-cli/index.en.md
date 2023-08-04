---
title: "Send emails from the command line"
date: 2023-07-20
draft: false
tags:
- CLI
- DevOps
description: Combine Resend Email API, Pop from Charm.sh, Taskfile, Envchain to send emails from the command line
aliases:
- /emails-from-cli/
---
<!--more-->

<!--- subtitle --->
<!-- Send custom domain emails from the command line using an API service. -->

<!--- caption --->
<!-- Photo by mk. s on Unsplash -->

## Introduction
<!--audience-->
I can see two main use cases for you to prefer the command line to a web solution (like Gmail) for sending emails:
- you live in the command line and you never want to leave
- you are a DevOps engineer in search of a cheap and secure way to automate sending emails from the command line.

Those two use cases definitively overlap but I mean you don't have to be a DevOps to like this setup. You might just prefer the command line to a GUI (Graphical User Interface). 

<!--alternatives-->
I'm aware there are better and more complex solutions that focus more on notifications via different channels (eg. text messages, in-app notifications). Here, I just want to present this setup because it's deadly simple and it allows me to send up to 100 emails for free each day.

<!--tools involved-->
The tools involved are:
- Resend, an API for sending emails via an SDK
- Pop, a command line tool to wrap around Resend
- Envchain, to store securely Resend API tokens on your laptop
- Taskfile, to automate the setup and configuration of the previous tools

<!--motivation-->
It might feel an overkill to use four different tools when a web interface would do exactly the same thing but a web interface is not always an option. Imagine that you are monitoring the CPU on your laptop and you want to send an email to yourself when the CPU goes over a certain limit. Maybe you are trading crypto coins and you want to send an email to yourself when the price of Bitcoin goes over a certain value that you are tracking with your homemade solution.

The use cases for a command line solution are limitless, I won't spend more time on all the benefits of such a solution, but I'll jump straight into describing first each of the tools in isolation and finally, I'll explain how I combine those tools to simplify the setup.

I covered [Taskfile](https://cloudnativeengineer.substack.com/i/134951085/taskfile) and [Envchain](https://cloudnativeengineer.substack.com/p/can-you-keep-a-secret-on-your-laptop-d8da82552518) in two previous articles, so please refer to those links if you are not familiar with those tools. I won't cover them here but I'll just provide the code I used to integrate those tools with Resend.

If you are still not convinced that you want to send email from the command line, use this article as a use case for how to integrate Taskfile and Envchain to automate things in a secure way on your laptop.

## Resend
[Resend](https://resend.com/overview) is a web API that allows you to send emails from an SDK.

The official documentation describes it as:

> Resend is the email API for developers.

The company launched in January this year and two days ago [raised 3 Million dollars](https://twitter.com/resendlabs/status/1681306770009096192?s=20). 

<!--features-->
Between the features, we can find:
- SDK for many languages including Golang, Python, Javascript, Ruby, and PHP.
- Integrates with DNS (like Google Domains) to provide email from custom domains
- Analytics and logs
- Webhooks, get notified when an event occurs like an email is opened, clicked, delivered, or reported as spam
- Affordable pricing:
	- free: 3000 email/month with a limit of 100 emails/day
	- paid: various options depending on the volume of emails sent, starting at $20/month for up to 50000 emails with no daily limit

You can find more details with code samples for each SDK in the [documentation](https://resend.com/docs/introduction) or in the [API reference](https://resend.com/docs/api-reference/introduction).

Since we plan to send emails from the command line, here you have a sample of how to send an email via Curl.
```bash
curl -X POST 'https://api.resend.com/emails' \
     -H 'Authorization: Bearer re_123456789' \
     -H 'Content-Type: application/json' \
     -d $'{
  "from": "me@example.com",
  "to": ["you@example.com"],
  "subject": "hello world",
  "text": "it works!"
}'
```

Bear in mind that once you signup to Resend, you need to generate an API key and replace the value `re_123456789` in the previous code. That's just a bogus API key provided here only for demonstration purposes.

We could easily finish the article at this point, but I'm going to show you how you can avoid providing the API key in clear text and how to provide defaults for some fields, and a few other features.

## Pop
[Pop](https://github.com/charmbracelet/pop?s=09) is a tiny tool that wraps around `Resend` API to make it easier to send emails from the command line. 

<!--charm.sh-->
Pop was written by the developers behind the set of tools called Charm. In the past I have used another of their tools called [Gum](https://github.com/charmbracelet/gum), a command line tool to write glamorous shell scripts. I might write another article about Gum in the future.

<!--sample code-->
To compare Pop with the curl command, we have seen above, here you have the same email but written by Pop:
```bash
pop <<< "it works!" \
	--subject "hello world" \
	--from "me@example.com"
	--to "you@example.com"
```
For this to work, you need to provide the following environment variables:
```bash
export RESEND_API_KEY=re_123456789
export POP_FROM=me@example.com
```
Since those values are likely to always be the same, you can easily put them in a `.env` file and use [Direnv](https://cloudnativeengineer.substack.com/i/134951085/direnv) to load those values into environment variables in a shell. The problem with this solution is that you want to store the Resend API key securely instead of keeping it in clear text on your laptop, avoiding so to accidentally commit it to Github. We will see in the final setup how to achieve this with Envchain.

For a description of all the other features, you can look at the documentation from the help command:
```
➜ pop --help
Pop is a tool for sending emails from your terminal.

Usage:
  pop [flags]
  pop [command]

Available Commands:
  completion  Generate completion script
  help        Help about any command

Flags:
  -a, --attach strings     Email's attachments
      --bcc strings        BCC recipients
  -b, --body string        Email's contents
      --cc strings         CC recipients
  -f, --from string        Email's sender ($POP_FROM) (default "me@example.com")
  -h, --help               help for pop
  -p, --preview            Whether to preview the email before sending
  -x, --signature string   Signature to display at the end of the email. ($POP_SIGNATURE) (default "")
  -s, --subject string     Email's subject
  -t, --to strings         Recipients
  -v, --version            version for pop

Use "pop [command] --help" for more information about a command.
```

Finally, you can just type the command `pop` to fill in the email interactively. Pop will automatically fill in the details that you provided via the environment variables.

## My setup
As anticipated in the introduction, here we glue the previous commands thanks to Taskfile and Envchain. 

Here is my Taskfile to send emails from the command line:
```yaml
version: '3'

tasks:
  install:
    cmds:
      - brew install pop

  configure:
    cmds:
      - envchain --set resend RESEND_API_KEY

  hello:
    cmds:
      - |
        envchain resend \
        pop <<< "Hello from Pop" \
        --subject "Welcome" \
        --to "you@example.com" \
        --preview

  # Note: Ask to fill in details
  send:
    cmds:
      - |
        envchain resend \
        pop 
```

You can configure your laptop to use this setup by running the following commands:
1. `task install` to install Pop on your laptop. Envchain here is already installed thanks to [Devenv](https://cloudnativeengineer.substack.com/i/134951085/devenv).
2. `task configure` to store the Resend API key in a secure way on your laptop

Then you can either send a default welcome email via the command `task hello` or alternatively compile an email interactively via `task send`.

Notice here that Envchain stores the Resend API key in a namespace called `resend` via the command `envchain --set resend RESEND_API_KEY` and then it loads it back into the shell when running `envchain resend <command>`.