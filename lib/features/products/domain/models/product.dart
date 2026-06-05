/// A product sold in the eShop.
///
/// All fields are immutable — instances are built once from the dummy data
/// source ([ProductDummyData]) and never mutated. [imageUrl] is a remote
/// network URL (loaded via `Image.network`), not a bundled asset.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  /// Stable unique identifier.
  final String id;

  /// Display name (e.g. "Wireless Headphones").
  final String name;

  /// Short marketing description shown under the name.
  final String description;

  /// Price in USD.
  final double price;

  /// Remote image URL — rendered with `Image.network`.
  final String imageUrl;

  /// Average customer rating, 0.0–5.0.
  final double rating;

  /// Price formatted for display (e.g. "$49.99").
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
