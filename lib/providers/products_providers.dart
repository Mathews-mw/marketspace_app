import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:marketsapce_app/services/http_service.dart';
import 'package:marketsapce_app/services/cache_service.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product_info.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product-details.dart';

class ProductsProviders with ChangeNotifier {
  final HttpService _httpService = HttpService();
  final CacheService _cacheService = CacheService();

  List<ProductInfo> _productsInfo = [];

  ({String? previousCursor, String? nextCursor, bool? stillHaveData}) _cursor =
      (previousCursor: null, nextCursor: null, stillHaveData: null);

  List<ProductInfo> get productsInfo {
    return [..._productsInfo];
  }

  ({String? previousCursor, String? nextCursor, bool? stillHaveData})
  get cursor {
    return _cursor;
  }

  Future<void> fetchProductsInfo({String? cursor}) async {
    try {
      final queryParameters = cursor != null ? '&cursor=$cursor' : '';

      final response = await _httpService.get(
        endpoint: 'products/cursor-mode?limit=20$queryParameters',
      );

      final productsInfo =
          (response.body['products'] as List)
              .map((item) => ProductInfo.fromJson(item))
              .toList();

      _cursor = (
        previousCursor: response.body['previous_cursor'] as String?,
        nextCursor: response.body['next_cursor'] as String?,
        stillHaveData: response.body['still_have_data'] as bool,
      );

      _productsInfo = [..._productsInfo, ...productsInfo];
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<ProductDetails> getProductDetails(String productId) async {
    final queryKey = ['products', productId];
    final headers = <String, String>{};

    try {
      final hitCacheETag = _cacheService.getCachedETag(queryKey);
      final hitCacheData = _cacheService.getCachedData(queryKey);

      if (hitCacheETag != null) {
        headers['If-None-Match'] = hitCacheETag;
      }

      final response = await _httpService.get(
        endpoint: 'products/$productId/details',
        headers: headers,
      );

      if (response.notModified) {
        if (hitCacheData != null) {
          final json = jsonDecode(hitCacheData);
          final productDetails = ProductDetails.fromJson(json);

          return productDetails;
        }
      }

      _cacheService.setCacheData(
        queryKey: queryKey,
        data: jsonEncode(response.body),
        etag: response.headers['etag'],
        ttl: response.maxAge,
      );

      final productDetails = ProductDetails.fromJson(response.body);

      return productDetails;
    } catch (error) {
      rethrow;
    }
  }
}
