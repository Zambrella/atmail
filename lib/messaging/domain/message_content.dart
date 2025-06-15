import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

part 'message_content.mapper.dart';

@MappableClass()
sealed class MessageContent with MessageContentMappable {
  const MessageContent();
}

@MappableClass()
class TextContent extends MessageContent with TextContentMappable {
  const TextContent(this.text);

  final String text;
}

@MappableClass()
class MarkdownContent extends MessageContent with MarkdownContentMappable {
  const MarkdownContent(this.text);

  final String text;
}

@MappableClass()
class BinaryContent extends MessageContent with BinaryContentMappable {
  const BinaryContent(this.data);

  final Uint8List data;
}

/// Sentinel for messages that have been deleted and the sender wants others to know it has been deleted.
@MappableClass()
class DeletedContent extends MessageContent with DeletedContentMappable {
  const DeletedContent();
}
