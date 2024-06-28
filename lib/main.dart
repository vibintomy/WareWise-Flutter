import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myproject1/db/model/data_model.dart';

import 'package:myproject1/screens/mainfiles/splash.dart';

const SAVE_KEY_NAME = 'UserLoggedIn';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(datamodelsAdapter().typeId)) {
    Hive.registerAdapter(datamodelsAdapter());
  }
  if (!Hive.isAdapterRegistered(itemsmodelAdapter().typeId)) {
    Hive.registerAdapter(itemsmodelAdapter());
  }

  if (!Hive.isAdapterRegistered(productmodelAdapter().typeId)) {
    Hive.registerAdapter(productmodelAdapter());
  }
  if (!Hive.isAdapterRegistered(salesmodelAdapter().typeId)) {
    Hive.registerAdapter(salesmodelAdapter());
  }
  if (!Hive.isAdapterRegistered(dailyupdatesmodelAdapter().typeId)) {
    Hive.registerAdapter(dailyupdatesmodelAdapter());
  }
  if (!Hive.isAdapterRegistered(productreturnmodelAdapter().typeId)) {
    Hive.registerAdapter(productreturnmodelAdapter());
  }
  if (!Hive.isAdapterRegistered(InvoiceModelAdapter().typeId)) {
    Hive.registerAdapter(InvoiceModelAdapter());
  }
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
