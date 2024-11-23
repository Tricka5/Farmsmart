import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  void _onMenuPressed() {
    print("Menu icon pressed");
  }

  void _onUserNotePressed() {
    print("User Note button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: _onMenuPressed,
        ),
        title: Text(
          "Farm Smart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Carousel with sliding images
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                
                itemCount: _imagePaths.length,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _imagePaths[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 400,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  },
                ),
              ),
            ],
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
          // Bottom fixed image
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/fixed_image.png',
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // User Note button
                  Positioned(
                    bottom: 16,
                    child: ElevatedButton.icon(
                      onPressed: _onUserNotePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(Icons.person),
                      label: Text("User Note"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
