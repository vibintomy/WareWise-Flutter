import 'package:flutter/material.dart';
import 'package:myproject1/screens/home/invoice.dart';
import 'package:myproject1/screens/home/notification.dart';

class tabBarPage extends StatelessWidget {
  const tabBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('#Invoice',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 108, 110, 208),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Sales Invoice'),
                Tab(text: 'Return Products'),
                
              ],
              indicatorColor: Colors.red,
              labelStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
             
            ),
          ),
          body: TabBarView(
            children: [
              const SalesInvoice(),
              NotificationScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
