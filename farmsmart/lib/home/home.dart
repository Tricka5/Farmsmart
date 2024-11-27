import 'package:farmsmart/bishop/management.dart';
import 'package:farmsmart/bishop/schedule.dart';
import 'package:farmsmart/chats/contacts_screen.dart';
import 'package:farmsmart/crop_livestock/cropmana.dart';
import 'package:farmsmart/crop_livestock/livestock.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/financialManagement/ledger_page.dart'; // Replace with actual paths
import '/cropmanagement/farm_records.dart';
import '/chats/chats.dart';
import '/user_verification/Login_SignUp.dart';
import '/home/tasklistpage.dart';

void main() {
  runApp(FarmSmartApp());
}

class FarmSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FarmSmartScreen(),
    );
  }
}

class FarmSmartScreen extends StatefulWidget {
  @override
  _FarmSmartScreenState createState() => _FarmSmartScreenState();
}

class _FarmSmartScreenState extends State<FarmSmartScreen> {
  final CarouselController carouselController = CarouselController();
  int _currentSlide = 0;

  final List<String> _imagePaths = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
  ];

  // Navigation for the menu items
  void _onMenuPressed() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1.0, 80.0, 0.0, 0.0),
      items: [
        PopupMenuItem(
          child: Text('Farm Asset Management'),
          value: 'farm_asset_management',
        ),
        PopupMenuItem(
          child: Text('Crop Management'),
          value: 'crop_management',
        ),
        PopupMenuItem(
          child: Text('Livestock Management'),
          value: 'livestock_management',
        ),
        PopupMenuItem(
          child: Text('Financial Management'),
          value: 'financial_management',
        ),
        PopupMenuItem(
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
          value: 'logout',
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'farm_asset_management':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssetListPage()), // Replace with your page
            );
            break;
          case 'crop_management':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CropManagementPage()), // Replace with your page
            );
            break;
          case 'livestock_management':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LivestockManagementPage()), // Replace with your page
            );
            break;
          case 'financial_management':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LedgerPage()), // Replace with your page
            );
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      }
    });
  }

  void _handleLogout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title and Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Farm Smart",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.black),
                      onPressed: _onMenuPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Top Carousel with sliding images
          CarouselSlider.builder(
            itemCount: _imagePaths.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              );
            },
            options: CarouselOptions(
              height: 250,
              aspectRatio: 2 / 3,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSlide = index;
                });
              },
            ),
          ),
          SizedBox(height: 8),
          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imagePaths.map((path) {
              int index = _imagePaths.indexOf(path);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          // Text Bubble with droplets
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: BubblePainter(),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Welcome to Farm Smart!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Farm Smart provides you with innovative tools and insights to manage your farm "
                            "effectively. Whether it's crops, livestock, or finances, we're here to help you "
                            "grow your farming success.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 239, 237, 237),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        onTap: (index) {
          switch (index) {
            case 0:
             
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskReminderApp()), // Replace with your page
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EquipmentDetailsPage()), // Replace with your page
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: "Task Reminder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Depreciation Schedule",
          ),
        ],
      ),
    );
  }
}

// Custom painter for the green bubble with droplets
class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green.shade100;
    Path bubblePath = Path();

    // Draw bubble body
    bubblePath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height), Radius.circular(15)));

    // Bottom pointer
    bubblePath.moveTo(size.width / 2 - 10, size.height);
    bubblePath.lineTo(size.width / 2, size.height + 10);
    bubblePath.lineTo(size.width / 2 + 10, size.height);

    // Top pointer
    bubblePath.moveTo(size.width / 2 - 10, 0);
    bubblePath.lineTo(size.width / 2, -10);
    bubblePath.lineTo(size.width / 2 + 10, 0);

    canvas.drawPath(bubblePath, paint);

    // Droplets
    canvas.drawCircle(Offset(size.width / 4, size.height + 20), 5, paint);
    canvas.drawCircle(Offset(size.width * 3 / 4, size.height + 15), 5, paint);
    canvas.drawCircle(Offset(size.width / 4, -20), 5, paint);
    canvas.drawCircle(Offset(size.width * 3 / 4, -15), 5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
