# Message Display UX: Balancing Formality and Readability

<!-- This template is inspired by
https://github.com/GoogleCloudPlatform/emblem/tree/main/docs/decisions -->

* **Status:** Draft
* **Last Updated:** 2025-07-06
* **Objective:** Define message display pattern that balances email formality with instant messaging readability

## Context & Problem Statement

AtMail aims to combine email formality with instant messaging immediacy. The message display pattern significantly impacts how users interact with the application and influences communication style.

Traditional email clients show messages in a list with full metadata (sender, subject, timestamp, recipients) prominently displayed for each message. This approach:
- Makes it easy to read long, detailed messages
- Provides complete context for each message
- Can be overwhelming when scanning multiple messages
- Makes referencing previous messages cumbersome

Instant messaging apps display minimal metadata (sender name, message content, delivery status). This approach:
- Optimizes for quick scanning of shorter messages
- Promotes conversational communication style (shorter, rapid-fire messages)
- Can make longer messages difficult to read
- Encourages less formal, less well-thought-out communication

AtMail targets "mission critical" information sharing, requiring a balance between the formality of email and the immediacy of instant messaging.

## Goals

- Define a message display pattern that supports both quick scanning and detailed reading
- Balance formality (complete context) with readability (minimal visual clutter)
- Support mission-critical communication where readability is paramount
- Prevent the overly casual communication style of typical instant messaging

### Non-goals

- Designing the complete UI mockups (this ADR focuses on the UX pattern)
- Specifying exact visual design elements (colors, spacing, typography)
- Addressing mobile vs desktop differences (though pattern should work for both)

## Other considerations

AtMail is positioned for "mission critical" information sharing, suggesting users will:
- Send fewer, more thoughtful messages than typical instant messaging
- Need to reference message context and metadata
- Require clear message boundaries for clarity
- Benefit from threading or conversation context

## Considered Options

### Option 1: Traditional Email Style

Display each message with full separation and complete metadata block:
- Full sender details (name, atSign)
- Timestamp
- Subject line
- Full recipient list
- Message body
- Clear visual separation between messages

**Pros:**
- Complete context for each message
- Familiar to users from email clients
- Easy to read long, detailed messages
- Clear message boundaries

**Cons:**
- Visual overhead when scanning many messages
- Can feel heavy and formal
- Referencing previous messages requires scrolling
- May encourage overly formal communication

**Decision:** NOT CHOSEN - Too heavy for the conversational aspect of atMail.

### Option 2: Instant Messaging Style

Minimal message display with grouping:
- Small sender avatar/name
- Message content
- Delivery status indicator
- Timestamp only on hover or periodically
- Messages from same sender grouped together

**Pros:**
- Quick scanning of message flow
- Feels immediate and conversational
- Minimal visual clutter
- Natural reading flow

**Cons:**
- Longer messages become difficult to read
- Grouped messages lose individual context
- Encourages rapid-fire, less thoughtful communication
- May not provide enough context for mission-critical use

**Decision:** NOT CHOSEN - Doesn't provide enough formality/context for mission-critical communication.

### Option 3: Slack/Discord/Zulip Style (Hybrid Approach)

Display each message separately (not grouped) with moderate metadata:
- Sender name and avatar for each message
- Timestamp for each message
- Message content with formatting support
- Delivery/read status
- Clear but lightweight separation between messages
- Compact vertical spacing

**Pros:**
- Balances formality with readability
- Each message maintains its context
- Readable for both short and long messages
- Prevents overly casual communication style
- Good for mission-critical scanning

**Cons:**
- May feel repetitive if same sender sends multiple messages
- Slightly more vertical space than grouped messaging

**Decision:** CHOSEN - Best balance for mission-critical communication that needs both formality and readability.

## Proposal Summary

Adopt a Slack/Discord-style message display pattern where each message is displayed separately with its own metadata (sender, timestamp), avoiding message grouping to maintain clarity and context for mission-critical communication.

## Proposal in Detail

### Message Display Pattern

Each message card will include:

1. **Sender Information** (always visible):
   - Avatar/profile picture
   - Display name
   - atSign (in subtle text)

2. **Timestamp** (always visible):
   - Relative time for recent messages ("2 minutes ago")
   - Absolute time for older messages ("Jun 19, 3:42 PM")

3. **Message Content**:
   - Full markdown/rich text support
   - Proper line breaks and formatting
   - Code blocks and inline code
   - Links and embedded content

4. **Status Indicators**:
   - Delivery status (sent, delivered)
   - Read receipts (if enabled)

5. **Visual Separation**:
   - Subtle background or border for each message
   - Compact vertical spacing (not as dense as IM, not as spacious as email)
   - Clear visual boundaries

### No Message Grouping

Unlike Slack or Discord which group consecutive messages from the same sender, atMail will display each message separately. This ensures:
- Each message has complete context
- Easier to reference specific messages
- Clearer for mission-critical scanning
- Better readability over aesthetics

### Example Layout

```
┌─────────────────────────────────────────┐
│ [Avatar] Alice @alice      2:45 PM      │
│ Have you reviewed the deployment plan?  │
│                                    [✓✓] │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ [Avatar] Bob @bob          2:47 PM      │
│ Yes, I think we should add a rollback   │
│ strategy for the database migrations.   │
│                                    [✓✓] │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ [Avatar] Bob @bob          2:47 PM      │
│ I can draft that section now.           │
│                                    [✓]  │
└─────────────────────────────────────────┘
```

### Expected Consequences

**Implementation Impact:**
- Message card UI component needs to be designed
- All message displays (conversation view, search results) use consistent pattern
- Mobile and desktop layouts follow same pattern with responsive adjustments

**User Experience:**
- Users will see full context for each message
- Readability prioritized over visual compactness
- May feel slightly more formal than typical instant messaging
- Better support for mission-critical communication

**Future Considerations:**
- May add optional threading/replies as separate feature
- Could introduce message grouping as user preference later if needed
- Animation and transitions can make message flow feel more natural
