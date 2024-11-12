import 'package:flutter/material.dart';
import 'package:bluechat/financialManagement/ledger_page.dart';  // Make sure this path is correct

void main() {
  runApp(const MyApp());  // Using const constructor for MyApp
}

class MyApp extends StatelessWidget {  // Use StatelessWidget as there is no mutable state
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Hide the debug banner
      initialRoute: '/',  // Starting route
      routes: {
        '/': (context) => LedgerPage(),  // Make LedgerPage const for better performance
      },
      onUnknownRoute: (settings) {
        // Handle unknown routes with a fallback screen
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Page not found'))));
      },
    );
  }
}
