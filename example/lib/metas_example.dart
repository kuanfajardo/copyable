import 'package:copyable_generator/annotations.dart';
import 'package:flutter/material.dart';

const CopyableMeta appBarCopyableMeta = CopyableMeta(
  import: 'package:flutter/material.dart',
  baseClass: AppBar,
  fields: {
    'title': Widget,
    'elevation': double,
    'primary': bool,
  },
);

const CopierMeta appBarCopierMeta = CopierMeta(
    import: 'package:flutter/material.dart',
    baseClass: AppBar,
    fields: {
      'title': Widget,
      'elevation': double,
      'primary': bool,
    },
    defaultObjectCode: 'AppBar()' // If not provided defaults to `$baseClassName()`
);

const CopyMetaGenerator metaGenerator = CopyMetaGenerator(
  copyables: [
    appBarCopyableMeta
  ],
  copiers: [
    appBarCopierMeta
  ]
);


