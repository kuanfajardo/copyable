/// Annotation for generator
class BuildCopier {
  const BuildCopier();
}

const build_copier = BuildCopier();

class CopyMeta {
  final String baseClass;
  final String prefix;
  final Map<String, String> fields;

  const CopyMeta({this.baseClass, this.prefix = 'Copyable', this
      .fields});
}

class CopyFunctions {
  const CopyFunctions();
}

const copy_functions = CopyFunctions();
