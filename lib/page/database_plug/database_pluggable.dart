import 'dart:convert';

import 'package:nian_dev_kit/core/pluggable.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'icon.dart' as icon;

class DatabasePluggable extends StatelessWidget implements Pluggable {
  const DatabasePluggable({super.key});

  @override
  Widget? buildWidget(BuildContext? context) => this;

  @override
  String get displayName => '数据库';

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => '数据库';

  @override
  int get index => 5;

  @override
  void onTrigger() {}

  @override
  Widget build(BuildContext context) {
    return const DatabaseList();
  }
}
