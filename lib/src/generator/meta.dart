enum CopyType { copier, copyable }

class _CopyMeta {
  final CopyType copyType;
  final String import;
  final Type baseClass;
  final String newClassName;
  final Map<String, String> fields;

  const _CopyMeta({this.copyType, this.import, this.baseClass, this
      .newClassName,
    this
        .fields});
}

class CopyableMeta extends _CopyMeta {
  const CopyableMeta({
    String import,
    Type baseClass,
    String newClassName,
    Map<String, String> fields,
  }) : super(
      copyType: CopyType.copyable,
      import: import,
      baseClass: baseClass,
      newClassName: newClassName,
      fields: fields
  );
}

class CopierMeta extends _CopyMeta {
  final String defaultObjectCode;

  const CopierMeta({
    String import,
    Type baseClass,
    String newClassName,
    Map<String, String> fields,
    this.defaultObjectCode,
  }) : super(
    copyType: CopyType.copier,
    import: import,
    baseClass: baseClass,
    newClassName: newClassName,
    fields: fields,
  );
}

class CopyMetaGenerator {
  final List<CopierMeta> copiers;
  final List<CopyableMeta>copyables;
  const CopyMetaGenerator({this.copiers, this.copyables});
}
