---
title: "Kubernetes development environments"
date: 2023-05-19T12:47:01+01:00
draft: false
tags:
- Kubernetes
- DevOps
- Development environment
- Docker
description: Discover Kubernetes development environments. Explore options like Docker Desktop, Minikube, Kind, K3s, K3d, and Rancher Desktop
---
<!--more-->
TL;DR: I recently uninstalled Docker Desktop entirely from my MacBook and replaced it with Rancher Desktop. 

## Intro
In 2023, there are many different ways of configuring your Kubernetes development environment. Some of them are **Docker Desktop, Minikube, Kind, K3s, and K3d** but the list goes on and on.

So which one should you choose? Things get even more complicated if you have an Apple M1 chipset like I do.

Like with everything, "It all depends". I would like to provide here a very opinionated setup that I am currently using.


## Early days with Docker

Before I explain what is my current setup, allow me to digress and provide a bit of personal history with containers and Kubernetes. In short, I would like to explain how if you are new to containers and Kubernetes you might follow a similar path. My story should be able to convince you that in 2023 you can easily skip most of those tools and jump straight to what I am suggesting. This will save you countless hours of research.

I don't remember exactly when I first heard about Docker, but I clearly remember that when talking at a Hadoop conference (this must be before 2015) someone mentioned that everyone in Silicon Valley was talking about this shiny new revolutionary technology called Docker. "It is like a VM but lighter". This tells clearly that people at that time knew very little about how containers worked. It was all magic.

My first experience with containers involved running Docker Desktop on my MacBook. Kubernetes wasn't even a thing yet. You could run a single container or later on, multiple containers with [Docker Compose](https://docs.docker.com/compose/).

## The container orchestration war

