// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../core/inspector_overlay.dart';
import '../../core/pluggable.dart';
import '../../dev_kit.dart';
import '../../ui/hit_test.dart';
import 'icon.dart' as icon;
import 'package:flutter/rendering.dart';

class WidgetInfoInspector extends StatefulWidget implements Pluggable {
  const WidgetInfoInspector({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WidgetInfoInspectorState createState() => _WidgetInfoInspectorState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  int get index => 3;

  @override
  String get name => '组件信息';

  @override
  String get displayName => '组件信息';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);
}

class _WidgetInfoInspectorState extends State<WidgetInfoInspector> with WidgetsBindingObserver {
  _WidgetInfoInspectorState() : selection = WidgetInspectorService.instance.selection;

  final window = bindingAmbiguate(WidgetsBinding.instance)!.window;

  Offset? _lastPointerLocation;
  OverlayEntry _overlayEntry = OverlayEntry(builder: (ctx) => Container());

  final InspectorSelection selection;

  void _inspectAt(Offset? position) {
    final List<RenderObject> selected = HitTest.hitTest(position, edgeHitMargin: 2.0);
    setState(() {
      selection.candidates = selected;
    });
  }

  void _handlePanDown(DragDownDetails event) {
    _lastPointerLocation = event.globalPosition;
    _inspectAt(event.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    final Rect bounds = (Offset.zero & (window.physicalSize / window.devicePixelRatio)).deflate(1.0);
    if (!bounds.contains(_lastPointerLocation!)) {
      setState(() {
        selection.clear();
      });
    }
  }

  void _handleTap() {
    if (_lastPointerLocation != null) {
      _inspectAt(_lastPointerLocation);
    }
  }

  @override
  void initState() {
    super.initState();
    selection.clear();
    bindingAmbiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) {
      _overlayEntry = OverlayEntry(builder: (_) => const _DebugPaintButton());
      overlayKey.currentState?.insert(_overlayEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    GestureDetector gesture = GestureDetector(
      onTap: _handleTap,
      onPanDown: _handlePanDown,
      onPanEnd: _handlePanEnd,
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(child: SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height)),
    );
    children.add(gesture);
    children.add(InspectorOverlay(selection: selection));
    return Stack(textDirection: TextDirection.ltr, children: children);
  }

  @override
  void dispose() {
    super.dispose();
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }
}

class _DebugPaintButton extends StatefulWidget {
  const _DebugPaintButton();

  @override
  State<StatefulWidget> createState() => _DebugPaintButtonState();
}

class _DebugPaintButtonState extends State<_DebugPaintButton> {
  double _dx = windowSize.width - dotSize.width - margin * 2;
  double _dy = windowSize.width - dotSize.width - bottomDistance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _dx,
      top: _dy,
      child: SizedBox(
        width: dotSize.width,
        height: dotSize.width,
        child: GestureDetector(
            onPanUpdate: _buttonPanUpdate,
            child: FloatingActionButton(
              elevation: 10,
              onPressed: _showAllSize,
              child: const Icon(Icons.all_out_sharp),
            )),
      ),
    );
  }

  void _buttonPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = details.globalPosition.dx - dotSize.width / 2;
      _dy = details.globalPosition.dy - dotSize.width / 2;
    });
  }

  void _showAllSize() async {
    debugPaintSizeEnabled = !debugPaintSizeEnabled;
    setState(() {
      late RenderObjectVisitor visitor;
      visitor = (RenderObject child) {
        child.markNeedsPaint();
        child.visitChildren(visitor);
      };
      bindingAmbiguate(RendererBinding.instance)?.renderView.visitChildren(visitor);
    });
  }

  @override
  void dispose() {
    super.dispose();
    debugPaintSizeEnabled = false;
    bindingAmbiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) {
      late RenderObjectVisitor visitor;
      visitor = (RenderObject child) {
        child.markNeedsPaint();
        child.visitChildren(visitor);
      };
      bindingAmbiguate(RendererBinding.instance)?.renderView.visitChildren(visitor);
    });
  }
}
