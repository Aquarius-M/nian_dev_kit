import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../utils/device_utils.dart';
import '../../../utils/utils.dart';

/// 应用信息页面
class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  String? wifiIP = '';
  String? proxyIp = '';
  String? packageName = '';
  String? packageVersion = "";
  String? buildNumber = "";
  String? buildSignature = "";
  String? getCachePath = "";
  String? getPhoneLocalPath = "";
  String? installerStore = "";
  String? appName = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final info = NetworkInfo();

    wifiIP = await info.getWifiIP();
    appName = await KitDeviceUtils.appName();
    packageName = await KitDeviceUtils.packageName();
    packageVersion = await KitDeviceUtils.version();
    buildNumber = await KitDeviceUtils.buildNumber();
    buildSignature = await KitDeviceUtils.buildSignature();
    getCachePath = await KitDeviceUtils.getCachePath();
    getPhoneLocalPath = await KitDeviceUtils.getPhoneLocalPath();
    installerStore = await KitDeviceUtils.installerStore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '应用信息',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPanel('appName', text: '$appName', onTap: () {
              // StringUtils.copy(appName);
            }),
            _buildPanel('packageName', text: '$packageName', onTap: () {
              // StringUtils.copy(packageName);
            }),
            _buildPanel('packageVersion', text: '$packageVersion', onTap: () {
              // StringUtils.copy(packageVersion);
            }),
            _buildPanel('buildNumber', text: '$buildNumber', onTap: () {
              // StringUtils.copy(buildNumber);
            }),
            _buildPanel('Signature', text: '$buildSignature', onTap: () {
              // StringUtils.copy(buildSignature);
            }),
            _buildPanel('CachePath', text: '$getCachePath', onTap: () {
              KitStringUtils.copy(getCachePath);
            }),
            _buildPanel('LocalPath', text: '$getPhoneLocalPath', onTap: () {
              KitStringUtils.copy(getPhoneLocalPath);
            }),
            _buildPanel('installerStore', text: '$installerStore', onTap: () {
              // StringUtils.copy(installerStore);
            }),
            _buildPanel('IP', text: wifiIP, onTap: () {
              KitStringUtils.copy(wifiIP);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(
    String title, {
    String? text,
    Widget? child,
    VoidCallback? onTap,
    VoidCallback? onLongTap,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            KitStringUtils.copy(title);
          },
      onLongPress: onLongTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '$title${text != null ? ':' : ''}',
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.5,
                ),
              ),
            ),
            Expanded(
              child: child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: text != null
                            ? RichText(
                                // strutStyle: const StrutStyle(
                                //   forceStrutHeight: true,
                                //   height: 1,
                                // ),
                                text: TextSpan(
                                    text: text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: const [
                                      // WidgetSpan(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(left: 4),
                                      //     child: GestureDetector(
                                      //       onTap: onTap,
                                      //       child: const Icon(
                                      //         Icons.copy,
                                      //         size: 16,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ]),
                              )
                            : const SizedBox(),
                      ),
                      const Icon(Icons.keyboard_arrow_right_rounded)
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
