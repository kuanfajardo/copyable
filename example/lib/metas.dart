import 'package:copyable/generator.dart';

import 'package:flutter/material.dart';

/// For classes that are defined elsewhere (not editable, i.e. Flutter
/// widgets), define a CopyableMeta object describing the class that you want
/// to generate a Copyable version of for. These "foreign" copiers will end up
/// in $fileName.copyable.dart files.
const CopyableMeta bottomNavigationBarCopyableMeta = CopyableMeta(
  import: 'package:flutter/material.dart',
  baseClass: BottomNavigationBar,
  fields: {
    'backgroundColor': 'Color',
    'elevation': 'double',
    'items': 'List<BottomNavigationBarItem>',
  },
);

/// For classes that are defined elsewhere (not editable, i.e. Flutter
/// widgets), define a CopierMeta object describing the class that you want
/// to generate a copier for. These "foreign" copiers will end up in $fileName
/// .copier.dart files.
const CopierMeta appBarCopierMeta = CopierMeta(
    import: 'package:flutter/material.dart',
    baseClass: AppBar,
    fields: {
      'title': 'Widget',
      'elevation': 'double',
      'primary': 'bool',
    },
    defaultObjectCode: 'AppBar()' // If not provided defaults to `$baseClassName()`
);

const CopyMetaGenerator metaGenerator = CopyMetaGenerator(
    copyables: [
      bottomNavigationBarCopyableMeta,
    ],
    copiers: [
      appBarCopierMeta,
    ]
);
