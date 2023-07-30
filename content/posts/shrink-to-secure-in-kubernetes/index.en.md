---
title: "Shrink to Secure: Kubernetes and Secure Compact Containers"
date: 2023-06-23T22:18:29+01:00
draft: false
tags:
- DevOps
- Security
- Kubernetes
- Containers
description: Enhance your Kubernetes security using compact containers. Discover effective techniques like Wolfi OS, Buildpacks, and finally Melange and Apko from Chainguard
---
<!--more-->

<!--- caption --->
<!-- Photo by Matthew Henry on Unsplash -->

Reduce your Kubernetes container size to improve security. 

These two concepts seem very much unrelated in other technical fields but when talking about Kubernetes containers you can reduce the first while improving the latter. 

## Introduction

> For once you don't have to choose between security and performance. "You can have your cake and eat it too". 

In this article, I would try to explain why size and security are very much related when it comes to containers and what you can do to reduce the first while improving the latter. 

I would create a future article about how to implement those techniques with code snippets and scripts. For now, I would like to just convince you that investing your time and resources into those techniques can have massive benefits.

## Why size matters and how it relates to security?

<!-- benefits of size -->
Smaller size containers have several benefits both for developers and administrators:

- **Faster boot time**. Faster dev loop for developers and faster response time if using containers as layers in AWS Lambda or Google Cloud Functions.
- **Smaller memory usage**. You can fit more applications on your laptop memory or you can lower your cloud cost by using a smaller Kubernetes cluster.
- **Smaller footprint on disk**. This either means more space on your laptop for developers or smaller costs if storing images in a private container registry on cloud storage.

<!-- CVE -->
How a smaller size is related to security, you might ask. The answer is in the latest trend on containers that have been the main focus of the last couple of years: **security, DevSecOps, and  Common Vulnerability and Exposures (CVE)**. 

> Turns out that if you remove lots of unnecessary software, like the entire OS your image is based on, you will reduce the number of vulnerabilities in the process. 

Imagine removing the entire Operating system and leaving only your application. All of a sudden you don't have to wait six months or more for a new version of the OS to fix those vulnerabilities but you can just fix your code instead. In reality, software engineers don't tend to write software from scratch. They use third-party libraries and those come with their vulnerabilities. Those are easier and faster to fix but still something to keep in mind.

<!-- why we still create large containers -->
As you can see, there are not very many reasons why using bigger containers should be the default approach. 

> So why do we still create large containers in 2023?

The main reason, it is a lot easier to build bloated large containers than images with only the strictly necessary. This is mostly due to the evolution of containers and the only very recent concept of distroless containers.

