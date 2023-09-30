---
title: "Scribus: the best free Adobe InDesign alternative"
date: 2023-09-30T21:40:37+01:00
draft: false
tags:
- Publishing
- Open-source
description: Scribus vs. Adobe InDesign - Creating Digital Magazines the Open-Source Way
---
<!--more-->

<!--- subtitle --->
<!-- Scribus vs. Adobe InDesign: Creating Digital Magazines the Open-Source Way -->

<!-- seo -->
<!--  What is the best open-source alternative to Adobe InDesign for professional looking printed and digital magazines? -->


<!--- caption --->
<!-- Photo by Bruno Martins on Unsplash  -->

## Introduction
In this article, I'm going to compare Scribus and Adobe InDesign, two professional tools used for self-publishing digital and printed material. 

I'll start the article by describing how I got myself into self-publishing in the first place, then move to other alternatives I briefly evaluated, then finally compare Adobe InDesign and Scribus.

But before we get into the meat of this article, why am I even bothering with self-publishing tools?

## Motivation for self-publishing
I recently published a paid article on my Substack newsletter called [CloudNativeEngineer](https://cloudnativeengineer.substack.com/), wich didn't go very well. I didn't manage to convert a single free subscriber to a paid subscription.

<!-- I won't make you reach -->
Clearly, this is not one of those stories that promise to make you reach with content writing. It's just an honest review of what I tried and what worked for me, even if I wasn't very successful at the marketing bit. The lessons I learned on my journey are still valid.

<!-- what and ifs -->
I'm sure that given I don't have a lot of experience with technical writing or marketing there were surely other things that I could have tried:
- I could have just waited to reach a critical mass of free subscribers. Not that there is a simple rule to figure that number out.
- I could have spent more time marketing the article on social media.
- I could have bought some paid advertising on social media.
- I could have just chosen a better topic or just improved my writing a bit more.

<!-- sell a single paid article -->
Since I have cross-posted the article on Medium as well, I knew the content wasn't really a problem. I had analytics about this piece of content telling me there were lots of people interested in reading it, even behind a Medium paywall.

What if people were interested in the content, they would even have paid for it, but buying a monthly subscription was too much to ask. With that thought in mind, I thought that I could just transform my article into a magazine and then sell it on Gumroad as an eBook.

I mean, you hear so many successful stories on Medium, from people who made a fortune selling eBooks on Gumroad that I thought I'd give it a try. Reality is much different from what it's on the front page of the newspapers (or Medium and social media).

Given that I didn't manage to sell a single paid copy, I decided since then to make the eBook available to download with a pay-as-you-want option on Gumroad at [HashiCorp's open-source exodus](https://gsantoro.gumroad.com/l/udofm). 

## My journey into self-publishing software
<!-- available tools -->
Now the question was, what tool would you use to create a magazine in PDF format in 2023? The good old Microsoft Word (or Google Docs)? Or maybe I should opt for something more modern like Canva? What are professionals using these days for printed material? Is there anything open-source?

During my investigation, I evaluated a few different options that I will briefly list here with my take on them. This is not meant to be an exhaustive list but mostly my very personal take on them. Feel free to disagree.

## Microsoft Docs/Google Docs/OpenOffice
I still have horrible memories of creating Word documents in high school and spending a considerable amount of time moving images anytime I added more text. They were always in the wrong place and I had to spend a considerable amount of time on formatting.

I know that those software have considerably improved in the past 25 years but I still wouldn't venture using them for anything professional if I don't have to.

I am also aware that progress has been made on free templates but I am really looking for something more professional

## LaTeX: a typesetting system
I have used [LaTeX](https://www.latex-project.org/) for most of my academic career. I wrote my thesis in it and a couple of international publications as well. 

It's a great ecosystem comprised of a typesetting language, libraries, and software that goes with it.

It would have been a great choice if there was a already-made magazine template that would fit my needs.

I would have needed to just fill in the text of my article, a couple of images and I wouldn't have been done in an hour or so.

Unfortunately, there was only a quite limited set of options in terms of templates and I believe that customising the look and feel of a template or creating my template from scratch would have been a quite challenging endeavour.

So unfortunately, even if this would have been my first choice, it wasn't really what I was looking for

## Pandoc: the universal document converter
There is a tool called [Pandoc](https://pandoc.org/) that is advertised as the `a universal document converter`.

You could use it to convert Markdown to PDF or convert HTML to PDF.

Since there are great CSS templates for magazine websites, I thought that maybe I could export my Markdown article into an HTML page, apply some CSS formatting and finally convert it to PDF.

The result was absolutely horrible. Printing the PDF with the default browser's feature `Save as PDF`, yields a much better result than using Pandoc. Either of those wasn't what I was looking for.

I'm not sure if this is the default use of Pandoc or maybe I wasn't using it for what it is meant to be used.

Better trying something else

## What is Adobe InDesign?
[Abobe InDesign](https://www.adobe.com/uk/products/indesign.html) is the industry standard for desktop publishing and layout design.

Between the main features we can find:
- **Seamless Adobe Integration**: Easily integrates with other Adobe Creative Cloud apps like Photoshop and Illustrator for a cohesive workflow.
- **Print and Digital Publishing**: Ideal for creating print materials like magazines and brochures, as well as interactive digital content like PDFs and eBooks.
- **Comprehensive Feature Set**: Offers advanced typography control, master pages, liquid layout, and support for integrating complex graphics.
- **Cross-Platform Availability**: Available on both Mac and Windows operating systems, ensuring accessibility to a wide user base.

## What is Scribus?
[Scribus](https://www.scribus.net/) is an open-source desktop publishing (DTP) application that allows the creation of professional-quality documents, ranging from brochures and flyers to magazines and books. 

It is a versatile and highly capable software designed to meet the needs of graphic designers, publishers, and anyone else involved in layout and design tasks. 

Between the main features we can find:
- **Print and Digital Publishing**. The ability to create intricate page layouts, and manipulate text and images makes it an excellent choice for projects such as magazines, newspapers, newsletters, and even digital eBooks. Support a variety of file formats including PDF, SVG, EPS, and more
- **Open-source and free** to use.
- **Cross-Platform Availability**: available on all the major operating systems including Linux, Windows, or macOS.
- **Great user community**: Extensive list of forums, tutorials, and official documentation.


While researching for my article I found this great  [15-minute tutorial about creating a magazine with Scribus](https://www.youtube.com/watch?v=slbiQ0mJWbw&list=WL&index=1).

{{< youtube slbiQ0mJWbw >}}

## Scribus vs. Adobe InDesign: A comparison
In my very personal opinion, they are both great pieces of software with very similar capabilities.

I believe the biggest difference is probably the fact that Scribus is more oriented to the open-source community since it supports Linux.

I would guess that Scribus is probably used more by small shops and independent publishers with a tight budget while Adobe InDesign is probably a more polished solution with a top-end customer base.

I have to admit that given the limitation on Linux (or even a web solution) I couldn't even try to use Adobe InDesign. I wish that Adobe would provide a web version to open up to the Linux community or even to anyone with an Apple iPad.

I'm sure that Adobe InDesign, being a very expensive solution is much more polished, easier to use and overall a better product but a product should never be forced to buy a new laptop to try it. That's my personal opinion.

## Conclusion
In order to create my digital magazine in PDF format, I ended up using Scribus and I am very happy with the results. I'm sure I'll give it another try in the future.

The only negative point about Scribus is that given is not as famous as Adobe InDesign the learning curve might be a bit steeper or not as user-friendly.

Nonetheless, it took not more than a couple of days of watching online tutorials and trying things out to create a professional-looking magazine in the shape of a PDF eBook.

I just want to say that I am grateful to the open-source community for creating such a great piece of software. I'm sure that all the independent publishers out there might benefit from Scribus if they are on a budget.

I hope that this review might bring more people to evaluate Scribus as an alternative to Adobe InDesign as well as Google Docs/Microsoft Word.