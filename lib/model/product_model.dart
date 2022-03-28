class ProductModel {
  String? id;
  String? name;
  String? category;
  String? productImageUrl;
  String? description;
  num salePrice;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.productImageUrl,
      this.description,
      this.salePrice=0.0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id' : id,
      'name' : name,
      'category' : category,
      'productImage' : productImageUrl,
      'description' : description,
      'price' : salePrice,
    };
    return map;
}

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    productImageUrl: map['productImage'],
    description: map['description'],
    salePrice: map['price'],
  );

}