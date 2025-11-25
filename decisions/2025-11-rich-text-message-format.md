# Rich Text Message Format

* **Status:** Draft
* **Last Updated:** 2025-11-25
* **Objective:** Define the format and implementation approach for rich text messaging in AtMail

## Context & Problem Statement

AtMail currently only supports plain text messages (`TextContent`). Modern messaging applications provide rich text formatting capabilities such as bold, italic, links, and lists. Users expect these features for effective communication that combines email formality with instant messaging immediacy.

The codebase already has a `MarkdownContent` class defined in the domain model but marked as `UnimplementedError` in the presentation layer. We need to decide:
1. What format to use for storing and transmitting rich text
2. How to handle versioning and backwards compatibility
3. What subset of formatting features to support initially
4. How to ensure graceful degradation across different client versions

Given that AtMail uses atProtocol for message storage and synchronization, messages persist across devices and may be viewed on clients with different capabilities. We need a format that is extensible, well-specified, and handles compatibility gracefully.

## Goals

- Enable users to format messages with common rich text features (bold, italic, links, lists, etc.)
- Provide a hybrid input approach supporting both markdown syntax and toolbar buttons
- Ensure messages render consistently across clients
- Support graceful degradation when clients have different feature support
- Allow future extension to additional formatting features
- Maintain backwards compatibility with existing plain text messages

### Non-goals

- Supporting full HTML or complex document formatting (tables, embedded media, etc.) in version 1.0
- WYSIWYG editing where the input field itself shows formatted text
- Retroactive conversion of existing `TextContent` messages to markdown
- Real-time collaborative editing with operational transforms

## Other considerations

**atProtocol Integration:**
Messages are stored using the key pattern `conv.{id}.msg.{timestamp}.{namespace}` and synchronized across devices via atServer. The format must serialize cleanly via `dart_mappable` and remain human-readable for debugging.

**Mobile Performance:**
Flutter rendering of markdown must be efficient for scrolling through long conversation histories on mobile devices.

**User Experience:**
The app combines "email formality with instant messaging immediacy" - formatting should enhance clarity without adding friction to quick messaging.

## Considered Options

### Option 1: CommonMark Subset with Version Metadata (Chosen)

Store structured metadata with the markdown text:

```dart
@MappableClass()
class MarkdownContent extends MessageContent {
  const MarkdownContent({
    required this.markdown,
    required this.version,
    required this.features,
  });

  final String markdown;           // Raw markdown text
  final String version;             // Format version (e.g., "1.0")
  final List<String> features;     // Features used in this message
}
```

Use CommonMark (standardized markdown specification) with a restricted feature set for version 1.0:
- `bold` - `**text**` or `__text__`
- `italic` - `*text*` or `_text_`
- `strikethrough` - `~~text~~`
- `inline_code` - `` `code` ``
- `link` - `[text](url)`
- `unordered_list` - `- item` or `* item`
- `blockquote` - `> text`

Rendering uses `flutter_markdown` package with configuration to disable unsupported features.

**Pros:**
- CommonMark is a strict, unambiguous specification - no parser inconsistencies
- Version field enables explicit compatibility checks
- Features list allows validation before sending and rendering
- `flutter_markdown` is mature (7k+ pub points) and actively maintained
- Clear upgrade path: bump version, enable new features in configuration
- Format metadata makes compatibility decisions trivial
- Raw markdown preserved for debugging and fallback display

**Cons:**
- Slightly more complex storage than raw markdown string (additional fields)
- Need to maintain feature list alongside version number
- Requires parsing markdown to populate features list before sending

**Why chosen:**
This approach balances flexibility with simplicity. CommonMark is a solid standard that eliminates ambiguity. The structured metadata makes version management explicit and enables graceful degradation. The overhead of additional fields is minimal compared to the benefits of clear compatibility handling.

### Option 2: Simple Markdown String with Version Prefix

Store markdown with version prefix embedded in the text: `v1.0\n**bold text**`

The version prefix dictates which markdown features are "legal" for that message. Simpler storage model with just a string field.

**Pros:**
- Simpler storage - just a string with version prefix
- Easy to debug - can read the raw stored value directly
- Less overhead than structured format
- Still allows version-based compatibility checks

**Cons:**
- Version prefix could be confused with actual message content
- No explicit feature list - must infer from version or parse markdown
- Harder to validate on send - need to parse markdown to check features
- Requires string manipulation to extract version before rendering
- Ambiguous if user actually wants to start message with "v1.0"

