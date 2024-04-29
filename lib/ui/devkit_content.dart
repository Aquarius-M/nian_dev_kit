import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/global.dart';
import '../core/store_manager.dart';
import '../core/pluggable.dart';
import '../core/plugin_manager.dart';
import 'menu_page.dart';
import 'toolbar_widget.dart';
import 'icon.dart' as icon;

final GlobalKey contentPageKey = GlobalKey();

class ContentPage extends StatefulWidget {
  final VoidCallback? refreshChildLayout;
  ContentPage({Key? key, this.refreshChildLayout}) : super(key: contentPageKey);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final PluginStoreManager _storeManager = PluginStoreManager();
  final Size _windowSize = windowSize;
  Widget? _currentWidget;
  double? _dx;
  double? _dy;
  BuildContext? buildContext;

  Widget emptyWidget = Container();

  Pluggable? _currentSelected;
  bool minimalContent = true;
  Widget? _menuPage;
  Widget? _toolbarWidget;
  bool _showedMenu = false;

  @override
  void initState() {
    super.initState();
    _storeManager.fetchFloatingDotPos().then((value) {
      if (value == null || value.split(',').length != 2) {
        _dx = _windowSize.width - dotSize.width / 2 - margin * 4;
        _dy = _windowSize.height - dotSize.height * 2 - bottomDistance;
        setState(() {});
        return;
      }
      final x = double.parse(value.split(',').first);
      final y = double.parse(value.split(',').last);
      if (MediaQuery.of(context).size.height - dotSize.height < y ||
          MediaQuery.of(context).size.width - dotSize.width < x) {
        return;
      }
      _dx = x;
      _dy = y;
      setState(() {});
    });
    _currentWidget = emptyWidget;

    itemTapAction(pluginData) async {
      if (pluginData is PluggableWithAnywhereDoor) {
        dynamic result;
        if (pluginData.routeNameAndArgs != null) {
          result = await pluginData.navigator?.pushNamed(
              pluginData.routeNameAndArgs!.item1,
              arguments: pluginData.routeNameAndArgs!.item2);
        } else if (pluginData.route != null) {
          result = await pluginData.navigator?.push(pluginData.route!);
        }
        pluginData.popResultReceive(result);
      } else {
        _currentSelected = pluginData;
        if (_currentSelected != null) {
          PluginManager.instance.activatePluggable(_currentSelected!);
        }
        _handleAction(buildContext, pluginData!);
        if (widget.refreshChildLayout != null) {
          widget.refreshChildLayout!();
        }
        pluginData.onTrigger();
      }
    }

    _menuPage = MenuPage(
      action: itemTapAction,
      minimalAction: () {
        minimalContent = true;
        _updatePanelWidget();
        PluginStoreManager().storeMinimalToolbarSwitch(true);
      },
      closeAction: () {
        _showedMenu = false;
        _updatePanelWidget();
      },
    );
    _toolbarWidget = ToolBarWidget(
      action: itemTapAction,
      maximalAction: () {
        minimalContent = false;
        _updatePanelWidget();
        PluginStoreManager().storeMinimalToolbarSwitch(false);
      },
      closeAction: () {
        _showedMenu = false;
        _updatePanelWidget();
      },
    );
  }

  void _handleAction(BuildContext? context, Pluggable data) {
    _currentWidget = data.buildWidget(context);
    setState(() {
      _showedMenu = false;
    });
  }

  void onTap() {
    if (_currentSelected != null) {
      _closeActivatedPluggable();
      return;
    }
    _showedMenu = !_showedMenu;
    _updatePanelWidget();
  }

  void _closeActivatedPluggable() {
    PluginManager.instance.deactivatePluggable(_currentSelected!);
    if (widget.refreshChildLayout != null) {
      widget.refreshChildLayout!();
    }
    _currentSelected = null;
    _currentWidget = emptyWidget;
    if (minimalContent) {
      _currentWidget = _toolbarWidget;
      _showedMenu = true;
    } else {
      _currentWidget = _menuPage;
      _showedMenu = true;
    }
    setState(() {});
  }

  void _updatePanelWidget() {
    setState(() {
      _currentWidget = _showedMenu
          ? (minimalContent ? _toolbarWidget : _menuPage)
          : emptyWidget;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void dragEvent(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - dotSize.width / 2;
    _dy = details.globalPosition.dy - dotSize.height / 2;
    setState(() {});
  }

  void dragEnd(DragEndDetails details) {
    if (_dx! + dotSize.width / 2 < _windowSize.width / 2) {
      _dx = margin;
    } else {
      _dx = _windowSize.width - dotSize.width - margin;
    }
    if (_dy! + dotSize.height > _windowSize.height) {
      _dy = _windowSize.height - dotSize.height - margin;
    } else if (_dy! < 0) {
      _dy = margin;
    }
    _storeManager.storeFloatingDotPos(_dx!, _dy!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    if (_windowSize.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      width: _windowSize.width,
      height: _windowSize.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _currentWidget!,
          _windowSize.isEmpty
              ? const SizedBox()
              : Positioned(
                  left: _dx,
                  top: _dy,
                  child: GestureDetector(
                    onTap: onTap,
                    onVerticalDragEnd: dragEnd,
                    onHorizontalDragEnd: dragEnd,
                    onHorizontalDragUpdate: dragEvent,
                    onVerticalDragUpdate: dragEvent,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      width: dotSize.width,
                      height: dotSize.height,
                      child: Center(
                        child: _logoWidget(),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _logoWidget() {
    if (_currentSelected != null) {
      return SizedBox(
        height: 30,
        width: 30,
        child: Image(
          gaplessPlayback: true,
          image: _currentSelected!.iconImageProvider,
        ),
      );
    }
    return Image(
      height: 30,
      width: 30,
      gaplessPlayback: true,
      image: MemoryImage(
        base64Decode(icon.iconData),
      ),
    );
  }
}
