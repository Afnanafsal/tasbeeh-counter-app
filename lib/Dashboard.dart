import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0, // Remove shadow
          backgroundColor: Colors.white,
          title: Text(
            'Welcome User',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Start to Count',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
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