**Why not chosen:**
The storage simplicity doesn't outweigh the loss of explicit metadata. Embedding version in content creates ambiguity and makes validation harder.

### Option 3: Custom AST Storage

Parse markdown into Abstract Syntax Tree (AST) on send and store as JSON:

```json
{
  "version": "1.0",
  "nodes": [
    {"type": "text", "content": "Hello "},
    {"type": "bold", "children": [{"type": "text", "content": "world"}]}
  ]
}
```

Clients render from AST rather than parsing markdown.

**Pros:**
- Unambiguous - no parser differences between clients
- Can validate features before sending by inspecting AST
- Easy to transform/migrate between versions
- No markdown parsing needed on receive

**Cons:**
- Significantly more complex storage format
- Much harder to debug - can't easily read stored messages
- More code to maintain (AST serialization/deserialization)
- Loses markdown as human-readable source of truth
- AST structure becomes part of protocol - harder to evolve
- Increased payload size

**Why not chosen:**
This is over-engineering for the problem. CommonMark parsers are consistent enough that storing the AST doesn't provide meaningful benefits. The loss of human readability and increased complexity aren't justified.

## Proposal Summary

Use CommonMark markdown with structured version metadata (`MarkdownContent` with `markdown`, `version`, and `features` fields). Version 1.0 supports a conservative feature set: bold, italic, strikethrough, inline code, links, unordered lists, and blockquotes. Render with `flutter_markdown` configured to disable unsupported features. When clients encounter messages with unsupported features, render with best effort and display a warning badge.

## Proposal in Detail

### Data Model

Update the existing `MarkdownContent` class in `lib/messaging/domain/message_content.dart`:

```dart
@MappableClass()
class MarkdownContent extends MessageContent with MarkdownContentMappable {
  const MarkdownContent({
    required this.markdown,
    required this.version,
    required this.features,
  });

  /// Raw markdown text with formatting syntax
  final String markdown;

  /// Format version (e.g., "1.0")
  final String version;

  /// List of markdown features used in this message
  /// Valid v1.0 features: bold, italic, strikethrough, inline_code,
  /// link, unordered_list, blockquote
  final List<String> features;
}
```

The `dart_mappable` code generation will handle serialization automatically.

### Supported Features - Version 1.0

Version 1.0 defines the following feature set:

| Feature | Markdown Syntax | Example |
|---------|----------------|---------|
| `bold` | `**text**` or `__text__` | `**Hello**` |
| `italic` | `*text*` or `_text_` | `*world*` |
| `strikethrough` | `~~text~~` | `~~mistake~~` |
| `inline_code` | `` `text` `` | `` `code` `` |
| `link` | `[text](url)` | `[Atsign](https://atsign.com)` |
| `unordered_list` | `- item` or `* item` | `- First item` |
| `blockquote` | `> text` | `> Quote` |

These features cover standard messaging needs while remaining simple to implement and render.

### Message Input

Users can input rich text using a hybrid approach:

1. **Markdown Syntax:** Type markdown directly (e.g., `**bold**`)
2. **Toolbar Buttons:** Use formatting toolbar above input field

**Toolbar Implementation:**
- Buttons for each supported feature (B, I, S, code, link, list, quote)
- When text is selected: wrap selection with appropriate markdown syntax
- When no selection: insert markdown syntax at cursor position
- For links: show dialog to input URL, then insert `[text](url)`

**Live Preview:**
- Toggle button to show/hide preview pane below input field
- Preview pane renders markdown using `flutter_markdown` (same renderer as message display)
- Updates with debounce (300ms) to avoid excessive rendering during typing

**Validation Before Send:**
1. Parse markdown to identify features used
2. Check features against version 1.0 allowed list
3. If unsupported features detected: show warning with option to strip or cancel
4. Populate `features` list in `MarkdownContent`
5. Set `version` to "1.0"

### Message Rendering

Update `lib/messaging/presentation/message_card.dart` to render `MarkdownContent`:

```dart
switch (widget.message.content) {
  case TextContent(:final text) => Text(text),
  case MarkdownContent(:final markdown, :final version, :final features) =>
    _MarkdownMessageBody(
      markdown: markdown,
      version: version,
      features: features,
    ),
  case BinaryContent() => throw UnimplementedError(),
  case DeletedContent() => Text('Message deleted'),
}
```

**Rendering Pipeline:**

