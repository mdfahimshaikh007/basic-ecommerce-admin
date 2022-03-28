import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel{
  String? purchaseId;
  String? productId;
  Timestamp? purchaseTimesStamp;
  int year;
  int month;
  int day;
  num purchasePrice;
  num purchaseQuantity;

  PurchaseModel(
      {this.purchaseId,
      this.productId,
      this.purchaseTimesStamp,
      required this.year,
      required this.month,
      required this.day,
      this.purchasePrice = 0.0,
      this.purchaseQuantity = 1});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'purchaseId' : purchaseId,
      'productId' : productId,
      'purchaseTimesStamp' : purchaseTimesStamp,
      'purchasePrice' : purchasePrice,
      'purchaseQuantity' : purchaseQuantity,
      'year' : year,
      'month' : month,
      'day' : day,
    };
    return map;
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
    purchaseId: map['purchaseId'],
    productId: map['productId'],
    purchaseTimesStamp: map['purchaseTimesStamp'],
    purchasePrice: map['purchasePrice'],
    purchaseQuantity: map['purchaseQuantity'],
    year: map['year'],
    month: map['month'],
    day: map['day'],
  );
}