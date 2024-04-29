// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/pluggable_message_service.dart';
import 'core/global.dart';
import 'core/pluggable.dart';
import 'core/plugin_manager.dart';
import 'page/align_ruler/align_ruler.dart';
import 'page/app_info_plug/app_info_pluggable.dart';
import 'page/applog_plug/applog_pluggable.dart';
import 'page/channel_monitor/channel_monitor.dart';
import 'page/color_sucker/color_sucker.dart';
import 'page/database_plug/database_pluggable.dart';
import 'page/device_info/device_info_panel.dart';
import 'page/regular_plugs/regular_pluggable.dart';
import 'page/widget_detail_inspector/widget_detail_inspector.dart';
import 'page/widget_info_inspector/widget_info_inspector.dart';
import 'ui/devkit_content.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

const defaultLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class DevKit extends StatefulWidget {
  final Widget child;
  final bool enable;
  final List<Pluggable>? pluginsList;
  final Iterable<Locale>? supportedLocales;
  final Iterable<LocalizationsDelegate> localizationsDelegates;

  const DevKit({
    super.key,
    this.pluginsList,
    required this.child,
    this.enable = true,
    this.supportedLocales,
    this.localizationsDelegates = defaultLocalizationsDelegates,
  });

  @override
  State<DevKit> createState() => _DevKitState();
}

/// Hold the [_UMEWidgetState] as a global variable.
_DevKitState? _devKitState;

class _DevKitState extends State<DevKit> {
  _DevKitState() {
    // Make sure only a single `DevKit` is being used.
    assert(
      _devKitState == null,
      'Only one `DevKit` can be used at the same time.',
    );
    if (_devKitState != null) {
      throw StateError('Only one `DevKit` can be used at the same time.');
    }
    _devKitState = this;
  }

  late Widget _child;
  VoidCallback? _onMetricsChanged;

  bool _overlayEntryInserted = false;
  OverlayEntry _overlayEntry = OverlayEntry(
    builder: (_) => const SizedBox.shrink(),
  );

  List<Pluggable> commonPluginsList = [
    const RegularPluggable(),
    const ApplogPluggable(),
    const AppInfoPluggable(),
    const DeviceInfoPanel(),
    const DatabasePluggable(),
    ChannelPluggable(),
    if (kDebugMode) const WidgetInfoInspector(),
    if (kDebugMode) const WidgetDetailInspector(),
    const ColorSucker(),
    const AlignRuler(),
  ];

  @override
  void initState() {
    PluginManager.instance.registerAll(widget.pluginsList ?? []).then((value) {
      PluginManager.instance.registerAll(commonPluginsList);
    });
    super.initState();
    _replaceChild();
    _injectOverlay();
    _onMetricsChanged =
        bindingAmbiguate(WidgetsBinding.instance)!.window.onMetricsChanged;
    bindingAmbiguate(WidgetsBinding.instance)!.window.onMetricsChanged = () {
      if (_onMetricsChanged != null) {
        _onMetricsChanged!();
        _replaceChild();
        setState(() {});
      }
    };
  }

  @override
  void didUpdateWidget(DevKit oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.enable
        ? PluggableMessageService().resetListener()
        : PluggableMessageService().clearListener();
    if (widget.enable != oldWidget.enable && widget.enable) {
      _injectOverlay();
    }
    if (widget.child != oldWidget.child) {
      _replaceChild();
    }
    if (!widget.enable) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    if (_onMetricsChanged != null) {
      bindingAmbiguate(WidgetsBinding.instance)!.window.onMetricsChanged =
          _onMetricsChanged;
    }
    super.dispose();
    // Do the cleaning at last.
    _devKitState = null;
  }

  void _removeOverlay() {
    // Call `remove` only when the entry has been inserted.
    if (_overlayEntryInserted) {
      _overlayEntry.remove();
      _overlayEntryInserted = false;
    }
  }

  void _replaceChild() {
    final nestedWidgets =
        PluginManager.instance.pluginsMap.values.where((value) {
      return value != null && value is PluggableWithNestedWidget;
    }).toList();
    Widget layoutChild = _buildLayout(
        widget.child, widget.supportedLocales, widget.localizationsDelegates);
    for (var item in nestedWidgets) {
      if (item!.name != PluginManager.instance.activatedPluggableName) {
        continue;
      }
      if (item is PluggableWithNestedWidget) {
        layoutChild = item.buildNestedWidget(layoutChild);
        break;
      }
    }
    _child =
        Directionality(textDirection: TextDirection.ltr, child: layoutChild);
  }

  void _injectOverlay() {
    bindingAmbiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
      if (_overlayEntryInserted) {
        return;
      }
      if (widget.enable) {
        _overlayEntry = OverlayEntry(
          builder: (_) => Material(
            type: MaterialType.transparency,
            child: ContentPage(
              refreshChildLayout: () {
                _replaceChild();
                setState(() {});
              },
            ),
          ),
        );
        overlayKey.currentState?.insert(_overlayEntry);
        _overlayEntryInserted = true;
      }
    });
  }

  Stack _buildLayout(Widget child, Iterable<Locale>? supportedLocales,
      Iterable<LocalizationsDelegate> delegates) {
    return Stack(
      children: <Widget>[
        RepaintBoundary(key: rootKey, child: child),
        MediaQuery(
          data: MediaQueryData.fromView(
              bindingAmbiguate(WidgetsBinding.instance)!
                  .platformDispatcher
                  .implicitView!),
          child: ScaffoldMessenger(
            child: Overlay(key: overlayKey),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: devThemeData,
        locale: widget.supportedLocales?.first ?? const Locale('zh', 'CN'),
        supportedLocales: [
          widget.supportedLocales?.first ?? const Locale('zh', 'CN')
        ],
        localizationsDelegates: widget.localizationsDelegates,
        builder: (context, child) {
          return MediaQuery(
            ///设置文字大小不随系统设置改变
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: GestureDetector(
              onTap: () {
                /// 隐藏键盘
                SystemChannels.textInput.invokeMethod('TextInput.hide');

                ///设置点击空白取消焦点
                FocusScopeNode focus = FocusScope.of(context);
                if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
              },
              child: child,
            ),
          );
        },
        home: _child,
      );
}