1. **Version Check:** Compare message version with client's supported version ("1.0")
2. **Feature Validation:** Check if all features in message are supported by client
3. **Render Decision:**
   - If version ≤ supported AND all features supported: Render normally
   - If version > supported OR unsupported features: Best-effort render + warning badge
4. **Display Warning:** Small icon/badge next to timestamp with tooltip explaining unsupported features

**flutter_markdown Configuration:**

```dart
MarkdownBody(
  data: markdown,
  extensionSet: md.ExtensionSet.none,
  blockSyntaxes: [
    md.UnorderedListSyntax(),
    md.BlockquoteSyntax(),
  ],
  inlineSyntaxes: [
    md.StrikethroughSyntax(),
  ],
  // Bold, italic, inline code, links are built-in
  // Explicitly disabled: headers, tables, images, code blocks, ordered lists
)
```

Apply theme-consistent styling:
- Bold/italic: Use theme text styles
- Links: Theme primary color, underlined
- Inline code: Monospace font, subtle background
- Blockquotes: Left border, indented, muted text color
- Lists: Proper indentation and bullets

### Backwards Compatibility

**With Plain Text:**
- Existing `TextContent` messages remain unchanged
- No retroactive conversion to markdown
- Both `TextContent` and `MarkdownContent` coexist in conversations
- UI renders both types appropriately

**Cross-Version Messages:**
- When client receives message with newer version: Render with best effort, show warning badge
- When client receives message with older/same version: Render normally if all features supported
- `flutter_markdown` treats unknown syntax as plain text (graceful degradation)

**Feature Detection:**
- Features list enables precise compatibility checking
- Client can decide per-feature whether to attempt rendering or show fallback

### Security Considerations

**XSS Protection:**
- `flutter_markdown` sanitizes HTML by default (doesn't render raw HTML tags)
- URL validation for links - must be valid http/https URLs
- No JavaScript execution possible in rendered markdown

**Input Validation:**
- Character limit on messages (e.g., 10,000 characters)
- Feature validation before send prevents unsupported syntax
- Malformed markdown degrades to plain text (no crash)

### Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_markdown: ^0.7.0
  markdown: ^7.0.0  # Required peer dependency for flutter_markdown
```

Both packages are well-maintained and widely used in the Flutter ecosystem.

### Migration Path for Future Versions

When adding new features (e.g., images, tables, code blocks):

1. Define new version number (e.g., "1.1" or "2.0")
2. Add new feature identifiers to allowed list
3. Update `flutter_markdown` configuration to enable new features
4. Update input toolbar with new format buttons
5. Clients with older versions will render best-effort with warning badge

No breaking changes to existing version 1.0 messages.

### Expected Consequences

**Code Changes Required:**
- Update `MarkdownContent` class with `version` and `features` fields
- Run `dart run build_runner build` to regenerate mappers
- Implement `_MarkdownMessageBody` widget in `message_card.dart`
- Create `MarkdownToolbar` widget for message composer
- Create preview pane widget with toggle
- Implement markdown parsing for feature detection
- Add validation logic before sending messages
- Add `flutter_markdown` and `markdown` dependencies

**Breaking Changes:**
- None. Existing `TextContent` messages continue to work.
- Adding fields to `MarkdownContent` doesn't break serialization (new messages use new format)

**Migration Path:**
- No data migration needed
- New messages default to `MarkdownContent` format
- Users can send rich text immediately after update

**Testing Requirements:**
- Unit tests for `MarkdownContent` serialization
- Unit tests for feature detection from markdown strings
- Widget tests for markdown rendering (all v1.0 features)
- Widget tests for toolbar button insertion logic
- Integration tests for send/receive markdown messages
- Manual testing for copy-paste markdown, malformed syntax, very long messages

**Impact on atProtocol Storage:**
- Message payload size increases slightly (adds version string and features array)
- No changes to key structure (`conv.{id}.msg.{timestamp}.{namespace}`)
- Existing `ccd=true` cache settings remain appropriate

**User Experience Impact:**
- Positive: Users can format messages for clarity
- Positive: Hybrid input accommodates both markdown-savvy and toolbar-preferring users
- Positive: Preview pane builds confidence in formatting
- Minimal friction: Input remains simple text field by default
- Clear feedback: Warning badges when viewing messages with unsupported features

**Performance Considerations:**
- `flutter_markdown` rendering is efficient for typical message lengths
- Debounced preview (300ms) prevents excessive re-renders during typing
- Feature detection requires parsing markdown before send (negligible overhead)
- No impact on message list scrolling performance
