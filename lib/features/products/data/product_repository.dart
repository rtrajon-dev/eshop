import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eshop/features/products/data/product_dummy_data.dart';
import 'package:eshop/features/products/domain/models/product.dart';

/// Serves products one page at a time.
///
/// Today it slices the in-memory [ProductDummyData] and adds an artificial
/// delay to mimic a network round-trip — so the scroll-to-load UX behaves
/// exactly as it would against a real paginated API. Swap the body of
/// [fetchPage] for a `dio` call later without touching the view-model or UI.
class ProductRepository {
  const ProductRepository();

  /// Number of items returned per page.
  static const int pageSize = 8;

  /// Simulated network latency per page request.
  static const Duration _latency = Duration(milliseconds: 900);

  /// Returns the products for [page] (zero-based). An empty list means there
  /// are no more pages.
  Future<List<Product>> fetchPage(int page) async {
    await Future.delayed(_latency);

    final all = ProductDummyData.products;
    final start = page * pageSize;
    if (start >= all.length) return const [];

    final end = (start + pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }
}

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => const ProductRepository(),
);
