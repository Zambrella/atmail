# atMail

## Ideas and future considerations:
- Create message and conversation indexes to make fetching conversations more efficient. It can be a background process that the client runs. E.g. for messages, `conv.{{conversationId}}.msgIndex.1` contains the message Ids of the first 100 messages in the conversation with a timestamp for each message. This could then be iterated over to fetch the conversations or the start and end timestamps for regex-ing the messages.
- Create an event log for conversations. Everyone can maintain their own copy and it can be used to track changes and updates to conversations.
- Use immutable keys (new atsign feature) where possible.

## Outstanding decisions:
- [ ] Is the fork on change approach going to be transparent to the user? E.g. will the user see a new conversation as started or will it all be part of the same conversation chain?

## Why atmail exists
atmail is a messaging service meant to be a hybrid between email and instant messaging:
- The formality of email
- The immediacy of instant messaging
- The ease of use of instant messaging

Initially, it is designed to be used by professionals and organisations adopting the atsign technology.

atmail is built around "conversations" and can be thought of as analogous to their real-life counterparts. You are only privy to the conversations you start or are invited to. You don't know anything about the conversations you were not part of before hand. Conversations can also evolve over time and this is where the fork-on-change approach comes into play.

## Conversation Architecture
atmail's conversation model addresses the atProtocol's single-owner constraint through an immutable conversation design with a fork-on-change approach. Rather than attempting distributed consensus for group state management, conversation metadata remains immutable after creation. When modifications are required—such as participant changes or metadata updates—the system creates a new conversation that references the previous one via `previous_conversation_id`, establishing clear lineage tracking.

Participant management uses a status-based signaling mechanism where members set a shared `status.{{convId}}` key to indicate departure, creating explicit communication boundaries. The system employs differential cascade delete policies: conversations use `ccd: false` to persist beyond creator lifecycle, while individual messages use `ccd: true` to enable proper deletion semantics. This leverages the atProtocol's caching behavior to ensure conversation data remains accessible to participants even after the original owner leaves, while still allowing granular message-level control (i.e. each message belongs to the sender and they maintain full control over their content). The architecture treats the single-owner limitation as a design feature rather than a constraint, using the protocol's natural ownership and caching mechanisms to create predictable conversation lifecycle management.

Message deletion can either leave a sentinel message or completely remove the message from the conversation history.

### Deleting conversations


### Archiving conversations
Archiving conversations is a way for users to signal they are not interested in the conversation so should not be loaded by default. This is just from the perspective of the user who is archiving the message and is different to "leaving" the conversation. When a conversation is archived, an individual archive key (`conv.{conversationId}.archived`) is created containing the timestamp when the conversation was archived.

### Key Structure & Relationships
#### 1. **Conversation Keys** (`conv.{conversationId}.{namespace}`)
- **Purpose**: Store the core conversation metadata
- **Structure**: `<@recipient>:conv.<conversationId>.<namespace>@<sender>`
- **Example**: `@bob:conv.uuid-1234.atmail@alice`
- **Contains**: Subject, participants list, creation timestamp, creator, metadata
- **Sharing**: Shared with all participants using `AtKey.shared()`
- **Cache**: Set to `-1` with `ccd=false` to ensure data is always available

#### 2. **Message Keys** (`conv.{conversationId}.msg.{timestamp}.{namespace}`)
- **Purpose**: Store individual messages within conversations
- **Structure**: `<@recipient>:conv.<conversationId>.msg.<timestamp>.<namespace>@<sender>`
- **Example**: `@alice:conv.uuid-1234.msg.1679123456789.atmail@bob`
- **Contains**: Message content, sender, recipient, timestamp, metadata
- **Sharing**: Shared with each participant individually
- **Cache**: Set to `-1` with `ccd=true` so that recipients do not retain the message upon deletion

#### 3. **Archive Keys** (`conv.{conversationId}.archived.{namespace}`)
- **Purpose**: Track when a conversation was archived by the user
- **Structure**: `conv.<conversationId>.archived.<namespace>`
- **Example**: `conv.uuid-1234.archived.atmail`
- **Contains**: ISO timestamp of when the conversation was archived
- **Sharing**: Private to the user (not shared)

#### 4. **Status Keys** (`status.{conversationId}.{namespace}`)
- **Purpose**: Track participant status (e.g., left conversation)
- **Structure**: `<@recipient>:status.<conversationId>.<namespace>@<sender>`
- **Example**: `@bob:status.uuid-1234.atmail@alice`
- **Contains**: Status information (e.g., "left", timestamp)
- **Sharing**: Shared from leaving participant to others

## Data Flow

### Starting a Conversation

1. **Create Conversation Object**
   - Generate unique conversation ID (UUID)
   - Set subject, participants, and metadata

2. **Store Conversation Data**
   - Create `conv` key for each participant
   - Store conversation metadata
   - Send notifications to all participants

3. **Send Initial Message**
   - Create message key with broad-to-specific pattern
   - Share with all participants
   - Track delivery status

### Message Flow

```
Sender → Creates Message → Stores with msg key → Notifies Recipients
                ↓
        Updates Local State
                ↓
        Tracks Status (Pending → Sent → Delivered)
```

### Real-time Synchronization

The repository uses two notification streams:

1. **Conversation Notifications** (`conv.*` pattern)
   - Monitors new conversations
   - Updates to existing conversations
   - Deletion events

2. **Message Notifications** (`conv.*.msg.*` pattern)
   - New messages in conversations
   - Message deletions
   - Real-time updates

## Key Management Strategies

### Efficient Loading

The repository loads conversations from multiple sources:

1. **Sent Conversations**: Keys where current user is the creator
2. **Received Conversations**: Cached keys from other participants

### Deduplication

Messages are deduplicated using a composite key:
```dart
final key = '${message.timestamp.millisecondsSinceEpoch}_${message.sender}';
```

### Group Conversations

For group conversations, the system:
- Creates individual `conv.{conversationId}` keys for each participant
- Sends messages using `conv.{conversationId}.msg.{timestamp}` pattern to all participants except the sender
- Checks participant status before sending (skip if left)

## State Management

The repository maintains a single source of truth using RxDart:

```dart
final BehaviorSubject<List<AppConversation>> _conversations =
    BehaviorSubject<List<AppConversation>>.seeded([]);
```

All operations update this central state, ensuring:
- Consistent view across the app
- Reactive updates to UI
- Efficient memory usage

## Error Handling & Resilience

- **Periodic Refresh**: Every 30 seconds to catch missed notifications
- **Graceful Degradation**: Continue operation even if some keys fail
- **Status Checks**: Verify participants haven't left before sending messages
- **Comprehensive Logging**: Track all operations for debugging
