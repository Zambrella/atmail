// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_bloc.dart';

class ConversationStatusMapper extends EnumMapper<ConversationStatus> {
  ConversationStatusMapper._();

  static ConversationStatusMapper? _instance;
  static ConversationStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationStatusMapper._());
    }
    return _instance!;
  }

  static ConversationStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ConversationStatus decode(dynamic value) {
    switch (value) {
      case r'loading':
        return ConversationStatus.loading;
      case r'success':
        return ConversationStatus.success;
      case r'failure':
        return ConversationStatus.failure;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ConversationStatus self) {
    switch (self) {
      case ConversationStatus.loading:
        return r'loading';
      case ConversationStatus.success:
        return r'success';
      case ConversationStatus.failure:
        return r'failure';
    }
  }
}

extension ConversationStatusMapperExtension on ConversationStatus {
  String toValue() {
    ConversationStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ConversationStatus>(this) as String;
  }
}

class ConversationStateMapper extends ClassMapperBase<ConversationState> {
  ConversationStateMapper._();

  static ConversationStateMapper? _instance;
  static ConversationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationStateMapper._());
      ConversationStatusMapper.ensureInitialized();
      AppConversationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationState';

  static ConversationStatus _$status(ConversationState v) => v.status;
  static const Field<ConversationState, ConversationStatus> _f$status = Field(
    'status',
    _$status,
  );
  static List<AppConversation> _$conversations(ConversationState v) =>
      v.conversations;
  static const Field<ConversationState, List<AppConversation>>
  _f$conversations = Field('conversations', _$conversations);
  static Exception? _$exception(ConversationState v) => v.exception;
  static const Field<ConversationState, Exception> _f$exception = Field(
    'exception',
    _$exception,
    opt: true,
  );

  @override
  final MappableFields<ConversationState> fields = const {
    #status: _f$status,
    #conversations: _f$conversations,
    #exception: _f$exception,
  };

  static ConversationState _instantiate(DecodingData data) {
    return ConversationState(
      status: data.dec(_f$status),
      conversations: data.dec(_f$conversations),
      exception: data.dec(_f$exception),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationState>(map);
  }

  static ConversationState fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationState>(json);
  }
}

mixin ConversationStateMappable {
  String toJson() {
    return ConversationStateMapper.ensureInitialized()
        .encodeJson<ConversationState>(this as ConversationState);
  }

  Map<String, dynamic> toMap() {
    return ConversationStateMapper.ensureInitialized()
        .encodeMap<ConversationState>(this as ConversationState);
  }

  ConversationStateCopyWith<
    ConversationState,
    ConversationState,
    ConversationState
  >
  get copyWith =>
      _ConversationStateCopyWithImpl<ConversationState, ConversationState>(
        this as ConversationState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConversationStateMapper.ensureInitialized().stringifyValue(
      this as ConversationState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConversationStateMapper.ensureInitialized().equalsValue(
      this as ConversationState,
      other,
    );
  }

  @override
  int get hashCode {
    return ConversationStateMapper.ensureInitialized().hashValue(
      this as ConversationState,
    );
  }
}

extension ConversationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConversationState, $Out> {
  ConversationStateCopyWith<$R, ConversationState, $Out>
  get $asConversationState => $base.as(
    (v, t, t2) => _ConversationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConversationStateCopyWith<
  $R,
  $In extends ConversationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    AppConversation,
    AppConversationCopyWith<$R, AppConversation, AppConversation>
  >
  get conversations;
  $R call({
    ConversationStatus? status,
    List<AppConversation>? conversations,
    Exception? exception,
  });
  ConversationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConversationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConversationState, $Out>
    implements ConversationStateCopyWith<$R, ConversationState, $Out> {
  _ConversationStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConversationState> $mapper =
      ConversationStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    AppConversation,
    AppConversationCopyWith<$R, AppConversation, AppConversation>
  >
  get conversations => ListCopyWith(
    $value.conversations,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(conversations: v),
  );
  @override
  $R call({
    ConversationStatus? status,
    List<AppConversation>? conversations,
    Object? exception = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (conversations != null) #conversations: conversations,
      if (exception != $none) #exception: exception,
    }),
  );
  @override
  ConversationState $make(CopyWithData data) => ConversationState(
    status: data.get(#status, or: $value.status),
    conversations: data.get(#conversations, or: $value.conversations),
    exception: data.get(#exception, or: $value.exception),
  );

  @override
  ConversationStateCopyWith<$R2, ConversationState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConversationStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

