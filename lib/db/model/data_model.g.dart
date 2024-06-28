// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class datamodelsAdapter extends TypeAdapter<datamodels> {
  @override
  final int typeId = 1;

  @override
  datamodels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return datamodels(
      username: fields[0] as String?,
      email: fields[1] as String?,
      password: fields[2] as String?,
      image: fields[3] as String?,
      id: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, datamodels obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is datamodelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class itemsmodelAdapter extends TypeAdapter<itemsmodel> {
  @override
  final int typeId = 2;

  @override
  itemsmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return itemsmodel(
      items: fields[1] as String,
      itemcount: fields[2] as String,
      image: fields[3] as String?,
      id1: fields[0] as int?,
      categoryid: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, itemsmodel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id1)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.itemcount)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.categoryid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is itemsmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class productmodelAdapter extends TypeAdapter<productmodel> {
  @override
  final int typeId = 3;

  @override
  productmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return productmodel(
      itemname1: fields[0] as String,
      discription1: fields[1] as String?,
      stock1: fields[6] as String?,
      image: fields[2] as String?,
      totalproducts: fields[9] as int?,
      id2: fields[3] as int?,
      categoryid: fields[4] as int?,
      productid: fields[5] as int?,
      currentprice: fields[7] as String?,
      sellingprice: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, productmodel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.itemname1)
      ..writeByte(1)
      ..write(obj.discription1)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.id2)
      ..writeByte(4)
      ..write(obj.categoryid)
      ..writeByte(5)
      ..write(obj.productid)
      ..writeByte(6)
      ..write(obj.stock1)
      ..writeByte(7)
      ..write(obj.currentprice)
      ..writeByte(8)
      ..write(obj.sellingprice)
      ..writeByte(9)
      ..write(obj.totalproducts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is productmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class salesmodelAdapter extends TypeAdapter<salesmodel> {
  @override
  final int typeId = 4;

  @override
  salesmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return salesmodel(
      customername: fields[0] as String?,
      date: fields[1] as String?,
      category: fields[2] as String?,
      product: fields[3] as String?,
      quantity: fields[4] as String?,
      discount: fields[5] as String?,
      id3: fields[6] as int?,
      productid: fields[7] as int?,
      sellingprice: fields[9] as double?,
      salesprice: fields[10] as String?,
    )..salesid = fields[8] as int?;
  }

  @override
  void write(BinaryWriter writer, salesmodel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.customername)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.product)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.id3)
      ..writeByte(7)
      ..write(obj.productid)
      ..writeByte(8)
      ..write(obj.salesid)
      ..writeByte(9)
      ..write(obj.sellingprice)
      ..writeByte(10)
      ..write(obj.salesprice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is salesmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class dailyupdatesmodelAdapter extends TypeAdapter<dailyupdatesmodel> {
  @override
  final int typeId = 5;

  @override
  dailyupdatesmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return dailyupdatesmodel(
      date: fields[0] as String?,
      expense: fields[2] as String?,
      income: fields[1] as String?,
      selectedcategory: fields[3] as String?,
      selectedproduct: fields[4] as String?,
      id5: fields[5] as int?,
      dailyupdatesid: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, dailyupdatesmodel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.income)
      ..writeByte(2)
      ..write(obj.expense)
      ..writeByte(3)
      ..write(obj.selectedcategory)
      ..writeByte(4)
      ..write(obj.selectedproduct)
      ..writeByte(5)
      ..write(obj.id5)
      ..writeByte(6)
      ..write(obj.dailyupdatesid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is dailyupdatesmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class productreturnmodelAdapter extends TypeAdapter<productreturnmodel> {
  @override
  final int typeId = 6;

  @override
  productreturnmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return productreturnmodel(
      returnproducts: fields[0] as String?,
      damagedproducts: fields[1] as String?,
      totalproducts: fields[3] as String?,
      totalstock: fields[4] as String?,
      id6: fields[2] as int?,
      totaldamagedproducts: fields[6] as String?,
      totalreturnproducts: fields[5] as String?,
      stockouts: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, productreturnmodel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.returnproducts)
      ..writeByte(1)
      ..write(obj.damagedproducts)
      ..writeByte(2)
      ..write(obj.id6)
      ..writeByte(3)
      ..write(obj.totalproducts)
      ..writeByte(4)
      ..write(obj.totalstock)
      ..writeByte(5)
      ..write(obj.totalreturnproducts)
      ..writeByte(6)
      ..write(obj.totaldamagedproducts)
      ..writeByte(7)
      ..write(obj.stockouts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is productreturnmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 7;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      customername: fields[0] as String,
      date: fields[1] as String,
      totalamount: fields[2] as double,
      discount: fields[3] as double,
      invoice: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      id7: fields[5] as int?,
      invoiceid: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.customername)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalamount)
      ..writeByte(3)
      ..write(obj.discount)
      ..writeByte(4)
      ..write(obj.invoice)
      ..writeByte(5)
      ..write(obj.id7)
      ..writeByte(6)
      ..write(obj.invoiceid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
