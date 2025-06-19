// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_conversation.dart';

class AppConversationMapper extends ClassMapperBase<AppConversation> {
  AppConversationMapper._();

  static AppConversationMapper? _instance;
  static AppConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppConversationMapper._());
      AppMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppConversation';

  static String _$id(AppConversation v) => v.id;
  static const Field<AppConversation, String> _f$id = Field('id', _$id);
  static String _$subject(AppConversation v) => v.subject;
  static const Field<AppConversation, String> _f$subject =
      Field('subject', _$subject);
  static List<String> _$participants(AppConversation v) => v.participants;
  static const Field<AppConversation, List<String>> _f$participants =
      Field('participants', _$participants);
  static DateTime _$createdAt(AppConversation v) => v.createdAt;
  static const Field<AppConversation, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String _$createdBy(AppConversation v) => v.createdBy;
  static const Field<AppConversation, String> _f$createdBy =
      Field('createdBy', _$createdBy);
  static List<AppMessage> _$messages(AppConversation v) => v.messages;
  static const Field<AppConversation, List<AppMessage>> _f$messages =
      Field('messages', _$messages);
  static String? _$previousConversationId(AppConversation v) =>
      v.previousConversationId;
  static const Field<AppConversation, String> _f$previousConversationId =
      Field('previousConversationId', _$previousConversationId, opt: true);
  static bool _$isArchived(AppConversation v) => v.isArchived;
  static const Field<AppConversation, bool> _f$isArchived =
      Field('isArchived', _$isArchived, opt: true, def: false);
  static bool _$hasLeft(AppConversation v) => v.hasLeft;
  static const Field<AppConversation, bool> _f$hasLeft =
      Field('hasLeft', _$hasLeft, opt: true, def: false);
  static Map<String, dynamic> _$metadata(AppConversation v) => v.metadata;
  static const Field<AppConversation, Map<String, dynamic>> _f$metadata =
      Field('metadata', _$metadata, opt: true, def: const {});

  @override
  final MappableFields<AppConversation> fields = const {
    #id: _f$id,
    #subject: _f$subject,
    #participants: _f$participants,
    #createdAt: _f$createdAt,
    #createdBy: _f$createdBy,
    #messages: _f$messages,
    #previousConversationId: _f$previousConversationId,
    #isArchived: _f$isArchived,
    #hasLeft: _f$hasLeft,
    #metadata: _f$metadata,
  };

  static AppConversation _instantiate(DecodingData data) {
    return AppConversation(
        id: data.dec(_f$id),
        subject: data.dec(_f$subject),
        participants: data.dec(_f$participants),
        createdAt: data.dec(_f$createdAt),
        createdBy: data.dec(_f$createdBy),
        messages: data.dec(_f$messages),
        previousConversationId: data.dec(_f$previousConversationId),
        isArchived: data.dec(_f$isArchived),
        hasLeft: data.dec(_f$hasLeft),
        metadata: data.dec(_f$metadata));
  }

  @override
  final Function instantiate = _instantiate;

  static AppConversation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppConversation>(map);
  }

  static AppConversation fromJson(String json) {
    return ensureInitialized().decodeJson<AppConversation>(json);
  }
}

mixin AppConversationMappable {
  String toJson() {
    return AppConversationMapper.ensureInitialized()
        .encodeJson<AppConversation>(this as AppConversation);
  }

  Map<String, dynamic> toMap() {
    return AppConversationMapper.ensureInitialized()
        .encodeMap<AppConversation>(this as AppConversation);
  }

  AppConversationCopyWith<AppConversation, AppConversation, AppConversation>
      get copyWith =>
          _AppConversationCopyWithImpl<AppConversation, AppConversation>(
              this as AppConversation, $identity, $identity);
  @override
  String toString() {
    return AppConversationMapper.ensureInitialized()
        .stringifyValue(this as AppConversation);
  }

  @override
  bool operator ==(Object other) {
    return AppConversationMapper.ensureInitialized()
        .equalsValue(this as AppConversation, other);
  }

  @override
  int get hashCode {
    return AppConversationMapper.ensureInitialized()
        .hashValue(this as AppConversation);
  }
}

extension AppConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppConversation, $Out> {
  AppConversationCopyWith<$R, AppConversation, $Out> get $asAppConversation =>
      $base.as((v, t, t2) => _AppConversationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppConversationCopyWith<$R, $In extends AppConversation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get participants;
  ListCopyWith<$R, AppMessage, AppMessageCopyWith<$R, AppMessage, AppMessage>>
      get messages;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata;
  $R call(
      {String? id,
      String? subject,
      List<String>? participants,
      DateTime? createdAt,
      String? createdBy,
      List<AppMessage>? messages,
      String? previousConversationId,
      bool? isArchived,
      bool? hasLeft,
      Map<String, dynamic>? metadata});
  AppConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AppConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppConversation, $Out>
    implements AppConversationCopyWith<$R, AppConversation, $Out> {
  _AppConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppConversation> $mapper =
      AppConversationMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get participants => ListCopyWith(
          $value.participants,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(participants: v));
  @override
  ListCopyWith<$R, AppMessage, AppMessageCopyWith<$R, AppMessage, AppMessage>>
      get messages => ListCopyWith($value.messages,
          (v, t) => v.copyWith.$chain(t), (v) => call(messages: v));
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
          List<AppMessage>? messages,
          Object? previousConversationId = $none,
          bool? isArchived,
          bool? hasLeft,
          Map<String, dynamic>? metadata}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (subject != null) #subject: subject,
        if (participants != null) #participants: participants,
        if (createdAt != null) #createdAt: createdAt,
        if (createdBy != null) #createdBy: createdBy,
        if (messages != null) #messages: messages,
        if (previousConversationId != $none)
          #previousConversationId: previousConversationId,
        if (isArchived != null) #isArchived: isArchived,
        if (hasLeft != null) #hasLeft: hasLeft,
        if (metadata != null) #metadata: metadata
      }));
  @override
  AppConversation $make(CopyWithData data) => AppConversation(
      id: data.get(#id, or: $value.id),
      subject: data.get(#subject, or: $value.subject),
      participants: data.get(#participants, or: $value.participants),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      createdBy: data.get(#createdBy, or: $value.createdBy),
      messages: data.get(#messages, or: $value.messages),
      previousConversationId:
          data.get(#previousConversationId, or: $value.previousConversationId),
      isArchived: data.get(#isArchived, or: $value.isArchived),
      hasLeft: data.get(#hasLeft, or: $value.hasLeft),
      metadata: data.get(#metadata, or: $value.metadata));

  @override
  AppConversationCopyWith<$R2, AppConversation, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AppConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
