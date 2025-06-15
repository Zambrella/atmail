// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_message.dart';

class AppMessageMapper extends ClassMapperBase<AppMessage> {
  AppMessageMapper._();

  static AppMessageMapper? _instance;
  static AppMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppMessageMapper._());
      MessageContentMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppMessage';

  static DateTime _$timestamp(AppMessage v) => v.timestamp;
  static const Field<AppMessage, DateTime> _f$timestamp =
      Field('timestamp', _$timestamp);
  static MessageContent _$content(AppMessage v) => v.content;
  static const Field<AppMessage, MessageContent> _f$content =
      Field('content', _$content);
  static MessageStatus _$status(AppMessage v) => v.status;
  static const Field<AppMessage, MessageStatus> _f$status =
      Field('status', _$status);
  static String _$sender(AppMessage v) => v.sender;
  static const Field<AppMessage, String> _f$sender = Field('sender', _$sender);
  static Map<String, dynamic> _$metadata(AppMessage v) => v.metadata;
  static const Field<AppMessage, Map<String, dynamic>> _f$metadata =
      Field('metadata', _$metadata, opt: true, def: const {});

  @override
  final MappableFields<AppMessage> fields = const {
    #timestamp: _f$timestamp,
    #content: _f$content,
    #status: _f$status,
    #sender: _f$sender,
    #metadata: _f$metadata,
  };

  static AppMessage _instantiate(DecodingData data) {
    return AppMessage(
        timestamp: data.dec(_f$timestamp),
        content: data.dec(_f$content),
        status: data.dec(_f$status),
        sender: data.dec(_f$sender),
        metadata: data.dec(_f$metadata));
  }

  @override
  final Function instantiate = _instantiate;

  static AppMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppMessage>(map);
  }

  static AppMessage fromJson(String json) {
    return ensureInitialized().decodeJson<AppMessage>(json);
  }
}

mixin AppMessageMappable {
  String toJson() {
    return AppMessageMapper.ensureInitialized()
        .encodeJson<AppMessage>(this as AppMessage);
  }

  Map<String, dynamic> toMap() {
    return AppMessageMapper.ensureInitialized()
        .encodeMap<AppMessage>(this as AppMessage);
  }

  AppMessageCopyWith<AppMessage, AppMessage, AppMessage> get copyWith =>
      _AppMessageCopyWithImpl<AppMessage, AppMessage>(
          this as AppMessage, $identity, $identity);
  @override
  String toString() {
    return AppMessageMapper.ensureInitialized()
        .stringifyValue(this as AppMessage);
  }

  @override
  bool operator ==(Object other) {
    return AppMessageMapper.ensureInitialized()
        .equalsValue(this as AppMessage, other);
  }

  @override
  int get hashCode {
    return AppMessageMapper.ensureInitialized().hashValue(this as AppMessage);
  }
}

extension AppMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppMessage, $Out> {
  AppMessageCopyWith<$R, AppMessage, $Out> get $asAppMessage =>
      $base.as((v, t, t2) => _AppMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppMessageCopyWith<$R, $In extends AppMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata;
  $R call(
      {DateTime? timestamp,
      MessageContent? content,
      MessageStatus? status,
      String? sender,
      Map<String, dynamic>? metadata});
  AppMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppMessage, $Out>
    implements AppMessageCopyWith<$R, AppMessage, $Out> {
  _AppMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppMessage> $mapper =
      AppMessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata => MapCopyWith($value.metadata,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(metadata: v));
  @override
  $R call(
          {DateTime? timestamp,
          MessageContent? content,
          MessageStatus? status,
          String? sender,
          Map<String, dynamic>? metadata}) =>
      $apply(FieldCopyWithData({
        if (timestamp != null) #timestamp: timestamp,
        if (content != null) #content: content,
        if (status != null) #status: status,
        if (sender != null) #sender: sender,
        if (metadata != null) #metadata: metadata
      }));
  @override
  AppMessage $make(CopyWithData data) => AppMessage(
      timestamp: data.get(#timestamp, or: $value.timestamp),
      content: data.get(#content, or: $value.content),
      status: data.get(#status, or: $value.status),
      sender: data.get(#sender, or: $value.sender),
      metadata: data.get(#metadata, or: $value.metadata));

  @override
  AppMessageCopyWith<$R2, AppMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AppMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
