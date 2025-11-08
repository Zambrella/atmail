// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_details_cubit.dart';

class ConversationDetailsStatusMapper
    extends EnumMapper<ConversationDetailsStatus> {
  ConversationDetailsStatusMapper._();

  static ConversationDetailsStatusMapper? _instance;
  static ConversationDetailsStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConversationDetailsStatusMapper._(),
      );
    }
    return _instance!;
  }

  static ConversationDetailsStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ConversationDetailsStatus decode(dynamic value) {
    switch (value) {
      case r'loading':
        return ConversationDetailsStatus.loading;
      case r'success':
        return ConversationDetailsStatus.success;
      case r'failure':
        return ConversationDetailsStatus.failure;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ConversationDetailsStatus self) {
    switch (self) {
      case ConversationDetailsStatus.loading:
        return r'loading';
      case ConversationDetailsStatus.success:
        return r'success';
      case ConversationDetailsStatus.failure:
        return r'failure';
    }
  }
}

extension ConversationDetailsStatusMapperExtension
    on ConversationDetailsStatus {
  String toValue() {
    ConversationDetailsStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ConversationDetailsStatus>(this)
        as String;
  }
}

class ConversationDetailsStateMapper
    extends ClassMapperBase<ConversationDetailsState> {
  ConversationDetailsStateMapper._();

  static ConversationDetailsStateMapper? _instance;
  static ConversationDetailsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConversationDetailsStateMapper._(),
      );
      ConversationDetailsStatusMapper.ensureInitialized();
      AppConversationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationDetailsState';

  static ConversationDetailsStatus _$status(ConversationDetailsState v) =>
      v.status;
  static const Field<ConversationDetailsState, ConversationDetailsStatus>
  _f$status = Field('status', _$status);
  static AppConversation? _$conversation(ConversationDetailsState v) =>
      v.conversation;
  static const Field<ConversationDetailsState, AppConversation>
  _f$conversation = Field('conversation', _$conversation, opt: true);
  static Exception? _$exception(ConversationDetailsState v) => v.exception;
  static const Field<ConversationDetailsState, Exception> _f$exception = Field(
    'exception',
    _$exception,
    opt: true,
  );

  @override
  final MappableFields<ConversationDetailsState> fields = const {
    #status: _f$status,
    #conversation: _f$conversation,
    #exception: _f$exception,
  };

  static ConversationDetailsState _instantiate(DecodingData data) {
    return ConversationDetailsState(
      status: data.dec(_f$status),
      conversation: data.dec(_f$conversation),
      exception: data.dec(_f$exception),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationDetailsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationDetailsState>(map);
  }

  static ConversationDetailsState fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationDetailsState>(json);
  }
}

mixin ConversationDetailsStateMappable {
  String toJson() {
    return ConversationDetailsStateMapper.ensureInitialized()
        .encodeJson<ConversationDetailsState>(this as ConversationDetailsState);
  }

  Map<String, dynamic> toMap() {
    return ConversationDetailsStateMapper.ensureInitialized()
        .encodeMap<ConversationDetailsState>(this as ConversationDetailsState);
  }

  ConversationDetailsStateCopyWith<
    ConversationDetailsState,
    ConversationDetailsState,
    ConversationDetailsState
  >
  get copyWith =>
      _ConversationDetailsStateCopyWithImpl<
        ConversationDetailsState,
        ConversationDetailsState
      >(this as ConversationDetailsState, $identity, $identity);
  @override
  String toString() {
    return ConversationDetailsStateMapper.ensureInitialized().stringifyValue(
      this as ConversationDetailsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConversationDetailsStateMapper.ensureInitialized().equalsValue(
      this as ConversationDetailsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ConversationDetailsStateMapper.ensureInitialized().hashValue(
      this as ConversationDetailsState,
    );
  }
}

extension ConversationDetailsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConversationDetailsState, $Out> {
  ConversationDetailsStateCopyWith<$R, ConversationDetailsState, $Out>
  get $asConversationDetailsState => $base.as(
    (v, t, t2) => _ConversationDetailsStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConversationDetailsStateCopyWith<
  $R,
  $In extends ConversationDetailsState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  AppConversationCopyWith<$R, AppConversation, AppConversation>?
  get conversation;
  $R call({
    ConversationDetailsStatus? status,
    AppConversation? conversation,
    Exception? exception,
  });
  ConversationDetailsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConversationDetailsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConversationDetailsState, $Out>
    implements
        ConversationDetailsStateCopyWith<$R, ConversationDetailsState, $Out> {
  _ConversationDetailsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConversationDetailsState> $mapper =
      ConversationDetailsStateMapper.ensureInitialized();
  @override
  AppConversationCopyWith<$R, AppConversation, AppConversation>?
  get conversation =>
      $value.conversation?.copyWith.$chain((v) => call(conversation: v));
  @override
  $R call({
    ConversationDetailsStatus? status,
    Object? conversation = $none,
    Object? exception = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (conversation != $none) #conversation: conversation,
      if (exception != $none) #exception: exception,
    }),
  );
  @override
  ConversationDetailsState $make(CopyWithData data) => ConversationDetailsState(
    status: data.get(#status, or: $value.status),
    conversation: data.get(#conversation, or: $value.conversation),
    exception: data.get(#exception, or: $value.exception),
  );

  @override
  ConversationDetailsStateCopyWith<$R2, ConversationDetailsState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ConversationDetailsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

