/// Annotation for generator
class GenerateCopier {
  final String defaultObjectCode;

  const GenerateCopier({this.defaultObjectCode});
}

enum CopyType { copier, copyable }

class _CopyMeta {
  final CopyType copyType;
  final String import;
  final String baseClassName;
  final String newClassName;
  final Map<String, String> fields;

  const _CopyMeta({this.copyType, this.import, this.baseClassName, this
      .newClassName,
    this
      .fields});
}

class CopyableMeta extends _CopyMeta {
  const CopyableMeta({
    String import,
    String baseClassName,
    String newClassName,
    Map<String, String> fields
  }) : super(
      copyType: CopyType.copyable,
      import: import,
      baseClassName: baseClassName,
      newClassName: newClassName ?? 'Copyable' + baseClassName,
      fields: fields
  );
}

class CopierMeta extends _CopyMeta {
  final String defaultObjectCode;

  const CopierMeta({
    String import,
    String baseClassName,
    String newClassName,
    Map<String, String> fields,
    this.defaultObjectCode,
  }) : super(
      copyType: CopyType.copier,
      import: import,
      baseClassName: baseClassName,
      newClassName: newClassName ?? baseClassName + 'Copier',
      fields: fields,
  );
}

class GenerateCopyable {
  const GenerateCopyable();
}

const generate_copyable = GenerateCopyable();

