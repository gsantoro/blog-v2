---
title: "Can you keep a secret... on your laptop?"
date: 2023-06-11T11:21:11+01:00
draft: false
tags:
- DevOps
- Credentials
- Security
description: Securely store secrets on laptops with envchain. It provides encryption at rest and integration with laptop lock mechanisms
---
<!--more-->

<!--- caption --->
<!-- Keep a secret -->

Can you keep a secret... on your laptop?

How do you prevent credentials and API keys on your laptop to leak into the internet?

In this article, we are going to describe a possible solution to store secrets easily and securely on your laptop that doesn't involve paying for third-party commercial software (eg. [Hashicorp Vault](https://www.vaultproject.io/)) or cloud resources (eg. [Secret Manager](https://aws.amazon.com/secrets-manager/)) or password managers (eg. [1Password](https://1password.com/)).

## Introduction

Storing secrets securely on your laptop has been affecting for generations both application developers and more recently DevOps writing Infrastructure as Code software. Many different solutions have been implemented in the last decade from password managers to secrets providers on the cloud. The problem has become more significant in the last couple of years with the push for [Gitops](https://www.gitops.tech/) to store secrets along aside your code.

Here we are going to address a simplified use case:

- developers want to store secrets securely "offline" on their laptops
- developers want to keep the cost down (especially when working on side projects) by not paying for third-party software on the cloud
- developers want to keep the complexity down by only storing secrets locally
- developers don't need some of the more complex features like secrets rotation or secret detection systems
- developers don't need to share secrets with other developers or other devices

For the sake of keeping this article short and to the point, we are not going to discuss how to handle Secrets in Kubernetes or other more complex use cases.

We are going to first describe what kind of secrets you can find, then common well-known solutions, and finally we will describe a simple solution both free and secure. 

## What is a secret?
With the term secret, we indicate in this article anything that needs to remain private to the eyes of third parties including:

- cloud provider credentials (eg. AWS Access Key ID or AWS Secret Access Key)
- ssh private keys
- encryption keys
- database passwords

Secrets can accidentally leak to the internet in various ways, the most common being accidentally ending up in a Git commit and being pushed to the cloud (eg. Github or Bitbucket). Removing a secret from Git history can be hard if not impossible.

The outcome of a secret leak can be very serious depending on the type of secret or the environment they provide access to (think dev/staging environment vs production environment). For example, cloud provider credentials leaked to the internet can cause hefty bills and unauthorized access to customers' resources. 

## Problems with current solutions
Everybody knows that storing secrets in plain text is wrong. Why do we still do it in 2023, then?

Developers around the world store secrets in clear text next to their code and add the secret location to `.gitignore` to avoid committing the secrets as well. While this solution works, it is quite error-prone and probably the cause of most of the secret leaks.

Current solutions to mitigate accidental secrets leaks are for example:

- [git-secrets](https://github.com/awslabs/git-secrets) that you can run locally to prevent committing passwords or other secrets to your Git repository
- [Github - secret scanning](https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning) scans your Git repo for tokens and private keys. This solution doesn't prevent the git commit like the first, but it notifies after the fact, and it requires some manual remediation.

A possible solution to this problem is avoiding storing the secrets next to the code altogether.

For example, SSH credentials are still stored in plain text at `~/.ssh` and AWS credentials are stored in clear text at `~/.aws/credentials`. If we agree that storing secrets in plain text is wrong, why do we still do it somewhere else "more secure"?

While I agree that storing secrets in those locations is better than committing secrets to Git, I believe that we are just moving the problem somewhere else. We might want to backup files in those "secure" locations to Git (for example if we want to save dotfiles or cloud provider configs) and we are going to have a similar problem there as well. 

A better alternative is to encrypt secrets at rest on your laptop. While this solution works well when a human is typing the secret and it is the core concept of password managers, it is not very easy to include in an automated scenario where a script runs periodically.


## A better solution
Can we have a better solution that combines the requirements of Developers (easiness of development and automation) with the requirements of DevOps (keeping secrets secure at all times)?

I believe I have found a better solution, to the ones proposed before, that combines all the requirements described in the introduction and it is both secure, simple and cheap.

The solution involves using a tiny (and almost unknown) tool called ["envchain"](https://github.com/sorah/envchain). This tool follows the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) of minimalist and composable tools that is at the backbone of any modern software.

Between the benefits we can find:

- Encryption at rest: envchain allows you to encrypt your secrets using a passphrase. The encrypted secrets are stored on disk and cannot be accessed without decrypting them with the passphrase.

- Decryption on Demand: the encrypted secrets are decrypted only when necessary, and access to them is granted upon successful authentication with the passphrase. This ensures that the secrets remain protected until you need to use them.

- Laptop Locking Integration: envchain can be integrated with your laptop's lock mechanism. It automatically locks and re-encrypts the stored secrets when your laptop is locked, providing an additional layer of security against unauthorized access.

- Environment variables: envchain can expose decrypted secrets as environment variables to be used by other tools. 

- OS support: it supports both MacOS keychain and D-Bus secret service (gnome-keyring) as a vault

For example, you could use envchain to store your AWS credentials and load them in memory as environment variables to be used by other tools like [aws-cli](https://github.com/aws/aws-cli) or other Infrastructure as Code tools. The only limitation here is the [maximum size of an environment variable at 32,760](https://devblogs.microsoft.com/oldnewthing/20100203-00/?p=15083). Given this limit is quite high, it should not be a problem for most of our use cases.

{{<gist gsantoro 81058dae699a56686b008464b862195c>}}

While envchain supports both MacOS and Linux keychains, if you are only interested in securing your secrets on MacOS you can use MacOS keychain CLI via the `security` command. You can find more information at [Storing Secrets Using the MacOS Keychain CLI](https://www.aria.ai/blog/posts/storing-secrets-with-keychain.html).

## Conclusion
With this article, I wanted to prove that you can both achieve a simple, secure and automated way to store secrets on your laptop.

While this doesn't solve all the possible use cases, it is clearly a good starting point that improves upon the current situation.
