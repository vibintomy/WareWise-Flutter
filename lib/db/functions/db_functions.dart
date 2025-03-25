// ignore_for_file: unnecessary_null_comparison, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myproject1/db/model/data_model.dart';

ValueNotifier<List<datamodels>> editlistnotifier = ValueNotifier([]);

Future<void> addprofile(datamodels value) async {
  final editdb = await Hive.openBox<datamodels>('edit_db');

  final id = editlistnotifier.value.length;
  value.id = id;

  final addedid = await editdb.add(value);

  if (addedid != null) {
    editlistnotifier.value = List<datamodels>.from(editlistnotifier.value)
      ..add(value);
    editlistnotifier.notifyListeners();
  }
}

Future<void> geteditlist() async {
  final editdb = await Hive.openBox<datamodels>('edit_db');
  editlistnotifier.value = List<datamodels>.from(editdb.values);
  editlistnotifier.notifyListeners();
}

Future<void> editdetails(int id, datamodels updatedData) async {
  try {
    final allDB2 = await Hive.openBox<datamodels>('edit_db');
    final existingData = allDB2.get(id);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.username = updatedData.username;
      existingData.email = updatedData.email;
      existingData.image = updatedData.image;

      await allDB2.put(id, existingData);

      // Update dataListNotifier2 after editing
      int index = editlistnotifier.value.indexWhere((data) => data.id == id);
      if (index != -1) {
        editlistnotifier.value[index] = existingData;
        editlistnotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

// second values to store in the database

class Id {
  static int _count = 0; // Change variable name to make it clearer
  static int generateId() {
    return _count++;
  }
}

ValueNotifier<List<itemsmodel>> itemlistNotifier =
    ValueNotifier([]); // Rename to follow Dart naming conventions
Future<void> addContent(itemsmodel value) async {
  try {
    final itemBox = await Hive.openBox<itemsmodel>('items_db');
    int id = Id.generateId();
    value.id1 = id;
    final categoryid = DateTime.now().microsecondsSinceEpoch;
    value.categoryid = categoryid;
    await itemBox.put(
        id, value); // Use put method to store data with specified key
    itemlistNotifier.value = List<itemsmodel>.from(itemlistNotifier.value)
      ..add(value); // Update notifier value
    await itemBox.close(); // Close the box to persist changes
  } catch (e) {
    print('Error adding content: $e');
  }
}

Future<List<itemsmodel>> getItemList() async {
  try {
    final itemBox = await Hive.openBox<itemsmodel>('items_db');
    List<itemsmodel> itemsList =
        itemBox.values.toList(); // Retrieve all values from the box
    await itemBox.close(); // Close the box after reading data
    return itemsList;
  } catch (e) {
    print('Error fetching data: $e');
    return []; // Return empty list in case of error
  }
}

Future<void> deleteCategory(int id) async {
  try {
    final itemBox = await Hive.openBox<itemsmodel>('items_db');
    await itemBox.delete(id); // Delete the category from the database
    itemlistNotifier.value = itemlistNotifier.value
        .where((item) => item.id1 != id)
        .toList(); // Remove the category from the notifier
  } catch (e) {
    print('Error deleting category: $e');
  }
}

Future<void> editdetails2(int id, itemsmodel updatedData) async {
  try {
    final allDB3 = await Hive.openBox<itemsmodel>('items_db');
    final existingData = allDB3.get(id);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.items = updatedData.items;
      existingData.itemcount = updatedData.itemcount;
      existingData.image = updatedData.image;

      await allDB3.put(id, existingData);

      // Update dataListNotifier2 after editing
      int index = editlistnotifier.value.indexWhere((item) => item.id == id);
      if (index != -1) {
        itemlistNotifier.value[index] = existingData;
        itemlistNotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

ValueNotifier<List<productmodel>> productListNotifier =
    ValueNotifier([]); // Rename to follow Dart naming conventions

Future<void> addproduct(productmodel value, int categoryid) async {
  try {
    final productBox = await Hive.openBox<productmodel>('product_db');
    int id = Id.generateId();
    value.id2 = id;
    value.categoryid = categoryid;
    value.productid = DateTime.now().millisecondsSinceEpoch;
    await productBox.put(
        id, value); // Use put method to store data with specified key
    productListNotifier.value =
        List<productmodel>.from(productListNotifier.value)
          ..add(value); // Update notifier value
    await productBox.close(); // Close the box to persist changes
  } catch (e) {
    print('Error adding content: $e');
  }
}

Future<List<productmodel>> getproductList() async {
  try {
    final productBox = await Hive.openBox<productmodel>('product_db');
    List<productmodel> products =
        productBox.values.toList(); // Retrieve all values from the box
    await productBox.close(); // Close the box after reading data
    return products;
  } catch (e) {
    print('Error fetching data: $e');
    return []; // Return empty list in case of error
  }
}

Future<void> deleteproduct(int id) async {
  try {
    final productBox = await Hive.openBox<productmodel>('product_db');
    await productBox.delete(id); // Delete the category from the database
    productListNotifier.value = productListNotifier.value
        .where((item) => item.id2 != id)
        .toList(); // Remove the category from the notifier
  } catch (e) {
    print('Error deleting product: $e');
  }
}

Future<void> editdetails4(int id, productmodel updatedData) async {
  try {
    final allDB5 = await Hive.openBox<productmodel>('product_db');
    final existingData = allDB5.get(id);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.stock1 = updatedData.stock1;
      existingData.itemname1 = updatedData.itemname1;
      existingData.image = updatedData.image;
      existingData.currentprice = updatedData.currentprice;
      existingData.discription1 = updatedData.discription1;
      existingData.sellingprice = updatedData.sellingprice;

      await allDB5.put(id, existingData);

      // Update dataListNotifier2 after editing
      int index =
          productListNotifier.value.indexWhere((item) => item.id2 == id);
      if (index != -1) {
        productListNotifier.value[index] = existingData;
        productListNotifier.notifyListeners();
      } else {
        print('Index not found in productListNotifier');
      }
    } else {
      print('Existing data is null');
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

// sales report

ValueNotifier<List<salesmodel>> salesListNotifier = ValueNotifier([]);

Future<void> addsales(salesmodel value, int productid) async {
  try {
    final salesBox = await Hive.openBox<salesmodel>('sales_db');
    int id = Id.generateId();
    value.id3 = id;
    value.productid = productid;
    value.salesid = DateTime.now().millisecondsSinceEpoch;
    await salesBox.put(id, value);
    salesListNotifier.value = List<salesmodel>.from(salesListNotifier.value)
      ..add(value);
    await salesBox.close();
  } catch (e) {
    print('Error adding content: $e');
  }
}

Future<List<salesmodel>> getsalesList() async {
  try {
    final salesBox = await Hive.openBox<salesmodel>('sales_db');
    List<salesmodel> sales =
        salesBox.values.toList(); // Retrieve all values from the box
    await salesBox.close(); // Close the box after reading data
    return sales;
  } catch (e) {
    print('Error fetching data: $e');
    return []; // Return empty list in case of error
  }
}

Future<void> deletesales(int id) async {
  try {
    final salesBox = await Hive.openBox<salesmodel>('sales_db');
    await salesBox.delete(id);
    salesListNotifier.value =
        salesListNotifier.value.where((item) => item.id3 != id).toList();
  } catch (e) {
    print('Error deleting product: $e');
  }
}

// dailyupdates

ValueNotifier<List<dailyupdatesmodel>> dailyupdatesNotifier = ValueNotifier([]);

Future<void> addDailyupdates(dailyupdatesmodel value) async {
  final dUpdates = await Hive.openBox<dailyupdatesmodel>('dailyupdates_db');

  final id = editlistnotifier.value.length;
  value.id5 = id;

  final addedid = await dUpdates.add(value);

  if (addedid != null) {
    dailyupdatesNotifier.value =
        List<dailyupdatesmodel>.from(dailyupdatesNotifier.value)..add(value);
    dailyupdatesNotifier.notifyListeners();
  }
}

Future<List<dailyupdatesmodel>> getDailyupdates() async {
  try {
    final dUpdates = await Hive.openBox<dailyupdatesmodel>('dailyupdates_db');
    List<dailyupdatesmodel> dailyupdates = dUpdates.values.toList();
    await dUpdates.close();
    return dailyupdates;
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

ValueNotifier<List<productreturnmodel>> productReturnNotifier =
    ValueNotifier([]);

Future<void> addproductreturns(productreturnmodel value) async {
  final PRmodel = await Hive.openBox<productreturnmodel>('productReturn_db');

  final id = productReturnNotifier.value.length;
  value.id6 = id;

  final addedid = await PRmodel.add(value);

  if (addedid != null) {
    productReturnNotifier.value =
        List<productreturnmodel>.from(productReturnNotifier.value)..add(value);
    productReturnNotifier.notifyListeners();
  }
}

Future<List<productreturnmodel>> getproductreturns() async {
  try {
    final PRmodel = await Hive.openBox<productreturnmodel>('productReturn_db');
    List<productreturnmodel> productreturns = PRmodel.values.toList();
    await PRmodel.close();
    return productreturns;
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

Future<void> deleteproductreturn(int id) async {
  try {
    final PRmodel = await Hive.openBox<productreturnmodel>('productReturn_db');
    await PRmodel.delete(id);
    productReturnNotifier.value =
        productReturnNotifier.value.where((item) => item.id6 != id).toList();
  } catch (e) {
    print('Error deleting product: $e');
  }
}

///invoice
ValueNotifier<List<InvoiceModel>> invoicenotifier = ValueNotifier([]);

Future<void> addinvoice(InvoiceModel value) async {
  try {
    final invoiceBox = await Hive.openBox<InvoiceModel>('invoice_db');
    int id = Id.generateId();
    value.id7 = id;
    value.invoiceid = DateTime.now().millisecondsSinceEpoch;
    await invoiceBox.put(id, value);
    invoicenotifier.value = List<InvoiceModel>.from(invoicenotifier.value)
      ..add(value);
    await invoiceBox.close();
  } catch (e) {
    print('Error adding content: $e');
  }
}

Future<List<InvoiceModel>> getinvoicelist() async {
  try {
    final invoiceBox = await Hive.openBox<InvoiceModel>('invoice_db');
    List<InvoiceModel> invoice = invoiceBox.values.toList();
    await invoiceBox.close();
    return invoice;
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

Future<void> deleteinvoice(int id) async {
  try {
    final invoiceBox = await Hive.openBox<InvoiceModel>('invoice_db');
    await invoiceBox.delete(id);
    invoicenotifier.value =
        invoicenotifier.value.where((item) => item.id7 != id).toList();
  } catch (e) {
    print('Error deleting product: $e');
  }
}

Future<void> purchasedProduct(int productid) async {
  try {
    final productBox = await Hive.openBox<productmodel>('product_db');
    final product = productBox.values.firstWhere((p) => p.id2 == productid);

    product.purchaseCount += 1;
    await productBox.put(product.id2, product);

    productListNotifier.value = List<productmodel>.from(productBox.values);
    await productBox.close();
  } catch (e) {
    throw 'No values found';
  }
}

Future<List<productmodel>> getTopPurchases() async {
  try {
    final productBox = await Hive.openBox<productmodel>('product_db');
    List<productmodel> products = productBox.values.toList();
    products.sort((a, b) => b.purchaseCount.compareTo(a.purchaseCount));
    await productBox.close();
    return products;
  } catch (e) {
    print('No valus found');
    return [];
  }
}
