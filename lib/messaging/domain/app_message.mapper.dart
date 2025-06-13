// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_message.dart';

class MessageStatusMapper extends ClassMapperBase<MessageStatus> {
  MessageStatusMapper._();

  static MessageStatusMapper? _instance;
  static MessageStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusMapper._());
      MessageStatusPendingMapper.ensureInitialized();
      MessageStatusSentMapper.ensureInitialized();
      MessageStatusDeliveredMapper.ensureInitialized();
      MessageStatusErrorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageStatus';

  @override
  final MappableFields<MessageStatus> fields = const {};

  static MessageStatus _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('MessageStatus');
  }

  @override
  final Function instantiate = _instantiate;

  static MessageStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageStatus>(map);
  }

  static MessageStatus fromJson(String json) {
    return ensureInitialized().decodeJson<MessageStatus>(json);
  }
}

mixin MessageStatusMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MessageStatusCopyWith<MessageStatus, MessageStatus, MessageStatus>
      get copyWith;
}

abstract class MessageStatusCopyWith<$R, $In extends MessageStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MessageStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MessageStatusPendingMapper extends ClassMapperBase<MessageStatusPending> {
  MessageStatusPendingMapper._();

  static MessageStatusPendingMapper? _instance;
  static MessageStatusPendingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusPendingMapper._());
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageStatusPending';

  @override
  final MappableFields<MessageStatusPending> fields = const {};

  static MessageStatusPending _instantiate(DecodingData data) {
    return MessageStatusPending();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageStatusPending fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageStatusPending>(map);
  }

  static MessageStatusPending fromJson(String json) {
    return ensureInitialized().decodeJson<MessageStatusPending>(json);
  }
}

mixin MessageStatusPendingMappable {
  String toJson() {
    return MessageStatusPendingMapper.ensureInitialized()
        .encodeJson<MessageStatusPending>(this as MessageStatusPending);
  }

  Map<String, dynamic> toMap() {
    return MessageStatusPendingMapper.ensureInitialized()
        .encodeMap<MessageStatusPending>(this as MessageStatusPending);
  }

  MessageStatusPendingCopyWith<MessageStatusPending, MessageStatusPending,
      MessageStatusPending> get copyWith => _MessageStatusPendingCopyWithImpl<
          MessageStatusPending, MessageStatusPending>(
      this as MessageStatusPending, $identity, $identity);
  @override
  String toString() {
    return MessageStatusPendingMapper.ensureInitialized()
        .stringifyValue(this as MessageStatusPending);
  }

  @override
  bool operator ==(Object other) {
    return MessageStatusPendingMapper.ensureInitialized()
        .equalsValue(this as MessageStatusPending, other);
  }

  @override
  int get hashCode {
    return MessageStatusPendingMapper.ensureInitialized()
        .hashValue(this as MessageStatusPending);
  }
}

