# Key Naming Strategies for atPlatform Messaging: General-to-Specific vs Specific-to-General [19/06/2025]

_Note: This was partially created using Claude so it's not perfect_

## The Two Approaches

### General-to-Specific
Structure keys from broad categories down to specific items:

```
settings:notifications.app_namespace
conversations:active.app_namespace
conversation:789:messages:1001.app_namespace
conversation:789:participants:list.app_namespace
```

### Specific-to-General
Lead with the most specific identifier:

```
message:1001:conversation_id.app_namespace
message:1001:author_id.app_namespace
settings:notifications
participant:456:conversations:active.app_namespace
```

## Why General-to-Specific Works for atMail

### Natural Access Patterns
Messaging applications typically query data in these patterns:
* "Show me all settings for this atSign"
* "Get all messages in this conversation shared with me"
* "List all participants in conversations I'm part of"
* "Fetch my active conversations"
* "Retrieve cached conversation data from other atSigns"

These queries naturally start with an conversation identifier and drill down to specific data types, following the atKey structure.

### Efficient Prefix Queries with atKey Structure
With general-to-specific structure aligned to atKey patterns, you can efficiently retrieve related data:

```
# Get all user settings with a single prefix query
settings:*.app_namespace

# Get all conversation metadata shared with bob
@bob:conversation:789:*.app_namespace

# Get today's messages for a conversation
@bob:conversation:789:messages:2024-06-19:*.app_namespace

# Get cached conversation data
cached:@alice:conversation:*.app_namespace@bob
```
