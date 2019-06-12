/// Annotation for generator
class GenerateCopier {
  const GenerateCopier();
}

const generate_copier = GenerateCopier();

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
  const CopierMeta({
    String import,
    String baseClassName,
    String newClassName,
    Map<String, String> fields
  }) : super(
      copyType: CopyType.copier,
      import: import,
      baseClassName: baseClassName,
      newClassName: newClassName ?? baseClassName + 'Copier',
      fields: fields
  );
}

class GenerateCopyable {
  const GenerateCopyable();
}

const generate_copyable = GenerateCopyable();

