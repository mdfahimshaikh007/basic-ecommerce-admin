import 'package:basic_ecommerce/db/db_helper.dart';
import 'package:basic_ecommerce/model/product_model.dart';
import 'package:basic_ecommerce/model/purchase_model.dart';
import 'package:basic_ecommerce/providers/product_provider.dart';
import 'package:basic_ecommerce/utils/constant.dart';
import 'package:basic_ecommerce/utils/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = 'new_product_page';

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider _productProvider;

  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  String? category;
  DateTime? purchaseDate;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _saveProduct, icon: Icon(Icons.done))],
        title: const Text('New Prduct'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Product Name'
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return emptyFieldErrorMsg;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _purchasePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Purchase Price'
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return emptyFieldErrorMsg;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Sale Price'
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return emptyFieldErrorMsg;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: 'Product Description'
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return emptyFieldErrorMsg;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                  hintText: 'Product Quantity'
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return emptyFieldErrorMsg;
                }
              },
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child:                     DropdownButtonFormField<String>(
                  hint: Text('Select Category'),
                  value: category,
                  onChanged: (value){
                    setState(() {
                      category = value;
                    });
                  },
                  items: _productProvider.categoryList.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return emptyFieldErrorMsg;
                    }
                  },
                )
              ),
              ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: _showDatePickerDialog,
                        child: Text('Select Purchase Date'),
                    ),
                     Text(purchaseDate == null ? 'No Date Choosen': DateFormat('dd/MM/yyyy').format(purchaseDate!)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDatePickerDialog() async{
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if(selectedDate != null){
      setState(() {
        purchaseDate = selectedDate;
      });
    }
  }

  void _saveProduct() {
    if(_formkey.currentState!.validate()){
      final productModel = ProductModel(
        name: _nameController.text,
        salePrice: num.parse(_salePriceController.text),
        description: _descriptionController.text,
        category: category,
      );
      final purchaseModel = PurchaseModel(
          year: purchaseDate!.year,
          month: purchaseDate!.month,
          day: purchaseDate!.day,
          purchaseTimesStamp: Timestamp.fromDate(purchaseDate!),
          purchasePrice: num.parse(_purchasePriceController.text),
          purchaseQuantity: num.parse(_quantityController.text)
      );

      Provider.of<ProductProvider>(context, listen: false).saveProduct(productModel, purchaseModel)
          .then((value) {
        setState(() {
          _nameController.text = '';
          _purchasePriceController.text = '';
          _salePriceController.text = '';
          _descriptionController.text = '';
          _quantityController.text = '';
          category = null;
          purchaseDate = null;
        });
        showMsg(context, 'Saved');
      })
          .catchError((error){

      });
    }
  }
}
