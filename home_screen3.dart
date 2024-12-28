import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class HomeScreen3 extends StatefulWidget {
  @override
  _HomeScreen3State createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3>
    with TickerProviderStateMixin {
  late AnimationController _carouselController;
  late SpringSimulation _springSimulation;
  double _carouselOffset = 0.0;
  bool _isSearchActive = false;
  final List<String> _categories = [
    'Featured',
    'Trending',
    'New',
    'Popular',
    'Recommended',
    'Following',
    'Discover',
    'For You'
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _springSimulation = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: 500.0,
        damping: 20.0,
      ),
      0.0,
      1.0,
      0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildInfiniteBackground(),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildSearchBar(),
              _buildZeroGravityCarousel(),
              _buildTessellationGrid(),
            ],
          ),
          _buildSpatialNavBar(),
        ],
      ),
    );
  }

  Widget _buildInfiniteBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.blue.shade900,
            Colors.black,
          ],
          stops: [0.0, 1.0],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(16),
        height: _isSearchActive ? 120 : 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
              });
              // Trigger voice recognition
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search with voice or AR',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZeroGravityCarousel() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _carouselOffset += details.delta.dx;
            });
          },
          onPanEnd: (details) {
            _carouselController.animateWith(_springSimulation);
          },
          child: AnimatedBuilder(
            animation: _carouselController,
            builder: (context, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Transform.translate(
                    offset: Offset(
                        _carouselOffset * (1 - _carouselController.value), 0),
                    child: _buildFloatingCard(index),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCard(int index) {
    return Container(
      width: 160,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Featured ${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTessellationGrid() {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            return _buildTessellationTile(index);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildTessellationTile(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Add haptic feedback
          },
          child: Center(
            child: Text(
              _categories[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpatialNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home'),
            _buildNavItem(Icons.explore, 'Explore'),
            _buildNavItem(Icons.notifications, 'Updates'),
            _buildNavItem(Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Add haptic feedback and spatial audio
        },
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }
}
