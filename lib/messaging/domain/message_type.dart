import 'package:dart_mappable/dart_mappable.dart';

part 'message_type.mapper.dart';

@MappableEnum()
enum MessageType {
  plainText,
  markdown,
  binary,
}
