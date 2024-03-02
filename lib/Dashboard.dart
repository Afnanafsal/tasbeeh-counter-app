import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_us_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int count = 0;
  bool _animating = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _centerIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );
    _animation = Tween<double>(begin: 0, end: 55).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _animating = false;
            count++;
          });
        }
      });
    _centerIndex = 5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_animating) {
      setState(() {
        _animating = true;
        _centerIndex = 4; // Center index is set to 4 after tapping
      });
      _controller.forward(from: 0);
      setState(() {
        count++;
      });
    }
    // Calculate the index based on the tap position
    double yPosition = details.localPosition.dy;
    int index = ((yPosition + _animation.value) / 55).round();
    print('Tapped index: $index');
  }

  void _resetCount() {
    setState(() {
      count = -1;
    });
  }

  // Launch the developer's website
  void _launchWebsite() async {
    const url = 'https://afnanafsal.vercel.app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Method to show the rating dialog
  void _showRatingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRating = 0;
        return AlertDialog(
          title: Text('Rate Us'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How would you rate our app?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedRating);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    ).then((rating) {
      if (rating != null) {
        print('User rated the app: $rating stars');
        // You can handle the user's rating here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0, // Remove shadow
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome User',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'Start to count',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Tasbeeh',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text('About Us'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Version : 1.0.0'),
              ),
              ListTile(
                title: Text('Rate Us'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _showRatingPopup(context); // Show the rating popup
                },
              ),
              ListTile(
                title: Text('Developer'),
                onTap: () {
                  _launchWebsite(); // Launch the developer's website
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            width: 300, // Adjust width of container to center the stack
            height: 550, // Adjust height of container to center the stack
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (int i = 0; i < 200; i++)
                  Positioned(
                    top: i * 55.0 -
                        (_animating
                            ? _animation.value
                            : 0), // Adjust top position
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective effect
                        ..rotateX(
                            0.6) // Rotate along X-axis for depth perception
                        ..rotateY(
                            0.4), // Rotate along Y-axis for depth perception
                      child: Material(
                        elevation: 0, // Remove shadow
                        shape: CircleBorder(),
                        color: Colors.blue,
                        child: Container(
                          width: 70, // Adjust width of circle
                          height: 70, // Adjust height of circle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top:
                      _centerIndex * 53.0 - (_animating ? _animation.value : 0),
                  child: Container(
                    width: 100, // Adjust width of circle
                    height: 100, // Adjust height of circle
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Text(
                    'Count: $count',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetCount,
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Implement PopupMenuButton for "Rate Us"
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
  ));
}
