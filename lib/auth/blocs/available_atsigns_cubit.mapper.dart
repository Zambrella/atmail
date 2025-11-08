// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'available_atsigns_cubit.dart';

class AvailableAtsignsStateMapper
    extends ClassMapperBase<AvailableAtsignsState> {
  AvailableAtsignsStateMapper._();

  static AvailableAtsignsStateMapper? _instance;
  static AvailableAtsignsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AvailableAtsignsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AvailableAtsignsState';

  static List<String> _$atsigns(AvailableAtsignsState v) => v.atsigns;
  static const Field<AvailableAtsignsState, List<String>> _f$atsigns = Field(
    'atsigns',
    _$atsigns,
    opt: true,
    def: const [],
  );
  static bool _$isLoading(AvailableAtsignsState v) => v.isLoading;
  static const Field<AvailableAtsignsState, bool> _f$isLoading = Field(
    'isLoading',
    _$isLoading,
    opt: true,
    def: false,
  );
  static String? _$error(AvailableAtsignsState v) => v.error;
  static const Field<AvailableAtsignsState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
  );

  @override
  final MappableFields<AvailableAtsignsState> fields = const {
    #atsigns: _f$atsigns,
    #isLoading: _f$isLoading,
    #error: _f$error,
  };

  static AvailableAtsignsState _instantiate(DecodingData data) {
    return AvailableAtsignsState(
      atsigns: data.dec(_f$atsigns),
      isLoading: data.dec(_f$isLoading),
      error: data.dec(_f$error),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AvailableAtsignsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AvailableAtsignsState>(map);
  }

  static AvailableAtsignsState fromJson(String json) {
    return ensureInitialized().decodeJson<AvailableAtsignsState>(json);
  }
}

mixin AvailableAtsignsStateMappable {
  String toJson() {
    return AvailableAtsignsStateMapper.ensureInitialized()
        .encodeJson<AvailableAtsignsState>(this as AvailableAtsignsState);
  }

  Map<String, dynamic> toMap() {
    return AvailableAtsignsStateMapper.ensureInitialized()
        .encodeMap<AvailableAtsignsState>(this as AvailableAtsignsState);
  }

  AvailableAtsignsStateCopyWith<
    AvailableAtsignsState,
    AvailableAtsignsState,
    AvailableAtsignsState
  >
  get copyWith =>
      _AvailableAtsignsStateCopyWithImpl<
        AvailableAtsignsState,
        AvailableAtsignsState
      >(this as AvailableAtsignsState, $identity, $identity);
  @override
  String toString() {
    return AvailableAtsignsStateMapper.ensureInitialized().stringifyValue(
      this as AvailableAtsignsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AvailableAtsignsStateMapper.ensureInitialized().equalsValue(
      this as AvailableAtsignsState,
      other,
    );
  }

  @override
  int get hashCode {
    return AvailableAtsignsStateMapper.ensureInitialized().hashValue(
      this as AvailableAtsignsState,
    );
  }
}

extension AvailableAtsignsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AvailableAtsignsState, $Out> {
  AvailableAtsignsStateCopyWith<$R, AvailableAtsignsState, $Out>
  get $asAvailableAtsignsState => $base.as(
    (v, t, t2) => _AvailableAtsignsStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AvailableAtsignsStateCopyWith<
  $R,
  $In extends AvailableAtsignsState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get atsigns;
  $R call({List<String>? atsigns, bool? isLoading, String? error});
  AvailableAtsignsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AvailableAtsignsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AvailableAtsignsState, $Out>
    implements AvailableAtsignsStateCopyWith<$R, AvailableAtsignsState, $Out> {
  _AvailableAtsignsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AvailableAtsignsState> $mapper =
      AvailableAtsignsStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get atsigns =>
      ListCopyWith(
        $value.atsigns,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(atsigns: v),
      );
  @override
  $R call({List<String>? atsigns, bool? isLoading, Object? error = $none}) =>
      $apply(
        FieldCopyWithData({
          if (atsigns != null) #atsigns: atsigns,
          if (isLoading != null) #isLoading: isLoading,
          if (error != $none) #error: error,
        }),
      );
  @override
  AvailableAtsignsState $make(CopyWithData data) => AvailableAtsignsState(
    atsigns: data.get(#atsigns, or: $value.atsigns),
    isLoading: data.get(#isLoading, or: $value.isLoading),
    error: data.get(#error, or: $value.error),
  );

  @override
  AvailableAtsignsStateCopyWith<$R2, AvailableAtsignsState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AvailableAtsignsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

