import 'package:flutter/material.dart';
import '/financialManagement/ledger_page.dart';  // Make sure this path is correct
import '/Login_SignUp.dart';
import '/screens/task_list_page.dart';
import '/screens/navigation.dart';
import '/cropmanagement/farm_records.dart';
import 'otp_verification_screen.dart';
import 'otp_request_screen.dart';


import '/chats/chats.dart';


void main() {
  runApp(const MyApp());  // Using const constructor for MyApp
}

class MyApp extends StatelessWidget {  // Use StatelessWidget as there is no mutable state
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Hide the debug banner
      initialRoute: '/login',  // Starting route
      routes: {
        '/ledger': (context) => LedgerPage(),  // Make LedgerPage const for better performance
        '/task_list_page':(contex)=>TaskReminderApp(),
        '/farm_records':(contex)=>CropLivestockScreen(),
        '/chats':(contex)=>Chats(myUserId: '5'),
        '/login':(context)=>LoginPage(),
        '/crop':(context)=>FarmRecordsScreen(),
        '/home':(context)=>HomePage(),
        
        
      },
      onUnknownRoute: (settings) {
        // Handle unknown routes with a fallback screen
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Page not found'))));
      },
    );
  }
}
