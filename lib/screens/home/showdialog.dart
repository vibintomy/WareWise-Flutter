import 'package:flutter/material.dart';
import 'package:myproject1/db/model/data_model.dart';

class ShowDialogBox extends StatefulWidget {
  final List<itemsmodel> itemsList;
  final List<productmodel> productsList;
  final itemsmodel? selectedCategory;
  final productmodel? selectedProduct;
  final double price;
  final int quantity;

  const ShowDialogBox({
    Key? key,
    required this.itemsList,
    required this.productsList,
    this.selectedCategory,
    this.selectedProduct,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  _ShowDialogBoxState createState() => _ShowDialogBoxState();
}

class _ShowDialogBoxState extends State<ShowDialogBox> {
  itemsmodel? selectedCategoryDialog;
  productmodel? selectedProductDialog;
  List<productmodel> productsListDialog = [];
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedCategoryDialog = widget.selectedCategory;
    selectedProductDialog = widget.selectedProduct;
    if (selectedCategoryDialog != null) {
      productsListDialog = widget.productsList
          .where((product) =>
              product.categoryid == selectedCategoryDialog!.categoryid)
          .toList();
    } else {
      productsListDialog = widget.productsList;
    }
    quantityController.text = widget.quantity.toString();
    _updatePrice();
  }

  void _updatePrice() {
    if (selectedProductDialog != null) {
      final quantity = int.tryParse(quantityController.text) ?? 0;
      final sellingPrice =
          double.tryParse(selectedProductDialog!.sellingprice.toString()) ??
              0.0;
      final price = quantity * sellingPrice;
      priceController.text = price.toStringAsFixed(2);
    }
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter the quantity';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Enter a valid quantity';
    }
    if (selectedProductDialog != null) {
      final availableStock = int.tryParse(selectedProductDialog!.stock1.toString()) ?? 0;
      if (quantity > availableStock) {
        return 'Quantity exceeds available stock';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: AlertDialog(
          title: const Text('Invoice Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<itemsmodel>(
                  value: selectedCategoryDialog,
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                    border: const OutlineInputBorder(),
                  ),
                  items: widget.itemsList.map((itemsmodel item) {
                    return DropdownMenuItem<itemsmodel>(
                      value: item,
                      child: Text(item.items),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategoryDialog = newValue;
                      selectedProductDialog = null;
                      productsListDialog = widget.productsList
                          .where((product) =>
                              product.categoryid == newValue!.categoryid)
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<productmodel>(
                  value: selectedProductDialog,
                  decoration: const InputDecoration(
                    labelText: 'Select Product',
                    border: OutlineInputBorder(),
                  ),
                  items: productsListDialog.map((productmodel product) {
                    return DropdownMenuItem<productmodel>(
                      value: product,
                      child: Text(product.itemname1),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedProductDialog = newValue;
                      _updatePrice();
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: quantityController,
                  validator: _validateQuantity,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _updatePrice();
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: false,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'category': selectedCategoryDialog?.items ?? '',
                    'product': selectedProductDialog?.itemname1 ?? '',
                    'quantity': int.tryParse(quantityController.text) ?? 0,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
