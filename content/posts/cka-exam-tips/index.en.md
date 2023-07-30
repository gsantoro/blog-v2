---
title: "Tips for Certified Kubernetes Administrator exam"
date: 2023-04-02T17:16:19+01:00
draft: false
tags:
- Kubernetes
- DevOps
- Certified Kubernetes
description: Get valuable tips for passing the Certified Kubernetes Administrator (CKA) exam. Prepare effectively with insights on exam rules and environment setup
---
<!--more-->

Tips and tricks to pass the [Certified Kubernetes Administrator exam](https://trainingportal.linuxfoundation.org/learn/course/certified-kubernetes-administrator-cka/exam/exam).

I recently passed my Certified Kubernetes Administrator exam and I would like to share with you some tips that might enable you to pass the exam.

{{< tweet user="gsantoro15" id="1642572237327745027" >}}

## Booking 
- You need to allow 24h from when you schedule an exam to when the exam can take place. This includes any possible retakes. Keep that in mind if the expiration date is approaching.
- A trick that I discovered only after have scheduled my exam. If you start one of the exam simulators, your `due date for the exam will be moved forward of 4 days`. You can use this to get some extra days to study up to the exam.


## Taking the exam
- [Official doc](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/taking-the-exam)
- [Exam rules and policies](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies)
	- No food
	- Only clear liquids from clear glass or clear bottle
	- No speaking
- You can click on the `Launch exam` up to 30 minutes before the scheduled start. 
- After you click on `Launch Exam`:
	- You need at least 5 minutes to install the software `PSI Secure Browser` 
	- You need to provide a selfie and a picture of a government id with your signature
	- You need at least 10-15 minutes to scan the entire room including:
		- Under the table
		- The entire table surface including glasses and your phone if you have one. I had my phone in another room to be safe
		- Behind your ears to prevent you from wearing hidden earphones
		- Up your long sleeves (if you are wearing a jumper or a long sleeve shirt)
- No `dual monitor` or other electronics. 
- Try to use an `external USB camera` to scan the room more easily than the integrated camera in your laptop. 


## During the exam
- some useful aliases and commands. Bear in mind that:
	- k=kubectl is already configured
	- Vim is already configured as above
	- Kn and KX aliases are available at [cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) (which is part of the official documentation that you are allowed to browse)

{{<gist gsantoro 05c6f586cc255155139043bb2e16d9df>}}

- When writing a manifest for a question use the file format `<question number>.<resource>.yaml` . For example `1.pod.yaml` to store a manifest for a pod for question number 1. This way you can leave a question partially answered and go back to it later. 
- Before editing a manifest provided by the environment, `back it up` first with the file format `<question number>.manifest.yaml.bak` so that you can map the manifest to the question.
- If you are asked to create bash scripts do not bother adding the `shebang` sequence `#!/usr/bin/env bash` or add execution permissions via chmod. This is a waste of time since scripts will be executed via `sh script.sh` 
- `Official documentation` links are provided for each question with the question description. This will save you from searching the relevant page yourself. Unfortunately, you might not be able to find the most relevant documentation in those provided links
- The official Kubernetes documentation has `external links` pointing to other domains. Since you are not allowed to browse links other than `kubernetes.io`, and this requirement is currently not enforced via the browser, Before opening a link, point your mouse over the link to inspect the domain in the status bar before opening it. I accidentally opened some external links during my exams but closed them immediately.
- You can `flag` a question to go back later in the exam environment
	- No need to use the provided text editor to remember which questions you skipped or to write them down on a file
	- Don't get stuck trying to answer difficult questions, skip them to solve the easier ones. You can always go back to them
- The environment provides you with a `calculator and a text editor` for note-taking. I didn't use any of that. 
- Useful keymaps
	- `SHIFT + CTRL + T` to open a new tab in the terminal
	- `SHIFT + CTRL + C` and `SHIFT + CTRL + V` to copy and paste

### Environment setup
- Remote Linux desktop
- Firefox Browser
- [kubectl autocomplete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete) is already configured
- vim already setup
- alias `k=kubectl` already configure
- passwordless ssh to other nodes is already configured


## Results
Results are sent back after 24h from the exam starting time via email and via the exam home page

## Related articles
<!-- {{< article link="/posts/prepare-for-cka-exam/" >}} -->
