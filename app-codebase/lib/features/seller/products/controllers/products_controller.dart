import 'package:get/get.dart';
import '../models/product_model.dart';

class SellerProductsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<SellerProductModel> productsList = <SellerProductModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    productsList.assignAll([
      SellerProductModel(
        id: '1',
        name: 'Premium Watch',
        category: 'Accessories',
        price: 299.0,
        stock: 15,
        image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200',
        description: 'Premium luxury wristwatch for everyday style and elegance.',
      ),
      SellerProductModel(
        id: '2',
        name: 'Leather Bag',
        category: 'Fashion',
        price: 159.0,
        stock: 8,
        image: 'https://images.unsplash.com/photo-1491637639811-60a2156d12a9?q=80&w=200',
        description: 'Authentic stylish leather bag with spacious compartments.',
      ),
      SellerProductModel(
        id: '3',
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: 199.0,
        stock: 0, // Out of stock as shown in screenshot
        image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
        description: 'High fidelity sound wireless Bluetooth headphones.',
      ),
      SellerProductModel(
        id: '4',
        name: 'Smart Fitness Band',
        category: 'Electronics',
        price: 89.0,
        stock: 24,
        image: 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?q=80&w=200',
        description: 'Sleek smart band with heart rate and sleep tracking.',
      ),
    ]);
  }

  // Filter products by search query
  List<SellerProductModel> get filteredProducts {
    if (searchQuery.value.trim().isEmpty) {
      return productsList;
    }
    return productsList
        .where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            p.category.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  bool addProduct(SellerProductModel product) {
    productsList.insert(0, product);
    return true;
  }

  bool updateProduct(SellerProductModel updated) {
    final index = productsList.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      productsList[index] = updated;
      return true;
    }
    return false;
  }

  bool deleteProduct(String id) {
    productsList.removeWhere((p) => p.id == id);
    return true;
  }
}
