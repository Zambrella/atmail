# atKey Naming: General-to-Specific Structure for Messaging

<!-- This template is inspired by
https://github.com/GoogleCloudPlatform/emblem/tree/main/docs/decisions -->

* **Status:** Approved
* **Last Updated:** 2025-06-19
* **Objective:** Establish general-to-specific atKey naming convention for atMail messaging patterns

## Context & Problem Statement

When designing atKey naming conventions for a messaging application on atPlatform, there are two fundamental approaches: general-to-specific (starting with broad categories) and specific-to-general (leading with the most specific identifier).

The choice of naming structure significantly impacts:
- Query efficiency when retrieving related data
- Developer ergonomics when working with the atProtocol
- Alignment with natural access patterns in messaging applications
- Ability to use prefix-based queries effectively

Without a clear decision on this foundational pattern, atKey naming would be inconsistent across the application, making it difficult to query data efficiently and maintain the codebase.

## Goals

- Establish a consistent atKey naming convention for atMail
- Optimize for common messaging query patterns (conversation lists, messages in conversations, participant data)
- Enable efficient prefix-based queries aligned with atKey structure
- Support both shared and cached data patterns

### Non-goals

- Defining the complete atKey schema for all atMail features (this ADR focuses on the naming strategy)
- Specifying namespace conventions (covered separately)
- Addressing cross-application atKey compatibility beyond this project

## Other considerations

Messaging applications typically query data in these patterns:
- "Show me all settings for this atSign"
- "Get all messages in this conversation shared with me"
- "List all participants in conversations I'm part of"
- "Fetch my active conversations"
- "Retrieve cached conversation data from other atSigns"

These queries naturally start with a conversation or category identifier and drill down to specific data types, which aligns well with the atKey structure.

## Considered Options

### Option 1: General-to-Specific

Structure keys from broad categories down to specific items:

```
settings:notifications.app_namespace
conversations:active.app_namespace
conversation:789:messages:1001.app_namespace
conversation:789:participants:list.app_namespace
```

**Pros:**
- Aligns with natural query patterns in messaging apps
- Efficient prefix queries using atKey structure
- Easy to retrieve all related data with single query pattern
- Intuitive for developers familiar with hierarchical data

**Cons:**
- May require longer key names for deeply nested data
- Could feel less natural if primary access is by message ID

**Decision:** CHOSEN - Natural alignment with messaging access patterns and atKey query capabilities makes this the clear winner.

### Option 2: Specific-to-General

Lead with the most specific identifier:

```
message:1001:conversation_id.app_namespace
message:1001:author_id.app_namespace
settings:notifications.app_namespace
participant:456:conversations:active.app_namespace
```

**Pros:**
- Quick access if you already know the specific ID
- May feel natural for entity-centric designs

**Cons:**
- Makes prefix-based queries for related data difficult
- Requires full ID to query, reducing discoverability
- Doesn't align well with "show me all X in Y" patterns
- Less efficient for conversation-scoped queries

**Decision:** NOT CHOSEN - Doesn't match typical messaging query patterns.

## Proposal Summary

Adopt general-to-specific atKey naming convention for atMail, structuring keys from broad categories (conversation, settings) down to specific items (individual messages, participant data).

## Proposal in Detail

### Key Structure Pattern

All atKeys in atMail will follow this hierarchy:

```
<category>:<scope>:<subcategory>:<identifier>.<namespace>
```

Examples:

```
# User settings - prefix query for all settings
settings:*.app_namespace

# Conversation metadata shared with bob
@bob:conversation:789:*.app_namespace

# Messages in a conversation on a specific date
@bob:conversation:789:messages:2025-06-19:*.app_namespace

# Cached conversation data from alice
cached:@alice:conversation:*.app_namespace@bob
```

### Query Pattern Examples

**Get all user settings:**
```
settings:*.app_namespace
```

**Get all conversation metadata shared with @bob:**
```
@bob:conversation:789:*.app_namespace
```

**Get today's messages for a conversation:**
```
@bob:conversation:789:messages:2025-06-19:*.app_namespace
```

**Get cached conversation data from @alice:**
```
cached:@alice:conversation:*.app_namespace@bob
```

### Implementation Guidelines

1. Always start with the broadest category (conversation, settings, etc.)
2. Use consistent separator (`:`) between hierarchy levels
3. Place timestamp or date components after the entity type
4. Keep namespace as the final component before `@` signs

### Expected Consequences

**Code Impact:**
- Repository layer will implement atKey generation following this pattern
- All existing prototype keys need migration to new structure
- Documentation and examples must reflect this convention

**Benefits:**
- Simplified data retrieval with prefix-based queries
- Consistent developer experience across the codebase
- Better performance for common messaging queries
- Easier debugging and key inspection

**Migration Required:**
- Any existing keys in development/test environments need restructuring
- Update all key generation code in repository implementations
- Update tests to use new key structure
