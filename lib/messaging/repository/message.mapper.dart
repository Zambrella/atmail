// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message.dart';

class MessageMapper extends ClassMapperBase<Message> {
  MessageMapper._();

  static MessageMapper? _instance;
  static MessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageMapper._());
      MessageContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Message';

  static DateTime _$timestamp(Message v) => v.timestamp;
  static const Field<Message, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$conversationId(Message v) => v.conversationId;
  static const Field<Message, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
  );
  static MessageContent _$content(Message v) => v.content;
  static const Field<Message, MessageContent> _f$content = Field(
    'content',
    _$content,
  );
  static String _$from(Message v) => v.from;
  static const Field<Message, String> _f$from = Field('from', _$from);
  static String _$to(Message v) => v.to;
  static const Field<Message, String> _f$to = Field('to', _$to);
  static Map<String, dynamic> _$metadata(Message v) => v.metadata;
  static const Field<Message, Map<String, dynamic>> _f$metadata = Field(
    'metadata',
    _$metadata,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<Message> fields = const {
    #timestamp: _f$timestamp,
    #conversationId: _f$conversationId,
    #content: _f$content,
    #from: _f$from,
    #to: _f$to,
    #metadata: _f$metadata,
  };

  static Message _instantiate(DecodingData data) {
    return Message(
      timestamp: data.dec(_f$timestamp),
      conversationId: data.dec(_f$conversationId),
      content: data.dec(_f$content),
      from: data.dec(_f$from),
      to: data.dec(_f$to),
      metadata: data.dec(_f$metadata),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Message fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Message>(map);
  }

  static Message fromJson(String json) {
    return ensureInitialized().decodeJson<Message>(json);
  }
}

mixin MessageMappable {
  String toJson() {
    return MessageMapper.ensureInitialized().encodeJson<Message>(
      this as Message,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageMapper.ensureInitialized().encodeMap<Message>(
      this as Message,
    );
  }

  MessageCopyWith<Message, Message, Message> get copyWith =>
      _MessageCopyWithImpl<Message, Message>(
        this as Message,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageMapper.ensureInitialized().stringifyValue(this as Message);
  }

  @override
  bool operator ==(Object other) {
    return MessageMapper.ensureInitialized().equalsValue(
      this as Message,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageMapper.ensureInitialized().hashValue(this as Message);
  }
}

extension MessageValueCopy<$R, $Out> on ObjectCopyWith<$R, Message, $Out> {
  MessageCopyWith<$R, Message, $Out> get $asMessage =>
      $base.as((v, t, t2) => _MessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageCopyWith<$R, $In extends Message, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    DateTime? timestamp,
    String? conversationId,
    MessageContent? content,
    String? from,
    String? to,
    Map<String, dynamic>? metadata,
  });
  MessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Message, $Out>
    implements MessageCopyWith<$R, Message, $Out> {
  _MessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Message> $mapper =
      MessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    DateTime? timestamp,
    String? conversationId,
    MessageContent? content,
    String? from,
    String? to,
    Map<String, dynamic>? metadata,
  }) => $apply(
    FieldCopyWithData({
      if (timestamp != null) #timestamp: timestamp,
      if (conversationId != null) #conversationId: conversationId,
      if (content != null) #content: content,
      if (from != null) #from: from,
      if (to != null) #to: to,
      if (metadata != null) #metadata: metadata,
    }),
  );
  @override
  Message $make(CopyWithData data) => Message(
    timestamp: data.get(#timestamp, or: $value.timestamp),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    content: data.get(#content, or: $value.content),
    from: data.get(#from, or: $value.from),
    to: data.get(#to, or: $value.to),
    metadata: data.get(#metadata, or: $value.metadata),
  );

  @override
  MessageCopyWith<$R2, Message, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

