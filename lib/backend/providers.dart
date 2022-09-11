import 'package:files/backend/database/helper.dart';
import 'package:files/backend/database/model.dart';
import 'package:files/backend/folder_provider.dart';
import 'package:files/backend/stat_cache_proxy.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class _ProvidersSingleton {
  _ProvidersSingleton._();

  bool _inited = false;

  Isar? _isar;
  FolderProvider? _folderProvider;
  EntityStatCacheHelper? _helper;
  StatCacheProxy? _cacheProxy;

  Isar get isar {
    _checkForAvailability();
    return _isar!;
  }

  FolderProvider get folderProvider {
    _checkForAvailability();
    return _folderProvider!;
  }

  EntityStatCacheHelper get helper {
    _checkForAvailability();
    return _helper!;
  }

  StatCacheProxy get cacheProxy {
    _checkForAvailability();
    return _cacheProxy!;
  }

  void _checkForAvailability() {
    if (!_inited) throw Exception("Providers not inited or disposed");
  }

  static final _ProvidersSingleton instance = _ProvidersSingleton._();

  Future<void> _init() async {
    if (_inited) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      schemas: [EntityStatSchema],
      directory: p.join(dir.path, 'isar'),
    );
    _folderProvider = await FolderProvider.init();
    _helper = EntityStatCacheHelper();
    _cacheProxy = StatCacheProxy();
    _inited = true;
  }

  Future<void> _dispose() async {
    await isar.close();
    _folderProvider = null;
    _helper = null;
    _cacheProxy = null;
    _inited = false;
  }

  void _initSync() {
    if (_inited) return;
    WidgetsFlutterBinding.ensureInitialized();

    getApplicationDocumentsDirectory().then((directory) {
      Isar.open(
        schemas: [EntityStatSchema],
        directory: p.join(directory.path, 'isar'),
      ).then((isar) => _isar = isar);
    });

    FolderProvider.init().then((provider) => _folderProvider = provider);

    _helper = EntityStatCacheHelper();
    _cacheProxy = StatCacheProxy();
    _inited = true;
  }
}

Future<void> initProviders() async => _ProvidersSingleton.instance._init();

void initProvidersSync() => _ProvidersSingleton.instance._initSync();

Future<void> disposeProviders() async =>
    _ProvidersSingleton.instance._dispose();

Isar get isar => _ProvidersSingleton.instance.isar;

FolderProvider get folderProvider =>
    _ProvidersSingleton.instance.folderProvider;

EntityStatCacheHelper get helper => _ProvidersSingleton.instance.helper;

StatCacheProxy get cacheProxy => _ProvidersSingleton.instance.cacheProxy;
