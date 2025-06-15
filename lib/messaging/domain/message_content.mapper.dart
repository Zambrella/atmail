// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_content.dart';

class MessageContentMapper extends ClassMapperBase<MessageContent> {
  MessageContentMapper._();

  static MessageContentMapper? _instance;
  static MessageContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageContentMapper._());
      TextContentMapper.ensureInitialized();
      MarkdownContentMapper.ensureInitialized();
      BinaryContentMapper.ensureInitialized();
      DeletedContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageContent';

  @override
  final MappableFields<MessageContent> fields = const {};

  static MessageContent _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('MessageContent');
  }

  @override
  final Function instantiate = _instantiate;

  static MessageContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageContent>(map);
  }

  static MessageContent fromJson(String json) {
    return ensureInitialized().decodeJson<MessageContent>(json);
  }
}

mixin MessageContentMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MessageContentCopyWith<MessageContent, MessageContent, MessageContent>
      get copyWith;
}

abstract class MessageContentCopyWith<$R, $In extends MessageContent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MessageContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class TextContentMapper extends ClassMapperBase<TextContent> {
  TextContentMapper._();

  static TextContentMapper? _instance;
  static TextContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TextContentMapper._());
      MessageContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TextContent';

  static String _$text(TextContent v) => v.text;
  static const Field<TextContent, String> _f$text = Field('text', _$text);

  @override
  final MappableFields<TextContent> fields = const {
    #text: _f$text,
  };

  static TextContent _instantiate(DecodingData data) {
    return TextContent(data.dec(_f$text));
  }

  @override
  final Function instantiate = _instantiate;

  static TextContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TextContent>(map);
  }

  static TextContent fromJson(String json) {
    return ensureInitialized().decodeJson<TextContent>(json);
  }
}

mixin TextContentMappable {
  String toJson() {
    return TextContentMapper.ensureInitialized()
        .encodeJson<TextContent>(this as TextContent);
  }

  Map<String, dynamic> toMap() {
    return TextContentMapper.ensureInitialized()
        .encodeMap<TextContent>(this as TextContent);
  }

  TextContentCopyWith<TextContent, TextContent, TextContent> get copyWith =>
      _TextContentCopyWithImpl<TextContent, TextContent>(
          this as TextContent, $identity, $identity);
  @override
  String toString() {
    return TextContentMapper.ensureInitialized()
        .stringifyValue(this as TextContent);
  }

  @override
  bool operator ==(Object other) {
    return TextContentMapper.ensureInitialized()
        .equalsValue(this as TextContent, other);
  }

  @override
  int get hashCode {
    return TextContentMapper.ensureInitialized().hashValue(this as TextContent);
  }
}

