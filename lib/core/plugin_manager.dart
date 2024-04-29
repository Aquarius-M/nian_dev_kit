import 'pluggable.dart';

class PluginManager {
  static PluginManager? _instance;

  Map<String, Pluggable?> get pluginsMap => _pluginsMap;

  final Map<String, Pluggable?> _pluginsMap = {};

  Pluggable? _activatedPluggable;
  String? get activatedPluggableName => _activatedPluggable?.name;

  static PluginManager get instance {
    _instance ??= PluginManager._();
    return _instance!;
  }

  PluginManager._();

  /// Register a single [plugin]
  Future register(Pluggable plugin) async {
    if (plugin.name.isEmpty) {
      return;
    }
    _pluginsMap[plugin.name] = plugin;
  }

  /// Register multiple [plugins]
  Future registerAll(List<Pluggable> plugins) async {
    for (final plugin in plugins) {
      await register(plugin);
    }
  }

  void activatePluggable(Pluggable pluggable) {
    _activatedPluggable = pluggable;
  }

  void deactivatePluggable(Pluggable pluggable) {
    if (_activatedPluggable?.name == pluggable.name) {
      _activatedPluggable = null;
    }
  }
}
