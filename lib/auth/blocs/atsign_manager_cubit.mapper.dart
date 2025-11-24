// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'atsign_manager_cubit.dart';

class AtSignManagerStateMapper extends ClassMapperBase<AtSignManagerState> {
  AtSignManagerStateMapper._();

  static AtSignManagerStateMapper? _instance;
  static AtSignManagerStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AtSignManagerStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AtSignManagerState';

  static String _$currentAtsign(AtSignManagerState v) => v.currentAtsign;
  static const Field<AtSignManagerState, String> _f$currentAtsign = Field(
    'currentAtsign',
    _$currentAtsign,
  );
  static bool _$isLoading(AtSignManagerState v) => v.isLoading;
  static const Field<AtSignManagerState, bool> _f$isLoading = Field(
    'isLoading',
    _$isLoading,
    opt: true,
    def: false,
  );
  static String? _$error(AtSignManagerState v) => v.error;
  static const Field<AtSignManagerState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
  );

  @override
  final MappableFields<AtSignManagerState> fields = const {
    #currentAtsign: _f$currentAtsign,
    #isLoading: _f$isLoading,
    #error: _f$error,
  };

  static AtSignManagerState _instantiate(DecodingData data) {
    return AtSignManagerState(
      currentAtsign: data.dec(_f$currentAtsign),
      isLoading: data.dec(_f$isLoading),
      error: data.dec(_f$error),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AtSignManagerState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AtSignManagerState>(map);
  }

  static AtSignManagerState fromJson(String json) {
    return ensureInitialized().decodeJson<AtSignManagerState>(json);
  }
}

mixin AtSignManagerStateMappable {
  String toJson() {
    return AtSignManagerStateMapper.ensureInitialized()
        .encodeJson<AtSignManagerState>(this as AtSignManagerState);
  }

  Map<String, dynamic> toMap() {
    return AtSignManagerStateMapper.ensureInitialized()
        .encodeMap<AtSignManagerState>(this as AtSignManagerState);
  }

  AtSignManagerStateCopyWith<
    AtSignManagerState,
    AtSignManagerState,
    AtSignManagerState
  >
  get copyWith =>
      _AtSignManagerStateCopyWithImpl<AtSignManagerState, AtSignManagerState>(
        this as AtSignManagerState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AtSignManagerStateMapper.ensureInitialized().stringifyValue(
      this as AtSignManagerState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AtSignManagerStateMapper.ensureInitialized().equalsValue(
      this as AtSignManagerState,
      other,
    );
  }

  @override
  int get hashCode {
    return AtSignManagerStateMapper.ensureInitialized().hashValue(
      this as AtSignManagerState,
    );
  }
}

extension AtSignManagerStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AtSignManagerState, $Out> {
  AtSignManagerStateCopyWith<$R, AtSignManagerState, $Out>
  get $asAtSignManagerState => $base.as(
    (v, t, t2) => _AtSignManagerStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AtSignManagerStateCopyWith<
  $R,
  $In extends AtSignManagerState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? currentAtsign, bool? isLoading, String? error});
  AtSignManagerStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AtSignManagerStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AtSignManagerState, $Out>
    implements AtSignManagerStateCopyWith<$R, AtSignManagerState, $Out> {
  _AtSignManagerStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AtSignManagerState> $mapper =
      AtSignManagerStateMapper.ensureInitialized();
  @override
  $R call({String? currentAtsign, bool? isLoading, Object? error = $none}) =>
      $apply(
        FieldCopyWithData({
          if (currentAtsign != null) #currentAtsign: currentAtsign,
          if (isLoading != null) #isLoading: isLoading,
          if (error != $none) #error: error,
        }),
      );
  @override
  AtSignManagerState $make(CopyWithData data) => AtSignManagerState(
    currentAtsign: data.get(#currentAtsign, or: $value.currentAtsign),
    isLoading: data.get(#isLoading, or: $value.isLoading),
    error: data.get(#error, or: $value.error),
  );

  @override
  AtSignManagerStateCopyWith<$R2, AtSignManagerState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AtSignManagerStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

