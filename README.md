# eshop

A small Flutter shopping-catalogue app that renders a paginated product list
with **infinite scroll** and **pull-to-refresh**, built on a clean,
feature-first architecture (data → domain → presentation) with **Riverpod**.

Data is served from an in-memory catalogue behind a repository that mimics a
real paginated API — including artificial network latency — so the UX behaves
exactly as it would against a live backend. The API-backed sibling project,
[`eshop_api_integration`](../eshop_api_integration), swaps that repository for
a real **Dio** call to a REST API without touching the UI or view-model.

## Data source

Products come from a static, in-memory list of 30 items in
[`lib/features/products/data/product_dummy_data.dart`](lib/features/products/data/product_dummy_data.dart).

- `ProductRepository.fetchPage(page)` slices that list into pages of
  `pageSize` (8) items and waits ~900 ms to simulate a network round-trip.
- An empty page means there are no more items — `hasMore` flips to `false`.
- Product images are remote `picsum.photos` seeded URLs, rendered with
  `Image.network`, so every thumbnail reliably resolves.

To move to a real API, replace the body of `ProductRepository.fetchPage` with a
network call — nothing else needs to change.

## Features

- 🛍️ Paginated product list
- ♾️ Infinite scroll — the next page is requested as you near the bottom
- 🔄 Pull-to-refresh
- 🖼️ Remote images with loading/error placeholders
- ⚠️ Error state with inline retry
- 📱 Responsive sizing via `flutter_screenutil`, light/dark themes

## Tech stack

| Concern        | Package              |
| -------------- | -------------------- |
| State mgmt     | `flutter_riverpod`   |
| Routing        | `go_router`          |
| Responsive UI  | `flutter_screenutil` |
| Fonts          | `google_fonts`       |

## Architecture

Feature-first, layered. The view never knows where data comes from — the data
source is hidden behind the repository, so it can be swapped (or mocked)
without touching the UI or the view-model.

```
lib/
├── main.dart                     # entry point → bootstrap()
├── bootstrap.dart                # ensures bindings, wraps app in ProviderScope
├── app/
│   ├── app.dart                  # MaterialApp.router + ScreenUtilInit + theme
│   ├── router/                   # go_router config + route constants
│   └── theme/                    # light / dark themes
└── features/
    └── products/
        ├── data/
        │   ├── product_dummy_data.dart   # static in-memory catalogue
        │   └── product_repository.dart   # page → list slice (+ latency)
        ├── domain/
        │   └── models/product.dart       # immutable Product model
        └── presentation/
            ├── viewmodel/products_provider.dart # ProductsNotifier (pagination state)
            ├── view/product_list_page.dart      # list + scroll + refresh
            └── widgets/product_card.dart        # single product row
```

### Data flow

```
ProductListPage  ──watch/read──▶  productsProvider (ProductsNotifier)
                                        │ loadMore() / refresh()
                                        ▼
                                 ProductRepository.fetchPage(page)
                                        │ slice + latency
                                        ▼
                                 ProductDummyData.products
```

- **`ProductRepository`** maps a zero-based page to a list slice and returns up
  to `pageSize` items.
- **`ProductsNotifier`** holds the accumulated list and pagination flags
  (`isLoading`, `hasMore`, `page`, `error`); `hasMore` flips to `false` once a
  page returns fewer than `pageSize` items.
- **`ProductListPage`** triggers `loadMore()` on first frame and on scroll, and
  shows a footer spinner / retry / end-of-list message.

## Getting started

Requirements: Flutter / Dart SDK `^3.11.4`.

```bash
flutter pub get
flutter run
```

To build a release binary:

```bash
flutter build apk        # Android
flutter build ios        # iOS (requires Xcode signing)
```

> Remote images require an internet connection at runtime.

## Configuration

| What to change      | Where                                                    |
| ------------------- | -------------------------------------------------------- |
| Sample products     | `ProductDummyData.products` in `product_dummy_data.dart` |
| Items per page      | `ProductRepository.pageSize`                             |
| Simulated latency   | `ProductRepository._latency`                             |
