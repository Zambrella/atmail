// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation.dart';

class ConversationMapper extends ClassMapperBase<Conversation> {
  ConversationMapper._();

  static ConversationMapper? _instance;
  static ConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Conversation';

  static String _$id(Conversation v) => v.id;
  static const Field<Conversation, String> _f$id = Field('id', _$id);
  static String _$subject(Conversation v) => v.subject;
  static const Field<Conversation, String> _f$subject =
      Field('subject', _$subject);
  static List<String> _$participants(Conversation v) => v.participants;
  static const Field<Conversation, List<String>> _f$participants =
      Field('participants', _$participants);
  static DateTime _$createdAt(Conversation v) => v.createdAt;
  static const Field<Conversation, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String _$createdBy(Conversation v) => v.createdBy;
  static const Field<Conversation, String> _f$createdBy =
      Field('createdBy', _$createdBy);
  static String? _$previousConversationId(Conversation v) =>
      v.previousConversationId;
  static const Field<Conversation, String> _f$previousConversationId =
      Field('previousConversationId', _$previousConversationId, opt: true);
  static Map<String, dynamic> _$metadata(Conversation v) => v.metadata;
  static const Field<Conversation, Map<String, dynamic>> _f$metadata =
      Field('metadata', _$metadata, opt: true, def: const {});

  @override
  final MappableFields<Conversation> fields = const {
    #id: _f$id,
    #subject: _f$subject,
    #participants: _f$participants,
    #createdAt: _f$createdAt,
    #createdBy: _f$createdBy,
    #previousConversationId: _f$previousConversationId,
    #metadata: _f$metadata,
  };

  static Conversation _instantiate(DecodingData data) {
    return Conversation(
        id: data.dec(_f$id),
        subject: data.dec(_f$subject),
        participants: data.dec(_f$participants),
        createdAt: data.dec(_f$createdAt),
        createdBy: data.dec(_f$createdBy),
        previousConversationId: data.dec(_f$previousConversationId),
        metadata: data.dec(_f$metadata));
  }

  @override
  final Function instantiate = _instantiate;

  static Conversation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Conversation>(map);
  }

  static Conversation fromJson(String json) {
    return ensureInitialized().decodeJson<Conversation>(json);
  }
}

mixin ConversationMappable {
  String toJson() {
    return ConversationMapper.ensureInitialized()
        .encodeJson<Conversation>(this as Conversation);
  }

  Map<String, dynamic> toMap() {
    return ConversationMapper.ensureInitialized()
        .encodeMap<Conversation>(this as Conversation);
  }

  ConversationCopyWith<Conversation, Conversation, Conversation> get copyWith =>
      _ConversationCopyWithImpl<Conversation, Conversation>(
          this as Conversation, $identity, $identity);
  @override
  String toString() {
    return ConversationMapper.ensureInitialized()
        .stringifyValue(this as Conversation);
  }

  @override
  bool operator ==(Object other) {
    return ConversationMapper.ensureInitialized()
        .equalsValue(this as Conversation, other);
  }

  @override
  int get hashCode {
    return ConversationMapper.ensureInitialized()
        .hashValue(this as Conversation);
  }
}

extension ConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Conversation, $Out> {
  ConversationCopyWith<$R, Conversation, $Out> get $asConversation =>
      $base.as((v, t, t2) => _ConversationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConversationCopyWith<$R, $In extends Conversation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get participants;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata;
  $R call(
      {String? id,
      String? subject,
      List<String>? participants,
      DateTime? createdAt,
      String? createdBy,
      String? previousConversationId,
      Map<String, dynamic>? metadata});
  ConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Conversation, $Out>
    implements ConversationCopyWith<$R, Conversation, $Out> {
  _ConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Conversation> $mapper =
      ConversationMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get participants => ListCopyWith(
          $value.participants,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(participants: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata => MapCopyWith($value.metadata,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(metadata: v));
  @override
  $R call(
          {String? id,
          String? subject,
          List<String>? participants,
          DateTime? createdAt,
          String? createdBy,
          Object? previousConversationId = $none,
          Map<String, dynamic>? metadata}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (subject != null) #subject: subject,
        if (participants != null) #participants: participants,
        if (createdAt != null) #createdAt: createdAt,
        if (createdBy != null) #createdBy: createdBy,
        if (previousConversationId != $none)
          #previousConversationId: previousConversationId,
        if (metadata != null) #metadata: metadata
      }));
  @override
  Conversation $make(CopyWithData data) => Conversation(
      id: data.get(#id, or: $value.id),
      subject: data.get(#subject, or: $value.subject),
      participants: data.get(#participants, or: $value.participants),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      createdBy: data.get(#createdBy, or: $value.createdBy),
      previousConversationId:
          data.get(#previousConversationId, or: $value.previousConversationId),
      metadata: data.get(#metadata, or: $value.metadata));

  @override
  ConversationCopyWith<$R2, Conversation, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
