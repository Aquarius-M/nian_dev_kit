import 'dart:convert';

import 'package:nian_dev_kit/core/pluggable.dart';
import 'package:flutter/material.dart';
import 'icon.dart' as icon;
import 'src/app_info_page.dart';

class AppInfoPluggable extends StatefulWidget implements Pluggable {
  const AppInfoPluggable({super.key});

  @override
  Widget? buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => '应用信息';

  @override
  String get displayName => '应用信息';

  @override
  int get index => 7;
  @override
  void onTrigger() {}

  @override
  State<AppInfoPluggable> createState() => _ApplnfoPluggableState();
}

class _ApplnfoPluggableState extends State<AppInfoPluggable> {
  @override
  Widget build(BuildContext context) {
    return const AppInfoPage();
  }
}