extension TextContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TextContent, $Out> {
  TextContentCopyWith<$R, TextContent, $Out> get $asTextContent =>
      $base.as((v, t, t2) => _TextContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TextContentCopyWith<$R, $In extends TextContent, $Out>
    implements MessageContentCopyWith<$R, $In, $Out> {
  @override
  $R call({String? text});
  TextContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TextContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TextContent, $Out>
    implements TextContentCopyWith<$R, TextContent, $Out> {
  _TextContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TextContent> $mapper =
      TextContentMapper.ensureInitialized();
  @override
  $R call({String? text}) =>
      $apply(FieldCopyWithData({if (text != null) #text: text}));
  @override
  TextContent $make(CopyWithData data) =>
      TextContent(data.get(#text, or: $value.text));

  @override
  TextContentCopyWith<$R2, TextContent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TextContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MarkdownContentMapper extends ClassMapperBase<MarkdownContent> {
  MarkdownContentMapper._();

  static MarkdownContentMapper? _instance;
  static MarkdownContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MarkdownContentMapper._());
      MessageContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MarkdownContent';

  static String _$text(MarkdownContent v) => v.text;
  static const Field<MarkdownContent, String> _f$text = Field('text', _$text);

  @override
  final MappableFields<MarkdownContent> fields = const {
    #text: _f$text,
  };

  static MarkdownContent _instantiate(DecodingData data) {
    return MarkdownContent(data.dec(_f$text));
  }

  @override
  final Function instantiate = _instantiate;

  static MarkdownContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MarkdownContent>(map);
  }

  static MarkdownContent fromJson(String json) {
    return ensureInitialized().decodeJson<MarkdownContent>(json);
  }
}

mixin MarkdownContentMappable {
  String toJson() {
    return MarkdownContentMapper.ensureInitialized()
        .encodeJson<MarkdownContent>(this as MarkdownContent);
  }

  Map<String, dynamic> toMap() {
    return MarkdownContentMapper.ensureInitialized()
        .encodeMap<MarkdownContent>(this as MarkdownContent);
  }

  MarkdownContentCopyWith<MarkdownContent, MarkdownContent, MarkdownContent>
      get copyWith =>
          _MarkdownContentCopyWithImpl<MarkdownContent, MarkdownContent>(
              this as MarkdownContent, $identity, $identity);
  @override
  String toString() {
    return MarkdownContentMapper.ensureInitialized()
        .stringifyValue(this as MarkdownContent);
  }

  @override
  bool operator ==(Object other) {
    return MarkdownContentMapper.ensureInitialized()
        .equalsValue(this as MarkdownContent, other);
  }

  @override
  int get hashCode {
    return MarkdownContentMapper.ensureInitialized()
        .hashValue(this as MarkdownContent);
  }
}

extension MarkdownContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MarkdownContent, $Out> {
  MarkdownContentCopyWith<$R, MarkdownContent, $Out> get $asMarkdownContent =>
      $base.as((v, t, t2) => _MarkdownContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MarkdownContentCopyWith<$R, $In extends MarkdownContent, $Out>
    implements MessageContentCopyWith<$R, $In, $Out> {
  @override
  $R call({String? text});
  MarkdownContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MarkdownContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MarkdownContent, $Out>
    implements MarkdownContentCopyWith<$R, MarkdownContent, $Out> {
  _MarkdownContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MarkdownContent> $mapper =
      MarkdownContentMapper.ensureInitialized();
  @override
  $R call({String? text}) =>
      $apply(FieldCopyWithData({if (text != null) #text: text}));
  @override
  MarkdownContent $make(CopyWithData data) =>
      MarkdownContent(data.get(#text, or: $value.text));

  @override
  MarkdownContentCopyWith<$R2, MarkdownContent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MarkdownContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BinaryContentMapper extends ClassMapperBase<BinaryContent> {
  BinaryContentMapper._();

  static BinaryContentMapper? _instance;
  static BinaryContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BinaryContentMapper._());
      MessageContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BinaryContent';

  static Uint8List _$data(BinaryContent v) => v.data;
  static const Field<BinaryContent, Uint8List> _f$data = Field('data', _$data);

  @override
  final MappableFields<BinaryContent> fields = const {
    #data: _f$data,
  };

  static BinaryContent _instantiate(DecodingData data) {
    return BinaryContent(data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static BinaryContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BinaryContent>(map);
  }

  static BinaryContent fromJson(String json) {
    return ensureInitialized().decodeJson<BinaryContent>(json);
  }
}

mixin BinaryContentMappable {
  String toJson() {
    return BinaryContentMapper.ensureInitialized()
        .encodeJson<BinaryContent>(this as BinaryContent);
  }

  Map<String, dynamic> toMap() {
    return BinaryContentMapper.ensureInitialized()
        .encodeMap<BinaryContent>(this as BinaryContent);
  }

  BinaryContentCopyWith<BinaryContent, BinaryContent, BinaryContent>
      get copyWith => _BinaryContentCopyWithImpl<BinaryContent, BinaryContent>(
          this as BinaryContent, $identity, $identity);
  @override
  String toString() {
    return BinaryContentMapper.ensureInitialized()
        .stringifyValue(this as BinaryContent);
  }

  @override
  bool operator ==(Object other) {
    return BinaryContentMapper.ensureInitialized()
        .equalsValue(this as BinaryContent, other);
  }

  @override
  int get hashCode {
    return BinaryContentMapper.ensureInitialized()
        .hashValue(this as BinaryContent);
  }
}

extension BinaryContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BinaryContent, $Out> {
  BinaryContentCopyWith<$R, BinaryContent, $Out> get $asBinaryContent =>
      $base.as((v, t, t2) => _BinaryContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BinaryContentCopyWith<$R, $In extends BinaryContent, $Out>
    implements MessageContentCopyWith<$R, $In, $Out> {
  @override
  $R call({Uint8List? data});
  BinaryContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BinaryContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BinaryContent, $Out>
    implements BinaryContentCopyWith<$R, BinaryContent, $Out> {
  _BinaryContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BinaryContent> $mapper =
      BinaryContentMapper.ensureInitialized();
  @override
  $R call({Uint8List? data}) =>
      $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  BinaryContent $make(CopyWithData data) =>
      BinaryContent(data.get(#data, or: $value.data));

  @override
  BinaryContentCopyWith<$R2, BinaryContent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BinaryContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DeletedContentMapper extends ClassMapperBase<DeletedContent> {
  DeletedContentMapper._();

  static DeletedContentMapper? _instance;
  static DeletedContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeletedContentMapper._());
      MessageContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeletedContent';

  @override
  final MappableFields<DeletedContent> fields = const {};

  static DeletedContent _instantiate(DecodingData data) {
    return DeletedContent();
  }

  @override
  final Function instantiate = _instantiate;

  static DeletedContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeletedContent>(map);
  }

  static DeletedContent fromJson(String json) {
    return ensureInitialized().decodeJson<DeletedContent>(json);
  }
}

mixin DeletedContentMappable {
  String toJson() {
    return DeletedContentMapper.ensureInitialized()
        .encodeJson<DeletedContent>(this as DeletedContent);
  }

  Map<String, dynamic> toMap() {
    return DeletedContentMapper.ensureInitialized()
        .encodeMap<DeletedContent>(this as DeletedContent);
  }

  DeletedContentCopyWith<DeletedContent, DeletedContent, DeletedContent>
      get copyWith =>
          _DeletedContentCopyWithImpl<DeletedContent, DeletedContent>(
              this as DeletedContent, $identity, $identity);
  @override
  String toString() {
    return DeletedContentMapper.ensureInitialized()
        .stringifyValue(this as DeletedContent);
  }

  @override
  bool operator ==(Object other) {
    return DeletedContentMapper.ensureInitialized()
        .equalsValue(this as DeletedContent, other);
  }

  @override
  int get hashCode {
    return DeletedContentMapper.ensureInitialized()
        .hashValue(this as DeletedContent);
  }
}

extension DeletedContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeletedContent, $Out> {
  DeletedContentCopyWith<$R, DeletedContent, $Out> get $asDeletedContent =>
      $base.as((v, t, t2) => _DeletedContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeletedContentCopyWith<$R, $In extends DeletedContent, $Out>
    implements MessageContentCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DeletedContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DeletedContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeletedContent, $Out>
    implements DeletedContentCopyWith<$R, DeletedContent, $Out> {
  _DeletedContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeletedContent> $mapper =
      DeletedContentMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DeletedContent $make(CopyWithData data) => DeletedContent();

  @override
  DeletedContentCopyWith<$R2, DeletedContent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeletedContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
