import 'dart:io';

import 'package:basic_ecommerce/custom_widgets/custom_progress_dialog.dart';
import 'package:basic_ecommerce/model/product_model.dart';
import 'package:basic_ecommerce/providers/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/helper_functions.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = 'product_details_page';

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider _productProvider;
  String? _productId;
  String? _productName;
  bool _isUploading = false;
  ImageSource _imageSource = ImageSource.camera;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _productId = argList[0];
    _productName = argList[1];
    _productProvider.getAllPurchasesByProductId(_productId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productName!),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _productProvider.getProductByProductId(_productId!),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              print(product.productImageUrl);
              return Stack(
                children: [
                  ListView(
                    children: [
                      FadeInImage.assetNetwork(
                          image: product.productImageUrl!,
                          placeholder: 'images/imagenotavailable.png',
                          fadeInDuration: const Duration(seconds: 3),
                          width: double.minPositive,
                          height: 200, fit: BoxFit.cover),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: (){
                              _imageSource = ImageSource.camera;
                              _getImage();
                            },
                            label: const Text('Capture'),
                            icon: const Icon(Icons.camera),
                          ),
                          TextButton.icon(
                            onPressed: (){
                              _imageSource= ImageSource.gallery;
                              _getImage();
                            },
                            label: const Text('Gallery'),
                            icon: const Icon(Icons.photo_album),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sale Price'),
                            Text('BDT ${product.salePrice}', style: TextStyle(fontSize: 20),),
                            TextButton(onPressed: (){}, child: Text('Update'))
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Purchase History', style: TextStyle(fontSize: 15),),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _productProvider.purchaseListOfSpecificProduct.map((e) => ListTile(
                            title: Text(getFormattedDate(e.purchaseTimesStamp!.millisecondsSinceEpoch, 'dd/MM/yyy',)),
                            trailing: Text('BDT ${e.purchasePrice}', style: const TextStyle(fontSize: 14),),
                            leading: CircleAvatar(
                              child: Text('${e.purchaseQuantity}')
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                  if(_isUploading)CustomProgressDialog('Please Wait')
                ],
              );
            }
            if(snapshot.hasError){
              return const Text('Failed To Fetch Data');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _getImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 75);
    if (imageFile != null) {
      setState(() {
        _isUploading = true;
      });
      _productProvider.uploadImage(
          File(imageFile.path),
          _productId!,
          _productName!).then((value) {
        setState(() {
          _isUploading = false;
        });
      }).catchError((error) {
        setState(() {
          _isUploading = false;
        });
      });
    }
  }
}
