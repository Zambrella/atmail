# Message UX

<!-- This template is inspired by
https://github.com/GoogleCloudPlatform/emblem/tree/main/docs/decisions -->

* **Status:** Draft
* **Last Updated:** 2025-07-06
* **Objective:** Decide on how the message UX will be implemented

## Context & Problem Statement
Traditionally, email messages are shown in a list with each message being clearly separated with all the metadata shown at the top of **each** message. This makes it easier to read long messages but can be overwhelming when dealing with multiple messages and knowing who sent them. Referencing previous messages can also be a chore.

On the other hand, instant messaging apps display just the sender's name, message content and delivery status. This makes it easier to read shorter messages but longer messages can be difficult to read. It also promotes a more conversational style of communication (i.e. shorter, less well thought out, information spread across multiple messages)

## Goals
Decide on how the message UX will be implemented

## Considered Options <!-- optional -->

* ### Email style

* ### Instant message style

* ### Something more like Slack/Zulip/Discord

## Proposal Summary
Something more like Slack/Zulip/Discord but where each message is still displayed separately (sometimes things like Slack or Discord will group messages from the same sender together). This should offer a happy medium between readability and formality. As this is likely to be used for "mission critical" information sharing, readability should come before aesthetics.
