import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myproject1/screens/account/addcontent.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/account/dailyupdates.dart';
import 'package:myproject1/screens/account/editprofile.dart';
import 'package:myproject1/screens/account/privacypolicy.dart';
import 'package:myproject1/screens/mainfiles/login.dart';


class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Account> {
  
 
  @override
  Widget build(BuildContext context) {
   
    geteditlist();
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(80), child: AppBar(
         
           backgroundColor: const Color.fromARGB(255, 108, 110, 208),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                ValueListenableBuilder<List<datamodels>>(
                  valueListenable: editlistnotifier,
                  builder: (BuildContext ctx, List<datamodels> editlist,
                      Widget? child) {
                    if (editlist.isEmpty) {
                  
                      return const LinearProgressIndicator(); 
                    }
                  
                    datamodels data = editlist.last;
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor:
                              const Color.fromARGB(255, 138, 26, 26),
                          backgroundImage:
                              (data.image != null && data.image!.isNotEmpty)
                                  ? FileImage(File(data.image!))
                                  : null,
                          child: (data.image == null || data.image!.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.username!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                        Text(
                          data.email!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 200,
                          child: InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                     
                   
                    
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Editprofile(
                                              data: data,
                                            )));
                        
                       },
                 child: Container(
                padding: const EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                    gradient: const LinearGradient( begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                      colors: [
                       Color.fromARGB(255, 18, 25, 223),
                       Color.fromARGB(255, 109, 3, 127)
                    ]),
                  
                     borderRadius: BorderRadius.circular(8.0),
                     ),
                   child: const Center(
                     child: Text(
                                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                                    ),
                   ),
                         ),
                        ),
                          
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text('Content')),
                        const SizedBox(
                          height: 10,
                        ),
                       
                        const SizedBox(
                          height: 20,
                        ),
                            GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DailyUpdates()));
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blueAccent.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.store,
                                color: Colors.blueAccent,
                              ),
                            ),
                            title: const Text(
                              'Daily Updates',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                          ),
                        ),
                      const  SizedBox(height: 10,),
                        GestureDetector(
                           onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicy()));
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blueAccent.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.security,
                                color: Colors.blueAccent,
                              ),
                            ),
                            title: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addingpage()));
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blueAccent.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.category,
                                color: Colors.blueAccent,
                              ),
                            ),
                            title: const Text(
                              'Add New Category',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            popp(context);
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blueAccent.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.blueAccent,
                              ),
                            ),
                            title: const Text(
                              'Log Out',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signout(BuildContext ctx) async {
    // ignore: use_build_context_synchronously
    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => loginpage()), (route) => false);
  }

  void popp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 73, 79, 199),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          content: const Text('You want to Signout from this account'),
          actions: [
            TextButton(
              onPressed: () {
                signout(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('no'),
            ),
          ],
        );
      },
    ).then((_) {
    
      if (mounted) {
        setState(() {});
      }
    });
  }
}
