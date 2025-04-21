import 'dart:convert';
import 'package:hive/hive.dart';

class CacheService {
  static const _boxName = 'httpCache';
  final Box<Map> _box = Hive.box<Map>(_boxName);

  //Duração que um cache será considerado válido
  final Duration cacheDuration;

  CacheService({this.cacheDuration = const Duration(hours: 1)});

  /// Converte a queryKey (lista) em string p/ usar como Hive key.
  String _serializeKey(List<Object?> queryKey) {
    // ex: ["todos",123] -> '["todos",123]'
    return jsonEncode(queryKey);
  }

  /// Retorna o JSON em cache se existir e ainda não expirou (segundo `ttl`).
  String? getCachedData(List<Object?> queryKey) {
    final key = _serializeKey(queryKey);

    final entry = _box.get(key);

    if (entry == null) {
      return null;
    }

    final storedAt = DateTime.parse(entry['timestamp'] as String);

    if (entry.containsKey('ttl')) {
      final ttl = Duration(seconds: entry['ttl'] as int);

      if (DateTime.now().difference(storedAt) > ttl) {
        // Significa que o cache já expirou de acordo com o ttl definido
        _box.delete(key);
        return null;
      }
    }

    return entry['data'] as String;
  }

  String? getCachedETag(List<Object?> queryKey) {
    final key = _serializeKey(queryKey);

    final entry = _box.get(key);

    if (entry == null) {
      return null;
    }

    final storedAt = DateTime.parse(entry['timestamp'] as String);

    if (entry.containsKey('ttl')) {
      final ttl = Duration(seconds: entry['ttl'] as int);

      if (DateTime.now().difference(storedAt) > ttl) {
        // Significa que o cache já expirou de acordo com o ttl definido
        _box.delete(key);
        return null;
      }
    }

    return entry['etag'] as String?;
  }

  /// Guarda o `data` (já serializado em JSON) em cache p/ essa queryKey.
  Future<void> setCacheData({
    required List<Object?> queryKey,
    required String data,
    String? etag,
    int? ttl,
  }) async {
    final effectiveTtl =
        ttl != null
            ? Duration(seconds: ttl).inSeconds
            : Duration(hours: 1).inSeconds; // <- padrão de 1h

    final key = _serializeKey(queryKey);

    final entry = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'ttl': effectiveTtl,
      if (etag != null) 'etag': etag,
      'storedAt': DateTime.now().toIso8601String(),
    };

    await _box.put(key, entry);
  }

  /// Invalida **exatamente** queryKey informada no parâmetro.
  Future<void> invalidateQuery(List<Object?> queryKey) async {
    final key = _serializeKey(queryKey);
    await _box.delete(key);
  }

  /// Invalida **tudo** que compartilhe o prefixo informado no parâmetro.
  /// Ex: prefix ['todos'] vai invalidar ['todos'], ['todos',1], ['todos',2], etc.
  Future<void> invalidatePrefixQuery(List<Object?> prefix) async {
    final p = _serializeKey(prefix);

    final toRemove = _box.keys.where((k) => k.startsWith(p)).toList();

    for (final k in toRemove) {
      await _box.delete(k);
    }
  }

  Future<void> clearAllCache() async {
    await _box.clear();
  }
}
