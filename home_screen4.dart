import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen4 extends StatefulWidget {
  @override
  _HomeScreen4State createState() => _HomeScreen4State();
}

class _HomeScreen4State extends State<HomeScreen4>
    with TickerProviderStateMixin {
  late AnimationController _mapController;
  late AnimationController _particleController;
  double _userProximity = 0.0;
  final List<String> _nearbyServices = [
    'Restaurants',
    'Coffee Shops',
    'Shopping',
    'Entertainment',
    'Services',
    'Transportation'
  ];

  @override
  void initState() {
    super.initState();
    _mapController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate proximity changes
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _userProximity = 0.8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildHolographicMap(),
          CustomScrollView(
            slivers: [
              _buildLocationHeader(),
              _buildNearbyServices(),
              _buildPersonalizedContent(),
            ],
          ),
          _buildParticleOverlay(),
        ],
      ),
    );
  }

  Widget _buildHolographicMap() {
    return AnimatedBuilder(
      animation: _mapController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                math.cos(_mapController.value * 2 * math.pi) * 0.2,
                math.sin(_mapController.value * 2 * math.pi) * 0.2,
              ),
              radius: 1.5,
              colors: [
                Colors.blue.withOpacity(0.3),
                Colors.purple.withOpacity(0.1),
                Colors.black,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: GridPainter(
              progress: _mapController.value,
              proximity: _userProximity,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Location',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Downtown District',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyServices() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildServiceCard(index),
          childCount: _nearbyServices.length,
        ),
      ),
    );
  }

  Widget _buildServiceCard(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForService(index),
                color: Colors.white,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                _nearbyServices[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalizedContent() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalized For You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildRecommendationList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationList() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recommended Place ${index + 1}',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Text(
                '${(0.5 + index * 0.3).toStringAsFixed(1)} km',
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticleOverlay() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(
            progress: _particleController.value,
            proximity: _userProximity,
          ),
        );
      },
    );
  }

  IconData _getIconForService(int index) {
    final icons = [
      Icons.restaurant,
      Icons.coffee,
      Icons.shopping_bag,
      Icons.movie,
      Icons.miscellaneous_services,
      Icons.directions_bus,
    ];
    return icons[index];
  }

  @override
  void dispose() {
    _mapController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class GridPainter extends CustomPainter {
  final double progress;
  final double proximity;

  GridPainter({required this.progress, required this.proximity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final spacing = 30.0;
    for (var i = 0; i < size.width / spacing; i++) {
      for (var j = 0; j < size.height / spacing; j++) {
        final offset = Offset(i * spacing, j * spacing);
        canvas.drawCircle(offset, 2 * proximity, paint);
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      progress != oldDelegate.progress || proximity != oldDelegate.proximity;
}

class ParticlePainter extends CustomPainter {
  final double progress;
  final double proximity;

  ParticlePainter({required this.progress, required this.proximity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final particleCount = 50;
    final random = math.Random(42);

    for (var i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 * proximity;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      progress != oldDelegate.progress || proximity != oldDelegate.proximity;
}
