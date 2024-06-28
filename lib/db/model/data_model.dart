import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class datamodels {
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? password;
  @HiveField(3)
  String? image;
  @HiveField(4)
  int? id;

  datamodels(
      {required this.username,
      required this.email,
      required this.password,
      this.image,
      this.id});
}

@HiveType(typeId: 2)
class itemsmodel {
  @HiveField(0)
  int? id1;
  @HiveField(1)
  String items;
  @HiveField(2)
  String itemcount;
  @HiveField(3)
  String? image;
  @HiveField(4)
  int? categoryid;

  itemsmodel(
      {required this.items,
      required this.itemcount,
      this.image,
      this.id1,
      this.categoryid});
}

@HiveType(typeId: 3)
class productmodel {
  @HiveField(0)
  String itemname1;
  @HiveField(1)
  String? discription1;
  @HiveField(2)
  String? image;
  @HiveField(3)
  int? id2;
  @HiveField(4)
  int? categoryid;
  @HiveField(5)
  int? productid;

  @HiveField(6)
  String? stock1;

  @HiveField(7)
  String? currentprice;

  @HiveField(8)
  String? sellingprice;

  @HiveField(9)
  int? totalproducts;

  productmodel(
      {required this.itemname1,
      this.discription1,
      required this.stock1,
      this.image,
      this.totalproducts,
      this.id2,
      this.categoryid,
      this.productid,
      required this.currentprice,
      required this.sellingprice});
}

@HiveType(typeId: 4)
class salesmodel {
  @HiveField(0)
  String? customername;
  @HiveField(1)
  String? date;
  @HiveField(2)
  String? category;
  @HiveField(3)
  String? product;
  @HiveField(4)
  String? quantity;
  @HiveField(5)
  String? discount;
  @HiveField(6)
  int? id3;
  @HiveField(7)
  int? productid;
  @HiveField(8)
  int? salesid;
  @HiveField(9)
  double? sellingprice;
  @HiveField(10)
  String? salesprice;

  salesmodel(
      {required this.customername,
      this.date,
      this.category,
      this.product,
      this.quantity,
      this.discount,
      this.id3,
      this.productid,
      this.sellingprice,
      this.salesprice});
}

@HiveType(typeId: 5)
class dailyupdatesmodel {
  @HiveField(0)
  String? date;
  @HiveField(1)
  String? income;
  @HiveField(2)
  String? expense;
  @HiveField(3)
  String? selectedcategory;
  @HiveField(4)
  String? selectedproduct;
  @HiveField(5)
  int? id5;
  @HiveField(6)
  int? dailyupdatesid;
  dailyupdatesmodel(
      {required this.date,
      required this.expense,
      required this.income,
      required this.selectedcategory,
      required this.selectedproduct,
      this.id5,
      this.dailyupdatesid});
}

@HiveType(typeId: 6)
class productreturnmodel {
  @HiveField(0)
  String? returnproducts;
  @HiveField(1)
  String? damagedproducts;
  @HiveField(2)
  int? id6;
  @HiveField(3)
  String? totalproducts;
  @HiveField(4)
  String? totalstock;
  @HiveField(5)
  String? totalreturnproducts;
  @HiveField(6)
  String? totaldamagedproducts;
  @HiveField(7)
  int? stockouts;
  productreturnmodel(
      {required this.returnproducts,
      required this.damagedproducts,
      required this.totalproducts,
      required this.totalstock,
      this.id6,
      required this.totaldamagedproducts,
      required this.totalreturnproducts,
      required this.stockouts});
}
@HiveType(typeId: 7)
class InvoiceModel {
  @HiveField(0)
  final String customername;
  
  @HiveField(1)
  final String date;
  
  @HiveField(2)
  final double totalamount;
  
  @HiveField(3)
  double discount;
  
  @HiveField(4)
  final List<Map<String, dynamic>> invoice;
  
  @HiveField(5)
   int? id7;
  
  @HiveField(6)
   int? invoiceid;

  InvoiceModel({
    required this.customername,
    required this.date,
    required this.totalamount,
    required this.discount,
    required this.invoice,
    this.id7,
    this.invoiceid,
  });
}