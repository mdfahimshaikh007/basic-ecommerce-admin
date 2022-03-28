import 'package:basic_ecommerce/model/product_model.dart';
import 'package:basic_ecommerce/model/purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {
  static const _collectionProduct = 'Products';
  static const _collectionCategories = 'Categories';
  static const _collectionPurchase = 'Purchase';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addNewProduct(ProductModel productModel, PurchaseModel purchaseModel) {
    final writeBatch = _db.batch();

    final productDoc = _db.collection(_collectionProduct).doc();
    final purchaseDoc = _db.collection(_collectionPurchase).doc();
    productModel.id = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    purchaseModel.productId = productDoc.id;

    writeBatch.set(productDoc, productModel.toMap());
    writeBatch.set(purchaseDoc, purchaseModel.toMap());

    return writeBatch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllCategories() =>
      _db.collection(_collectionCategories).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProducts() =>
      _db.collection(_collectionProduct).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchProductByProductId(String productId) =>
      _db.collection(_collectionProduct).doc(productId).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllPurchases() =>
      _db.collection(_collectionPurchase).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchPurchaseByProductId(String productId) =>
      _db.collection(_collectionPurchase).where('product id', isEqualTo: productId).snapshots();

  static Future<void> updateImageUrl(String url, String productId){
    final doc = _db.collection(_collectionProduct).doc(productId);
    return doc.update({'productImage': url});
  }
}