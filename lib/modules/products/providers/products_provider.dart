import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/products/data/products_api.dart';
import 'package:food_tracker/modules/products/data/product_models.dart';

final productsApiProvider = Provider<ProductsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductsApi(dio);
});

sealed class ScannerState {}

class ScannerIdle extends ScannerState {}

class ScannerLoading extends ScannerState {}

class ScannerFound extends ScannerState {
  final ProductModel product;
  ScannerFound(this.product);
}

class ScannerNotFound extends ScannerState {}

class ScannerError extends ScannerState {
  final String message;
  ScannerError(this.message);
}

class ScannerNotifier extends Notifier<ScannerState> {
  @override
  ScannerState build() => ScannerIdle();

  Future<void> scan(String barcode) async {
    if (state is ScannerLoading) return;

    state = ScannerLoading();

    try {
      final api = ref.read(productsApiProvider);
      final product = await api.getByBarcode(barcode);

      if (product == null) {
        state = ScannerNotFound();
      } else {
        state = ScannerFound(product);
      }
    } catch (e) {
      state = ScannerError(e.toString());
    }
  }

  void reset() => state = ScannerIdle();
}

final scannerProvider = NotifierProvider<ScannerNotifier, ScannerState>(
  ScannerNotifier.new,
);