## Containers vs Virtual Machines
<!-- evolution of containers. VMs vs containers -->
When Docker came out a couple of years ago, containers were marketed as a replacement for Virtual machines. This idea made it very easy to widespread their adoption, but then we spent years explaining that the two technologies were very much different. Containers are in fact not replicating the entire software stack of an Operating System like a VM does, but they are nothing more than a way to isolate processes running on the same operating system by using [Namespaces and CGroups](https://www.nginx.com/blog/what-are-namespaces-cgroups-how-do-they-work/). Those technologies were introduced in the Linux kernels many years before, but they only saw a massive interest when Docker make it simple to use them.

<!-- containers = lighter VMs -->
One of the main benefits of using containers versus VMs was the lighter footprint and faster boot time, not so different from the benefits that I highlighted before. 

<!-- base images for Os -->
The problem with the analogy with VMs is that base images at the beginning closely replicated common operating systems like Debian or Ubuntu. While containers with those images are still lighter than VMs, they still pack quite a lot of software that might not be strictly necessary to run your application.

## Alpine Linux

![Alpine Linux](alpinelinux-logo.webp "Alpine Linux")

<!-- alpine -->
The very first approach to reduce the size of container images was the introduction of a very lightweight base container image called [Alpine Linux](https://hub.docker.com/_/alpine/). I clearly remember when I started using Alpine as my base image, I thought that only the container size and the faster dev loop were good reasons to never use OS-based images in my Docker containers. 

<!-- dockerfile vs images off the shelf -->
The problem at the time was, most of the container images for languages like Python were still based on Debian or Ubuntu. I had two choices, write my own Docker file from scratch with Alpine as a base image or use a Docker image off-the-shelf. The tradeoff there was between time to develop or slower performances. It wasn't an easy choice and I remember either choosing one option or the other based on if I was making a long-term investment or looking for a quick fix. 

Long-term investment meant that I was more inclined to spend the time to build my own Dockerfile, while if I was in a hurry I would opt for an off-the-shelf large image.

I'm happy to say that is not the case any longer in 2023, container images for major languages come with lighter variations that use Alpine as the base image.

## Other techniques to write small containers
Why do we care about making the container images smaller if Alpine Linux has already achieved good results? 

Cost and security are still the main drivers of creating new tools to make containers smaller and smaller.

In the following sections, we are going to cover three main techniques that make it easy to build very small images:

- Wolfi OS from Chainguard
- Multi-stage Docker builds
- Buildpacks
- Melange and Apko from Chainguard

We are going to explain when to use each of those techniques and why there is not a single approach for each use case but you should be aware of them all to be able to make a conscious decision.

## Wolfi OS

![WolfiOS](wolfi-logo.webp "WolfiOS")

Late last year, Chainguard (a company founded by Google engineers behind [distroless](https://www.chainguard.dev/unchained/minimal-container-images-towards-a-more-secure-future) containers) [announced](https://www.chainguard.dev/unchained/introducing-wolfi-the-first-linux-un-distro) a new container image called [Wolfi](https://github.com/wolfi-dev). 

The idea is similar to Alpine Linux, they created a new OS image with a smaller footprint and zero vulnerabilities and then started creating other images based on that to pack software like Nginx or Golang.

Why the idea is not revolutionary, the focus with Wolfi and in general with Chainguard is more on security and supply chain integrity and transparency. 

For the same reason why I described using Alpine-based container images before, I would use a Wolfi-based container image if one is available. It is a lot easier to use an image off-the-shelf if you have an exact match with what you want to run. 

Chainguard is adding new Wolfi-based images almost every day so keep an eye on their [image repository](https://github.com/chainguard-images/).

If instead, you are packaging your application in a container, keep reading about what other techniques are available.

## Multi-stage Docker builds
This technique is not new but still relevant especially if you want to still with using Dockerfile as your only way to build containers.

The idea is simple, you use a big image with all the build tools available to build your binary and then another more lightweight image for running your application. This idea is used by other tools mentioned below, but, in those cases, you don't have to write a Dockerfile.

For more information about multi-stage Docker builds, see the documentation [here](https://docs.docker.com/build/building/multi-stage/).

<!-- Why use anything other than Dockerfile -->

I don't think there is anything wrong with writing a Dockerfile for building containers for Kubernetes, we have been using Dockerfiles for years now and some people don't even know there are better alternatives available. I would even argue that are even cases when this is the best solution even right now. 

For example, when you have some very custom requirements for your application that would be harder to implement otherwise. In my opinion, this is a small percentage of the cases though. 

The alternatives proposed in the following sections are somehow either bleeding-edge technologies or not very well-known to the great majority of developers and for that reason not used as much as multi-staged Docker builds. 

Some technologies are even used under the hood by major cloud providers (like Buildpacks) but the majority of developers are not even aware of that (at least I wasn't until not so long ago).

<!-- with Wolfi-based image -->
I haven't used a multi-staged Dockerfile in a while now, but if I had to create one today I would probably opt for using an Alpine-based image for my building phase and a Wolfi-Os image for the running phase.

## Buildpacks

![Buildpacks.io](buildpacks-logo.webp "Buildpacks.io")

[Buildpacks](https://buildpacks.io/) have a long history of development. There were first introduced in 2011 by Heroku and more recently they evolved into Cloud Native Buildpacks and they are now an incubating project in the [Cloud Native Foundation landscape](https://www.cncf.io/projects/buildpacks/).

Buildpacks were in their initial form used by Google App Engine a while ago and more recently as [Google Cloud Buildpacks](https://github.com/GoogleCloudPlatform/buildpacks) they are used by [Google Cloud Run](https://cloud.google.com/run) to detect your code from source and automatically build a container image that is compliant with [OCI image format](https://github.com/opencontainers/image-spec).

The idea behind Buildpacks is that most of the time, you are going to have a very standard Dockerfile with the very same steps for each coding language. If a Buildpack detects the source code of an application for a specific language is provided, it will follow a list of predefined steps to build a container image.

For example, if you are building a Python application you are going to provide a requirements.txt file with your dependencies and a main.py with your application entry point. These steps can be standardized and put in a Python "builder" that if it detects those files, builds the image for you. No more copy-pasting Dockerfile around your projects. 

Buildpacks like multi-staged Docker build create small images with just enough software to run your application.

## Melange and Apko from Chainguard
[Melange](https://github.com/chainguard-dev/melange) and [Apko](https://github.com/chainguard-dev/apko) from Chainguard are quite new tools. They are used by Chainguard to build their Wolfi-based images.

Melange uses Yaml-based pipelines to build APK (Alpine Package Keeper) packages from source code. Apk is the packaging format of Alpine. Funny how tools don't disappear altogether but they get reused to create something better.

Apko uses Yaml configuration to build OCI images from APK packages. You can either specify a package already available in the Alpine OS repository or use an APK that you built with Melange.

If you combine the two tools, you can pretty much achieve what Buildpacks does. Converting source code into small container images that just contain only your application and not much more.

## Multi-stage builds vs Buildpacks vs Melange/Apko
To be honest with you, there is not a clear winner here.

Multi-stage Docker builds are what I used the most in the past but there are better alternatives now.

Buildpacks have a long history and they are used by major cloud providers like Google. If you are going to run your application on Google Cloud Run, you should at least be aware of how to use them. Bear in mind that creating your own Buildpacks has quite a steep learning curve.

Melange/Apko is instead quite a lot easier to use and they might be a better alternative if you have a simple use case.

I would like to write a more in-depth article in the future explaining some nice use cases for either of those.

## Security tools for containers
No matter which one of those tools you use, you might still have some vulnerabilities in your application either due to the libraries that you are using or to your coding choices.

Some security tools that scan for vulnerabilities are the following:

- [Docker scout](https://docs.docker.com/scout/). Basic scanning functionality is provided by default with the Docker CLI. This is a good starting point if you don't want to invest in more complex solutions.
- [Aqua Trivy](https://www.aquasec.com/products/trivy/). A more complex solution than Docker Scout that packs security scanning for IaC (Infrastructure as Code) and Kubernetes as well.
- [Github code scanning](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning). If you are using Github for storing your source code, Github security scanning is an easy choice to scan your code for vulnerabilities.
- [Github Dependabot](https://docs.github.com/en/code-security/dependabot). It scans your repositories for vulnerabilities that can be easily fixed by updating the dependencies. If it founds any, it will create a PR to upgrade the dependency. 

## Conclusion
I hope I made a good case for smaller container images and for improving the security of your containers.

The space is full of different alternatives and navigating them is not always easy. New technologies pop up every day but the underlying concepts change more slowly. That's why I think that instead of focusing on a specific tool, that might not be there tomorrow, is a lot better to invest your time in understanding the basic concepts under the hood.

That's why I intend to make future articles on these topics to keep developers informed and able to make their own decision to use one tool or the other. 

## Resources
- [Alpine Linux](https://hub.docker.com/_/alpine/)
- [Wolfi](https://github.com/wolfi-dev)
- [Buildpacks](https://buildpacks.io/)
- [Melange](https://github.com/chainguard-dev/melange)
- [Apko](https://github.com/chainguard-dev/apko)
- [Docker scout](https://docs.docker.com/scout/)
- [Aqua Trivy](https://www.aquasec.com/products/trivy/)
- [Github code scanning](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning)
- [Github Dependabot](https://docs.github.com/en/code-security/dependabot)
