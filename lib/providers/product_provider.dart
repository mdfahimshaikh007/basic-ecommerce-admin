
import 'dart:io';

import 'package:basic_ecommerce/db/db_helper.dart';
import 'package:basic_ecommerce/model/product_model.dart';
import 'package:basic_ecommerce/model/purchase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<String> categoryList = [];


  Future<void> saveProduct(ProductModel productModel, PurchaseModel purchaseModel){
    return DBHelper.addNewProduct(productModel, purchaseModel);
  }

  void getAllProducts(){
    DBHelper.fetchAllProducts().listen((event) {
      productList = List.generate(event.docs.length, (index) =>
      ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductByProductId(String productId){
    return DBHelper.fetchProductByProductId(productId);
  }

  void getAllPurchasesByProductId(String productId){
    DBHelper.fetchAllPurchases().listen((event) {
      purchaseListOfSpecificProduct = List.generate(event.docs.length, (index) =>
      PurchaseModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getAllPurchases(){
    DBHelper.fetchAllPurchases().listen((event) {
      purchaseList = List.generate(event.docs.length, (index) =>
          PurchaseModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getAllCategories(){
    DBHelper.fetchAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length, (index) =>
      event.docs[index].data()['name']);
      notifyListeners();
    });
  }

  Future<void> uploadImage(File imageFile, String productId, String productName) async{
    final rootRef = FirebaseStorage.instance.ref();
    final imageRef = rootRef.child('$productName/${productName}_${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = imageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {
      
    }).catchError((error){

    });

    final url = await snapshot.ref.getDownloadURL();
    updateImageUrl(url, productId);
  }

    void updateImageUrl(String url, String productId){
    DBHelper.updateImageUrl(url, productId);
  }
}