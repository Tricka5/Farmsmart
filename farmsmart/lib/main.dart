import 'package:flutter/material.dart';
import '/financialManagement/ledger_page.dart'; // Make sure this path is correct
import 'user_verification/Login_SignUp.dart';
import '/cropmanagement/farm_records.dart';
import 'user_verification/email_input.dart';
import '/chats/chats.dart';


import 'home/home.dart';
import 'home/landingpage.dart';
import 'home/navigation.dart';
import 'home/tasklistpage.dart';
import 'home/usernote.dart';


void main() {
  runApp(const MyApp()); // Using const constructor for MyApp
}

class MyApp extends StatelessWidget {
  // Use StatelessWidget as there is no mutable state
  const MyApp({super.key});

  final email='';
  final dynamic myid = '29';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      initialRoute: '/landingpage', // Starting route
      routes: {
        '/ledger': (context) =>
            LedgerPage(), // Make LedgerPage const for better performance
        '/task_list_page': (contex) => TaskReminderApp(),
        '/chats': (contex) => Chats(myUserId: myid),
        '/login': (context) => LoginPage(),
        '/crop': (context) => FarmRecordsScreen(),
        '/home': (context) => HomePage(),
        '/requestpassword': (context) => EnterEmailScreen(),
        '/note': (context) => FarmSmartHomePage(),
        '/landingpage': (context) => FarmSmartPage(),
      },
      onUnknownRoute: (settings) {
        // Handle unknown routes with a fallback screen
        return MaterialPageRoute(
            builder: (context) =>
                const Scaffold(body: Center(child: Text('Page not found'))));
      },
    );
  }
}
