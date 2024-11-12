import 'package:flutter/material.dart';


class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {

  //test navigation

  void testNavigation(){
    Navigator.pushReplacementNamed(context, '/home_child',arguments: {
      'intiger':50,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('H0me test'),
      ),
      body: Container(
        child: TextButton(onPressed: (){
          testNavigation();
        }, child: Text('navigate')),
      ),
    );
  }
}