When Docker introduced [Docker Swarm](https://docs.docker.com/engine/swarm/) it looked like you could use containers in production. You could create a cluster of machines and run distributed applications with containers. It looked great but I didn't play with it since I didn't need it for work yet.

Only in late 2016, I first started using container orchestration tools for work. The competition was still fierce between [Apache Marathon](https://mesosphere.github.io/marathon/) and [Kubernetes](https://kubernetes.io/) and many other options with lower adoption.

My company opted for Marathon, so I didn't have the chance to play with Kubernetes for quite a while.

By 2021 when I first started looking into Kubernetes in my personal time, all the online resources, courses, and books would suggest you use [Minikube](https://minikube.sigs.k8s.io/). It was supported both on my Linux desktop and my MacBook laptop. It was an easy choice. 

I can't remember exactly when I learned that Docker Desktop was able to run Kubernetes, but I never considered that an option since I had adopted already other solutions.

The company I was working at the time, was still not interested in using Kubernetes in production. They found it too hard to manage and they didn't have enough internal knowledge to adopt it. They opted in for [AWS ECS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html) so I still had no luck learning more about Kubernetes.

Both Marathon and ECS had quite a few things in common, but at the time there wasn't a clear winner for container orchestration tools.

Even at this point, my local development still involved Docker Compose or just a bunch of separate containers running on Docker Desktop. It always bothered me that you couldn't easily use the same tools for both production and local development. The promise of containers to make local development close to production wasn't yet concrete.

## Working for a Bank

In 2021 I briefly joined an Investment bank (I only latest a couple of weeks) and to my great surprise, you couldn't get them to buy a Docker license for local development. I would expect banks to have enough money to pay the 10$ license fees for a group of less than 10 developers. I don't think that was the real problem, that was probably just an excuse from the older members of the team that couldn't see why Docker containers were a better option than VMs for local development. I quickly decided that wasn't the environment I wanted to work in. 

If only there was an open-source replacement for Docker, that could have solved the argument about license costs.

A couple of years ago I even tried to use [Podman](https://podman.io/) as an alternative to Docker Desktop but the parity between the two wasn't 100% yet so back to Docker Desktop.

## The End of the container orchestrator war
Since then I didn't get to use Kubernetes in a professional capacity until last year when I joined [Elastic](https://www.elastic.co/) as a Senior Software Engineer in the Cloud Native monitoring team. 

I had to quickly ramp up my knowledge of Kubernetes since I needed to learn how to deploy, configure and run Kubernetes clusters and applications on Kubernetes both on cloud providers and locally for testing. 

None of my colleagues were using Minikube but a new shiny new tool called [Kind (or Kubernetes on Docker)](https://github.com/kubernetes-sigs/kind).

The benefits of running Kind were (in no particular order):

- multi-node cluster setup
- support for any version of Kubernetes
- ability to create many different Kubernetes clusters on the same machine
- network connectivity between Docker containers and Kubernetes

Internally Kind makes this possible by running Kubernetes nodes as Docker containers and Kubernetes containers run as [Containerd](https://containerd.io/) containers.

This allowed me so much flexibility that I thought I didn't need anything else for a while.

This was the very first time when I realized that the container orchestrator was over and Kubernetes was the absolute winner. All of a sudden it didn't make sense anymore to run docker-compose, ECS Fargate, Docker Swarm, or Apache Marathon. Don't get me wrong, the experience I got with those tools was very propaedeutic. Now I can fully appreciate as only having a single container orchestrator standard allows you to focus on other problems at a higher level of abstraction and it allows the ecosystem to thrive.

## K3d
In the last 6 months or so, I started reading many articles about how [K3s](https://k3s.io/) and [K3d](https://k3d.io/v5.5.1/) could be an alternative to Minikube. Since I was happy with Kind, I didn't investigate this further. 

In the last 3 months, I managed to get my Certified Kubernetes Administrator exam and even in the material for preparing for the exam the suggestion was to still use Minikube. I thought I knew better by using Kind instead.

Kind was featured as the best alternative for Kubernetes local development at Kubecon 2023 in Amsterdam since it was created by the Kubernetes developers for testing Kubernetes locally. That was another argument for not looking anywhere else.

Only recently I discovered a new YouTube channel called [DevOpsToolkit](https://www.youtube.com/@DevOpsToolkit) run by [Viktor Farcic](https://twitter.com/vfarcic). I quickly got addicted to this channel, since it has lots of interesting videos about everything Kubernetes. I highly recommend it to anyone that would like to learn more about Kubernetes and the myriad of tools in the ecosystem.

Since then, I change my mind about using K3d for local development. This happened when I learned that it provides a similar user experience to Kind (meaning you can run a multi-node cluster with Docker containers) but internally it runs K3s, which is a 100% compatible Kubernetes alternative but a lot lighter on the CPU/Memory requirements. K3s achieves this by removing parts of the Kubernetes code that are obsolete and by replacing Etcd with a lighter database alternative.

## Final setup
After watching the following video [How To Replace Docker With nerdctl And Rancher Desktop](https://www.youtube.com/watch?v=evWPib0iNgY) on YouTube channel [DevOpsToolkit](https://www.youtube.com/@DevOpsToolkit), I also learned how you can replace Docker Desktop with an open-source solution called [Rancher Desktop](https://rancherdesktop.io/). If only this tool was available when I was working in the investment bank, maybe I would still be working there now.

{{< youtube evWPib0iNgY >}}

This video was shot a year ago, since then I am happy to say that Rancher Desktop is now supported on Apple M1 laptops and thanks to [Colima](https://github.com/abiosoft/colima) and [nerdctl](https://github.com/containerd/nerdctl) and a few Linux aliases you can be unaware that Docker is no longer running on your machine.

There is still quite a lot that I need to learn and discover about this new setup with Rancher Desktop and all the software that it packages underneath, but so far I am happy that even without the Docker application I can still run the same commands as nothing changed.

Even if I decided to never use docker-compose for my local environment, unfortunately, I still need to interface with some "legacy" software that runs as a bunch of containers with docker-compose. So I am glad that Rancher Desktop still allows to you replace and interface with docker-compose.

## What to do if your local environment is not big enough?

Rancher Desktop supports both Containerd and Docker container runtime. While I am happy that Docker is no longer installed on my machine, I am afraid that I still need to use Docker container runtime since [devcontainers](https://code.visualstudio.com/docs/devcontainers/containers) are not supported (at least not yet) with Containerd runtime. You can install [VS Code Remote Containers](https://docs.rancherdesktop.io/how-to-guides/vs-code-remote-containers) if you are interested.

Devcontainer is a new technology developed by Microsoft that allows you to use containers to not only run your application but also write and test your code. If you are developing an app, you would require some third-party tools like K9s, Dive, Helm, Kubectl, Skaffold, and many more. With devcontainers you can package those tools in a container, and then use VS Code to write code inside that container mounted as a remote container without the developers installing those tools on their machines. 

Similar technology is used to provide [Gitpod](https://www.gitpod.io/) and [Github codespaces](https://code.visualstudio.com/docs/remote/codespaces) to extend the capabilities of your laptop over the physical limitations of your hardware. I'll probably write another blog post on this subject in the future.

## Conclusion
This blog post is not an exhaustive guide on all the tools that are available in the Kubernetes ecosystem but I hope it provides some useful information that help you navigate through the many possible options that are available.

If there is a lesson to learn from my personal experience I believe it can be summarized in the following principles:

- Develop your applications as close as possible to the production setup. 
- Prefer open-source solutions to proprietary ones because sometime in the future they might ask you to pay for a license.
- Stay up to date with the ecosystem since things move fast in our world. 
- Never assume that something will never be replaced with something better

Focusing on Kubernetes for both your dev environment and production instead of two different tools is already making me much more productive. So ditch docker-compose, ECS, Marathon, Docker swarm and any other tool that is not plain Kubernetes or 100% compatible with it.

I consider myself still new to the Kubernetes ecosystem since there are so many tools to discover. I hope to have the experience I need to help me decide which tools are worthy of my time investment.