extension MessageStatusPendingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageStatusPending, $Out> {
  MessageStatusPendingCopyWith<$R, MessageStatusPending, $Out>
      get $asMessageStatusPending => $base.as(
          (v, t, t2) => _MessageStatusPendingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageStatusPendingCopyWith<
    $R,
    $In extends MessageStatusPending,
    $Out> implements MessageStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageStatusPendingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MessageStatusPendingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageStatusPending, $Out>
    implements MessageStatusPendingCopyWith<$R, MessageStatusPending, $Out> {
  _MessageStatusPendingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageStatusPending> $mapper =
      MessageStatusPendingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageStatusPending $make(CopyWithData data) => MessageStatusPending();

  @override
  MessageStatusPendingCopyWith<$R2, MessageStatusPending, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MessageStatusPendingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageStatusSentMapper extends ClassMapperBase<MessageStatusSent> {
  MessageStatusSentMapper._();

  static MessageStatusSentMapper? _instance;
  static MessageStatusSentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusSentMapper._());
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageStatusSent';

  @override
  final MappableFields<MessageStatusSent> fields = const {};

  static MessageStatusSent _instantiate(DecodingData data) {
    return MessageStatusSent();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageStatusSent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageStatusSent>(map);
  }

  static MessageStatusSent fromJson(String json) {
    return ensureInitialized().decodeJson<MessageStatusSent>(json);
  }
}

mixin MessageStatusSentMappable {
  String toJson() {
    return MessageStatusSentMapper.ensureInitialized()
        .encodeJson<MessageStatusSent>(this as MessageStatusSent);
  }

  Map<String, dynamic> toMap() {
    return MessageStatusSentMapper.ensureInitialized()
        .encodeMap<MessageStatusSent>(this as MessageStatusSent);
  }

  MessageStatusSentCopyWith<MessageStatusSent, MessageStatusSent,
          MessageStatusSent>
      get copyWith =>
          _MessageStatusSentCopyWithImpl<MessageStatusSent, MessageStatusSent>(
              this as MessageStatusSent, $identity, $identity);
  @override
  String toString() {
    return MessageStatusSentMapper.ensureInitialized()
        .stringifyValue(this as MessageStatusSent);
  }

  @override
  bool operator ==(Object other) {
    return MessageStatusSentMapper.ensureInitialized()
        .equalsValue(this as MessageStatusSent, other);
  }

  @override
  int get hashCode {
    return MessageStatusSentMapper.ensureInitialized()
        .hashValue(this as MessageStatusSent);
  }
}

extension MessageStatusSentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageStatusSent, $Out> {
  MessageStatusSentCopyWith<$R, MessageStatusSent, $Out>
      get $asMessageStatusSent => $base
          .as((v, t, t2) => _MessageStatusSentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageStatusSentCopyWith<$R, $In extends MessageStatusSent,
    $Out> implements MessageStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageStatusSentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MessageStatusSentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageStatusSent, $Out>
    implements MessageStatusSentCopyWith<$R, MessageStatusSent, $Out> {
  _MessageStatusSentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageStatusSent> $mapper =
      MessageStatusSentMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageStatusSent $make(CopyWithData data) => MessageStatusSent();

  @override
  MessageStatusSentCopyWith<$R2, MessageStatusSent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MessageStatusSentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageStatusDeliveredMapper
    extends ClassMapperBase<MessageStatusDelivered> {
  MessageStatusDeliveredMapper._();

  static MessageStatusDeliveredMapper? _instance;
  static MessageStatusDeliveredMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusDeliveredMapper._());
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageStatusDelivered';

  @override
  final MappableFields<MessageStatusDelivered> fields = const {};

  static MessageStatusDelivered _instantiate(DecodingData data) {
    return MessageStatusDelivered();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageStatusDelivered fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageStatusDelivered>(map);
  }

  static MessageStatusDelivered fromJson(String json) {
    return ensureInitialized().decodeJson<MessageStatusDelivered>(json);
  }
}

mixin MessageStatusDeliveredMappable {
  String toJson() {
    return MessageStatusDeliveredMapper.ensureInitialized()
        .encodeJson<MessageStatusDelivered>(this as MessageStatusDelivered);
  }

  Map<String, dynamic> toMap() {
    return MessageStatusDeliveredMapper.ensureInitialized()
        .encodeMap<MessageStatusDelivered>(this as MessageStatusDelivered);
  }

  MessageStatusDeliveredCopyWith<MessageStatusDelivered, MessageStatusDelivered,
          MessageStatusDelivered>
      get copyWith => _MessageStatusDeliveredCopyWithImpl<
              MessageStatusDelivered, MessageStatusDelivered>(
          this as MessageStatusDelivered, $identity, $identity);
  @override
  String toString() {
    return MessageStatusDeliveredMapper.ensureInitialized()
        .stringifyValue(this as MessageStatusDelivered);
  }

  @override
  bool operator ==(Object other) {
    return MessageStatusDeliveredMapper.ensureInitialized()
        .equalsValue(this as MessageStatusDelivered, other);
  }

  @override
  int get hashCode {
    return MessageStatusDeliveredMapper.ensureInitialized()
        .hashValue(this as MessageStatusDelivered);
  }
}

extension MessageStatusDeliveredValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageStatusDelivered, $Out> {
  MessageStatusDeliveredCopyWith<$R, MessageStatusDelivered, $Out>
      get $asMessageStatusDelivered => $base.as((v, t, t2) =>
          _MessageStatusDeliveredCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageStatusDeliveredCopyWith<
    $R,
    $In extends MessageStatusDelivered,
    $Out> implements MessageStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageStatusDeliveredCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MessageStatusDeliveredCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageStatusDelivered, $Out>
    implements
        MessageStatusDeliveredCopyWith<$R, MessageStatusDelivered, $Out> {
  _MessageStatusDeliveredCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageStatusDelivered> $mapper =
      MessageStatusDeliveredMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageStatusDelivered $make(CopyWithData data) => MessageStatusDelivered();

  @override
  MessageStatusDeliveredCopyWith<$R2, MessageStatusDelivered, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MessageStatusDeliveredCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageStatusErrorMapper extends ClassMapperBase<MessageStatusError> {
  MessageStatusErrorMapper._();

  static MessageStatusErrorMapper? _instance;
  static MessageStatusErrorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusErrorMapper._());
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageStatusError';

  static String _$message(MessageStatusError v) => v.message;
  static const Field<MessageStatusError, String> _f$message =
      Field('message', _$message);
  static Exception _$exception(MessageStatusError v) => v.exception;
  static const Field<MessageStatusError, Exception> _f$exception =
      Field('exception', _$exception);

  @override
  final MappableFields<MessageStatusError> fields = const {
    #message: _f$message,
    #exception: _f$exception,
  };

  static MessageStatusError _instantiate(DecodingData data) {
    return MessageStatusError(data.dec(_f$message), data.dec(_f$exception));
  }

  @override
  final Function instantiate = _instantiate;

  static MessageStatusError fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageStatusError>(map);
  }

  static MessageStatusError fromJson(String json) {
    return ensureInitialized().decodeJson<MessageStatusError>(json);
  }
}

mixin MessageStatusErrorMappable {
  String toJson() {
    return MessageStatusErrorMapper.ensureInitialized()
        .encodeJson<MessageStatusError>(this as MessageStatusError);
  }

  Map<String, dynamic> toMap() {
    return MessageStatusErrorMapper.ensureInitialized()
        .encodeMap<MessageStatusError>(this as MessageStatusError);
  }

  MessageStatusErrorCopyWith<MessageStatusError, MessageStatusError,
          MessageStatusError>
      get copyWith => _MessageStatusErrorCopyWithImpl<MessageStatusError,
          MessageStatusError>(this as MessageStatusError, $identity, $identity);
  @override
  String toString() {
    return MessageStatusErrorMapper.ensureInitialized()
        .stringifyValue(this as MessageStatusError);
  }

  @override
  bool operator ==(Object other) {
    return MessageStatusErrorMapper.ensureInitialized()
        .equalsValue(this as MessageStatusError, other);
  }

  @override
  int get hashCode {
    return MessageStatusErrorMapper.ensureInitialized()
        .hashValue(this as MessageStatusError);
  }
}

extension MessageStatusErrorValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageStatusError, $Out> {
  MessageStatusErrorCopyWith<$R, MessageStatusError, $Out>
      get $asMessageStatusError => $base.as(
          (v, t, t2) => _MessageStatusErrorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageStatusErrorCopyWith<$R, $In extends MessageStatusError,
    $Out> implements MessageStatusCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message, Exception? exception});
  MessageStatusErrorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MessageStatusErrorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageStatusError, $Out>
    implements MessageStatusErrorCopyWith<$R, MessageStatusError, $Out> {
  _MessageStatusErrorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageStatusError> $mapper =
      MessageStatusErrorMapper.ensureInitialized();
  @override
  $R call({String? message, Exception? exception}) => $apply(FieldCopyWithData({
        if (message != null) #message: message,
        if (exception != null) #exception: exception
      }));
  @override
  MessageStatusError $make(CopyWithData data) => MessageStatusError(
      data.get(#message, or: $value.message),
      data.get(#exception, or: $value.exception));

  @override
  MessageStatusErrorCopyWith<$R2, MessageStatusError, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MessageStatusErrorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AppMessageMapper extends ClassMapperBase<AppMessage> {
  AppMessageMapper._();

  static AppMessageMapper? _instance;
  static AppMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppMessageMapper._());
      MessageTypeMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppMessage';

  static DateTime _$timestamp(AppMessage v) => v.timestamp;
  static const Field<AppMessage, DateTime> _f$timestamp =
      Field('timestamp', _$timestamp);
  static String _$text(AppMessage v) => v.text;
  static const Field<AppMessage, String> _f$text = Field('text', _$text);
  static MessageType _$type(AppMessage v) => v.type;
  static const Field<AppMessage, MessageType> _f$type = Field('type', _$type);
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
    #text: _f$text,
    #type: _f$type,
    #status: _f$status,
    #sender: _f$sender,
    #metadata: _f$metadata,
  };

  static AppMessage _instantiate(DecodingData data) {
    return AppMessage(
        timestamp: data.dec(_f$timestamp),
        text: data.dec(_f$text),
        type: data.dec(_f$type),
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
  MessageStatusCopyWith<$R, MessageStatus, MessageStatus> get status;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata;
  $R call(
      {DateTime? timestamp,
      String? text,
      MessageType? type,
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
  MessageStatusCopyWith<$R, MessageStatus, MessageStatus> get status =>
      $value.status.copyWith.$chain((v) => call(status: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get metadata => MapCopyWith($value.metadata,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(metadata: v));
  @override
  $R call(
          {DateTime? timestamp,
          String? text,
          MessageType? type,
          MessageStatus? status,
          String? sender,
          Map<String, dynamic>? metadata}) =>
      $apply(FieldCopyWithData({
        if (timestamp != null) #timestamp: timestamp,
        if (text != null) #text: text,
        if (type != null) #type: type,
        if (status != null) #status: status,
        if (sender != null) #sender: sender,
        if (metadata != null) #metadata: metadata
      }));
  @override
  AppMessage $make(CopyWithData data) => AppMessage(
      timestamp: data.get(#timestamp, or: $value.timestamp),
      text: data.get(#text, or: $value.text),
      type: data.get(#type, or: $value.type),
      status: data.get(#status, or: $value.status),
      sender: data.get(#sender, or: $value.sender),
      metadata: data.get(#metadata, or: $value.metadata));

  @override
  AppMessageCopyWith<$R2, AppMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AppMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
