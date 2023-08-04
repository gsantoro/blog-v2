---
title: "Kubernetes: node-shell"
date: 2023-07-02T17:56:24+01:00
draft: false
tags:
- Kubernetes
- DevOps
- Containers
description: Discover node-shell, the powerful kubectl plugin that provides SSH-like access to Kubernetes nodes for infrastructure investigation
aliases:
- /k8s-node-shell/
---
<!--more-->

<!--- caption --->
<!-- Photo by Anna Mcphee on Unsplash -->

<!--- subtitle --->
<!-- Run a container to get full access to the Kubernetes node. -->

While working with Kubernetes, it might happens that you would like to SSH into a node to investigate the underlying infrastructure. For example, you might want to look into the running processes or read from the local file system. 

SSH access to the underlying Kubernetes nodes is not always available when Kubernetes is managed by a cloud provider. Alternatively if Kubernetes nodes are emulated by Docker containers (eg. when using [Kind](https://kind.sigs.k8s.io/) or [K3d](https://k3d.io/v5.5.1/) on your laptop) you might use the command `docker exec` to open a shell into the Kubernetes nodes.

There is a better alternative, and it works for either of those cases.

Discover [node-shell](https://github.com/kvaps/kubectl-node-shell/blob/master/README.md), a plugin for [kubectl](https://kubernetes.io/docs/reference/kubectl/) that allow to run a privileged pod on Kubernetes to access the node resources.


## How to install
Node-shell can be installed using [krew](https://krew.sigs.k8s.io/) a plugin manager for [kubectl](https://kubernetes.io/docs/reference/kubectl/) command line tool. 

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) if not available already
2. Install [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/) if not available already
3. Install node-shell

```bash
kubectl krew index add kvaps https://github.com/kvaps/krew-index
kubectl krew install kvaps/node-shell
```
## Usage
Once node-shell is installed, you can open a shell to any node of your cluster with the following command:

```bash
kubectl node-shell <node_name>
```

If you, like me, prefer to open a shell to any Kubernetes node, you can use instead: 

```bash
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep "worker" | head -n 1)
kubectl node-shell $NODE_NAME
```

## Under the hood
Node-shell is nothing more than a bash script called `kubectl-node_shell` stored under `~/.krew/bin`. 

Here the file name of this script is relevant, since kubectl assume that all the script named `kubectl-<plugin>` with no file extension are kubectl plugins. The folder, where this script is located, instead is not relevant as long as that folder is added to the `PATH` environment variable in your Linux/MacOs laptop.

Under the hood, node-shell build a K8s manifest similar to the one provide below. Here some details has been omitted for brevity. 

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - command:
    - nsenter
    - --target
    - "1"
    - --mount
    - --uts
    - --ipc
    - --net
    - --pid
    - --
    - bash
    - -l
    image: docker.io/library/alpine
    imagePullPolicy: Always
    name: nsenter
    resources:
      limits:
        cpu: 100m
        memory: 256Mi
      requests:
        cpu: 100m
        memory: 256Mi
    securityContext:
      privileged: true
```

A couple of things to notice:
- `nsenter` command documentation is available at [doc](https://man7.org/linux/man-pages/man1/nsenter.1.html). 
- `nsenter` target the PID `1` (from the param `--target "1"`), enter some of available namespaces (params: `--mount --uts --ipc --net --pid`) of that process, and run the script `bash -l`
- `docker.io/library/alpine` is the container image used. You can change this image in the node-shell script if you have a better alternative, as long as that image provide the `bash` shell used by the command `nsenter`
- in order to enter those namespaces, it needs to run in `privileged` mode by chaing the `securityContext.privileged` field.

Knowing what's happening internally in this script and what the Kubernetes manifest generate looks like, could allow you to create more sophisticated manifest that use a custom container image or enter other container namespaces, or use a different shell.

## Personal note
I have used `node-shell` many times to investigate issues with the Kubernetes integration for Elastic.

The Kubernetes integration has a data stream called [`container_logs`](https://docs.elastic.co/en/integrations/kubernetes#container-logs), that is used by Elastic-agent to ingest container logs into Elasticsearch.

To achieve that, elastic-agent mounts the path `/var/log` from the node file system to its container file system. Then it tails the files under `/var/log/containers/*.log` that are created by Kubernetes with the /dev/stdout (standard output) of each container.

If you want to read the raw logs created by Kubernetes, before they are ingested by Elastic agent, you can use `node-shell` to open a shell into a Kubernetes node and investigate its file system.
