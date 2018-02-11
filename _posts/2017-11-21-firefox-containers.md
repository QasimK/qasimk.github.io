---
layout: post
title:  "Firefox Multi-Account Containers"
tags:   privacy shorts
githubCommentIssueID: 2
---

Firefox supports profiles which are similar to profiles in Chrome - a new instance/window with its own collection of settings, history, cookies and bookmarks. This can be useful, especially when combined with Sync, for example, you can create separate personal and work profiles which usually (hopefully!) don't overlap with each other.

Firefox also supports [Multi-Account Containers][containers] which are more lightweight. They separate out cookies and other tracking information about you, but share the same window, bookmarks and history. Essentially a container allows you to have separate identities for the same or different websites.

They could be used to sign into the same website with different accounts - imagine if Gmail didn't allow you to login to multiple accounts at the same time. Personally, I use them to contain Google to its own box. This is easy to do because you can pin domains to containers, so that, for example, Gmail will always open in a particular container.

[containers]: https://addons.mozilla.org/en-GB/firefox/addon/multi-account-containers/
