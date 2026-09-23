import 'package:flutter/material.dart';

enum CustomerType {
  gents,
  ladies,
  kids,
}

extension CustomerTypeX on CustomerType {
  String get title {
    switch (this) {
      case CustomerType.gents:
        return 'Gents';
      case CustomerType.ladies:
        return 'Ladies';
      case CustomerType.kids:
        return 'Kids';
    }
  }

  IconData get icon {
    switch (this) {
      case CustomerType.gents:
        return Icons.man_rounded;
      case CustomerType.ladies:
        return Icons.woman_rounded;
      case CustomerType.kids:
        return Icons.child_care_rounded;
    }
  }
}
