import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _menuAnimationController;
  double _scrollOffset = 0;
  List<double> _gyroscopeValues = [0, 0, 0];

  final List<String> _promotions = [
    'Summer Collection',
    'New Arrivals',
    'Special Offers',
    'Limited Edition',
  ];

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _menuAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = [event.x, event.y, event.z];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          setState(() {
            _scrollOffset = notification.metrics.pixels;
          });
          return true;
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildAnimatedHeader(),
                _buildPromotionCarousel(),
                _buildAdaptiveGrid(),
              ],
            ),
            _buildFloatingNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedBuilder(
          animation: _logoAnimationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_logoAnimationController.value * math.pi * 2 +
                    (_scrollOffset * 0.001)),
              child: Text(
                'ADAPTIVE UI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        background: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCarousel() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _promotions.length,
          itemBuilder: (context, index) {
            double parallaxOffset = _gyroscopeValues[1] * 10;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(parallaxOffset),
              child: Container(
                width: 300,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.7),
                      Colors.purple.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _promotions[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdaptiveGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.apps,
                color: Colors.white,
                size: 32,
              ),
            ),
          );
        },
        childCount: 12,
      ),
    );
  }

  Widget _buildFloatingNavigation() {
    return Positioned(
      bottom: 32,
      right: 32,
      child: GestureDetector(
        onTapDown: (_) => _menuAnimationController.forward(),
        onTapUp: (_) => _menuAnimationController.reverse(),
        child: AnimatedBuilder(
          animation: _menuAnimationController,
          builder: (context, child) {
            return Container(
              width: 60 + (_menuAnimationController.value * 200),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home, color: Colors.white),
                  if (_menuAnimationController.value > 0.5) ...[
                    Icon(Icons.search, color: Colors.white),
                    Icon(Icons.person, color: Colors.white),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _menuAnimationController.dispose();
    super.dispose();
  }
}
