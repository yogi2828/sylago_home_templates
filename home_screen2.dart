import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class HomeScreen2 extends StatefulWidget {
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late String _greeting;
  Color _ambientColor = Colors.blue.shade100;
  final List<String> _greetings = [
    'Good Morning',
    'Good Afternoon',
    'Good Evening'
  ];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _updateGreeting();
    Timer.periodic(Duration(minutes: 1), (_) => _updateGreeting());
    _startAmbientColorAnimation();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = _greetings[0];
      } else if (hour < 17) {
        _greeting = _greetings[1];
      } else {
        _greeting = _greetings[2];
      }
    });
  }

  void _startAmbientColorAnimation() {
    Timer.periodic(Duration(seconds: 10), (_) {
      setState(() {
        _ambientColor = Color.lerp(
          _ambientColor,
          Colors.primaries[DateTime.now().second % Colors.primaries.length],
          0.1,
        )!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_ambientColor, _ambientColor.withOpacity(0.6)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAIHeader(),
              _buildNeuromorphicCards(),
              _buildPredictiveContent(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildQuantumButton(),
    );
  }

  Widget _buildAIHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your AI assistant is ready to help',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeuromorphicCards() {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return GestureDetector(
              onTapDown: (_) => _handleCardPress(index),
              onTapUp: (_) => _handleCardRelease(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _ambientColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.white24,
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getIconForIndex(index),
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildPredictiveContent() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              _buildPredictiveList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictiveList() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white70),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI-Generated Recommendation ${index + 1}',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantumButton() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.blue,
              ],
              stops: [0, 0.5, 1],
              transform: GradientRotation(_particleController.value * 6.28),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                // Handle quantum button tap
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.home,
      Icons.favorite,
      Icons.notifications,
      Icons.person,
    ];
    return icons[index];
  }

  void _handleCardPress(int index) {
    // Add haptic feedback and card press animation
  }

  void _handleCardRelease(int index) {
    // Reset card animation
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }
}
