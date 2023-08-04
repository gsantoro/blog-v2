---
title: "Apko from Chainguard"
date: 2023-07-04T23:32:37+01:00
draft: false
tags:
- Kubernetes
- Containers
- Distroless
description: Apko from Chainguard revolutionizes container image creation. Build compact, secure, and reproducible images with ease using simple YAML config
aliases: 
- /apko-from-chainguard/
---
<!--more-->

<!--- subtitle --->
<!-- Effortlessly create your distroless container images -->

<!--- caption --->
<!-- Photo by CHUTTERSNAP on Unsplash -->

## Introduction
<!--- what is Apko --->
[Apko](https://edu.chainguard.dev/open-source/apko/overview/) is a command line tool from [Chainguard](https://www.chainguard.dev/) that allow you to build container images via a yaml configuration. 

<!-- where the name comes from --->
The application employs the APK package format sourced from [Alpine](https://www.alpinelinux.org/), drawing inspiration from [ko](https://github.com/ko-build/ko) and, consequently, earning its name.

> Ko is a simple, fast container image builder for Go applications.

<!--- features --->
Between its features we can find:
- **Small images** in the style of [distroless](https://github.com/GoogleContainerTools/distroless). Faster boot time and smaller footprint on memory and disk.
- **Secure** by design. A smaller footprint means a smaller attack surface and less CVE (Common Vulnerability and Exposures)
- **Fully reproducible**. Two separate runs of Apko will produce the same result. This is impossible if you run an `apk update` in your Dockerfile. The package repository might have changed since you built the container last.
- **Low learning curve**. It's just a YAML config and a build command.

<!--- why do we need it -> ref to other article on secure to shrink --->
I already talked about Apko in a previous article named [Shrink to Secure: Kubernetes and Compact containers](https://cloudnativeengineer.substack.com/p/shrink-to-secure-kubernetes-and-compact-containers-296b67d9975a), where I introduced a few alternatives on how to shrink your container images to make them more secure.

Apko works well with another tool from Chainguard called [Melange](https://github.com/chainguard-dev/melange).

From the Github repo on Melange, we can read:

> Build APK packages using declarative pipelines.
> Commonly used to provide custom packages for container images built with [apko](https://github.com/chainguard-dev/apko). The majority of APKs are built for use with either the [Wolfi](https://github.com/wolfi-dev) or [Alpine Linux](https://www.alpinelinux.org/) ecosystems.

With the combination of Melange and Apko, you can build containers from source code similar to what [Buildpacks.io](https://buildpacks.io/) does. I'll cover Buildpacks in a future article to keep this article short.

<!--- how we are using it here --->
I would argue that if you only need to package some pre-existing APK packages, you just need Apko and not Melange.

In this article, we are going to use Apko to build an image called `debug-tools` that contains some command line tools. I use this image to debug my Kubernetes applications with `ephemeral containers`.

If you are not familiar with ephemeral containers, from the official Kubernetes documentation on how to [debug with an ephemeral container](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container) you can read:

> [Ephemeral containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/) are useful for interactive troubleshooting when `kubectl exec` is insufficient because a container has crashed or a container image doesn't include debugging utilities, such as with [distroless images](https://github.com/GoogleContainerTools/distroless).

## How to build 
<!--- pub/priv keys --->
Before we start building container images with Apko, we need to generate a pair of public/private keys with Melange.

We can use the following commands:
```bash
MELANGE_IMAGE=cgr.dev/chainguard/melange@sha256:5a14ffc28fce6f65a231b6ef37a03d013734e47a7ce0a0cc394190bc213616e8 # v0.4.0

# generate melange.rsa.pub to sign your container images
docker run --rm \
	-v "${PWD}":/work \
	$MELANGE_IMAGE \
	keygen
```
I lied before that we don't need Melange. We need it but only to generate those two keys. We are not going to use it to build APK packages from source code.

Here we fix the version of Melange by using the latest digest for that image. 

This is because it has been [announced](https://www.chainguard.dev/unchained/a-guide-on-how-to-use-chainguard-images-for-public-catalog-tier-users) by Chainguard a policy change that will prevent an anonymous user from pulling image tags other than `latest` and `latest-dev`. Since you can still pull images by digest, this is my preferred way to `pin` to a specific version of the image for future proofing my scripts.

<!--- build --->
Once you have the keys, you can now build the container image by using the following commands:
```bash
APKO_IMAGE=cgr.dev/chainguard/apko@sha256:d2105dd448d9ef2939a5c5fbb135f99b352350af66ae67949b1ba272e0919792 # v0.9.0

# build my image
docker run --rm \
	-v "${PWD}":/work \
	$APKO_IMAGE \
	build apko.yaml \
	docker.io/gsantoro/debug-tools:latest \
	debug-tools.tar \
	-k melange.rsa.pub
```
Similarly to the previous command, here I have pinned the version of Apko.

<!--- apko.yaml config --->
The previous command uses the configuration provided below in the file `apko.yaml`:
```yaml
contents:
  repositories:
    - https://dl-cdn.alpinelinux.org/alpine/edge/main
  packages:
    - alpine-base
    - iputils-ping
    - bind-tools
    - curl

entrypoint:
  command: /bin/sh -l

archs:
  - x86_64
  - arm64

accounts:
  groups:
    - groupname: nonroot
      gid: 65532
  users:
    - username: nonroot
      uid: 65532
  run-as: nonroot

environment:
  PATH: /usr/sbin:/sbin:/usr/bin:/bin
```

<!--- to notice from config --->
From the previous config, you can notice:
1. It used a package repository for APK packages. Namely `https://dl-cdn.alpinelinux.org/alpine/edge/main`.
2. It installs some packages defined in the section `packages`.
3. It provides an `entrypoint` command. Here just a simple shell command.
4. It builds for two different architectures `x86_64` and `arm64`. We could have provided more versions.
5. We create a user and a group both called `nonroot` and we run the container with that user instead of `root`. This is for security reasons.
6. We configure an environment variable `PATH`. This is just optional here. We could have set any of other environment variables.

I believe the previous config really shows what is possible with Apko. For more information on the file format you can have a look [here](https://github.com/chainguard-dev/apko/blob/main/docs/apko_file.md).


## Inspect the results
<!--- load --->
Now that the image has been built, we can load it into Docker from the tar file:
```bash
docker load < debug-tools.tar
```
Two images will be loaded `gsantoro/debug-tools:latest-amd64` and `gsantoro/debug-tools:latest-arm64` since we provided two architecture values.

<!--- test --->
If you want to test to see how it works, you can run the following command to enter the container shell:
```bash
docker run --rm -it gsantoro/debug-tools:latest-arm64
```
<!--- dive --->
Finally, we can inspect the image, thanks to the tool called [`dive`](https://github.com/wagoodman/dive):
```bash
dive docker.io/gsantoro/debug-tools:latest-arm64
```
The interesting thing about this image, it's that there is a single layer and it very small. With Dockerfile we got used to having many layers and optimizing the caching of those layers by reordering the commands to execute. With Apko we don't care about any of that.

Here you have some stats for one of those images:
```bash
Image name: docker.io/gsantoro/debug-tools:latest-arm64
Total Image size: 31 MB                                 
Potential wasted space: 0 B                             
Image efficiency score: 100 %
```
Bonus point, you can achieve a 100% image efficiency score. Neat!

<!--- scan --->
Scanning that image returns 0 vulnerabilities
```bash
docker scout cves docker.io/gsantoro/debug-tools:latest-arm64
```
Here you have, we created a very small and secure container image with a simple YAML configuration file.

You can find both those two images on Docker Hub at [debug-tools](https://hub.docker.com/r/gsantoro/debug-tools/tags).

## Personal note
<!--- how I discovered Apko: distroless --->
Before I bumped into Apko and Chainguard, I discovered a while ago the [distroless images](https://github.com/GoogleContainerTools/distroless) from Google. 

Google was the first to introduce images without a proper Operating System, that only contain the software strictly necessary to run your application.

It was a game changer, but while using distroless images was always straightforward like any other base image in a multi-stage Docker build. Building a distroless image was not so easy until Apko came to life.

<!--- Bazel --->
Google builds its distroless images using [Bazel](https://bazel.build/) a complex tool that is mainly used to build Java or C++ projects. Having abandoned the world of Java a while ago and since the last time I wrote any C++ was in University a while ago, I never even considered even looking into Bazel. 

<!--- Apko vs Bazel --->
With Apko instead, the learning curve is very low. You put together a config in YAML and then run the build command from a Docker image as we have shown in this article.

I don't think it could get any easier than this. 

## Conclusion
Apko has now become my tool of choice when I want to just pack already available APK packages into a container image for multiple architectures.

If you were to reproduce the same outcome in Docker, you could either use the command `docker manifest` or alternatively `docker buildx`. The first option involves quite a few commands, while buildx is still experimental in docker. You can find more information about both those commands [here](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/).
