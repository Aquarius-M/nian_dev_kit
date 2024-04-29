import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import '../../core/pluggable.dart';
import 'icon.dart' as icon;

class DeviceInfoPanel extends StatefulWidget implements Pluggable {
  final Platform platform;

  const DeviceInfoPanel({super.key, this.platform = const LocalPlatform()});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceInfoPanelState createState() => _DeviceInfoPanelState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  int get index => 6;

  @override
  String get name => '设备信息';

  @override
  String get displayName => '设备信息';

  @override
  void onTrigger() {}
}

class _DeviceInfoPanelState extends State<DeviceInfoPanel> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  void _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map dataMap = {};
    if (widget.platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      dataMap = _readAndroidBuildData(androidDeviceInfo);
    } else if (widget.platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      dataMap = _readIosDeviceInfo(iosDeviceInfo);
    }
    StringBuffer buffer = StringBuffer();
    dataMap.forEach((k, v) {
      buffer.write('$k:  $v\n');
    });
    _content = buffer.toString();
    setState(() {});
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname': data.utsname.sysname,
      'utsname.nodename': data.utsname.nodename,
      'utsname.release': data.utsname.release,
      'utsname.version': data.utsname.version,
      'utsname.machine': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 32, bottom: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // 阴影的颜色
          offset: const Offset(0, 6), // 阴影与容器的距离
          blurRadius: 8.0, // 高斯的标准偏差与盒子的形状卷积。
          spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
        ),
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text(
                '设备信息',
                textScaler: TextScaler.linear(1.15),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              )),
          Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 150),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(_content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  strutStyle: const StrutStyle(forceStrutHeight: true, height: 2)),
            ),
          ),
        ],
      ),
    );
  }
}
