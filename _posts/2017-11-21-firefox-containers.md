---
layout: post
title:  "Firefox Multi-Account Containers"
tags:   privacy shorts
githubCommentIssueID: 2
---

Firefox supports profiles which are similar to profiles in Chrome - a new instance/window with its own collection of settings, history, cookies and bookmarks. Using different profiles can be useful, especially when combined with cross-machine syncing. For example, you can create a separate personal work profile if there is too much overlap with your personal accounts.

Firefox also supports [Multi-Account Containers][containers] which are more lightweight. They separate out cookies and other tracking information about you, but share the same window, bookmarks and history. Essentially a container allows you to have separate identities for the same or different websites.

They could be used to sign into the same website with different accounts - imagine if Gmail didn't allow you to login to multiple accounts at the same time. Personally, I use them to contain Google to its own little box. This is easy to do because you can pin domains to containers, so that, for example, Google Docs will always open in a particular container. This is useful for me at the moment because it is not easy to open Google Sheets with a particular account.

The only usability issue that I have encountered is opening links in emails will open them in my Google container which is never what I want. I need to re-train my muscle memory to "Right-click > Open link in new container tab...".  Overall, these containers are easy to use!

[containers]: https://addons.mozilla.org/en-GB/firefox/addon/multi-account-containers/
