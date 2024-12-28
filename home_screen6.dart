import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class HomeScreen6 extends StatefulWidget {
  @override
  _HomeScreen6State createState() => _HomeScreen6State();
}

class _HomeScreen6State extends State<HomeScreen6>
    with TickerProviderStateMixin {
  late AnimationController _swarmController;
  late AnimationController _crystalController;
  final List<QuantumWidget> _widgets = [];
  final _random = math.Random();

  final List<String> _widgetTitles = [
    'System Status',
    'Quantum Process',
    'Network State',
    'Resource Usage',
    'Data Flow',
    'Energy Levels'
  ];

  @override
  void initState() {
    super.initState();
    _swarmController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _crystalController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _initializeWidgets();
  }

  void _initializeWidgets() {
    for (int i = 0; i < _widgetTitles.length; i++) {
      _widgets.add(QuantumWidget(
        title: _widgetTitles[i],
        position: _generateOptimalPosition(),
        state: _random.nextDouble(),
      ));
    }
  }

  Offset _generateOptimalPosition() {
    double x = 0, y = 0;
    double minDistance = 0.0;

    for (int attempt = 0; attempt < 10; attempt++) {
      double testX = _random.nextDouble();
      double testY = _random.nextDouble();
      double minCurrentDistance = double.infinity;

      for (var widget in _widgets) {
        double distance = (Offset(testX, testY) - widget.position).distance;
        minCurrentDistance = math.min(minCurrentDistance, distance);
      }

      if (minCurrentDistance > minDistance) {
        x = testX;
        y = testY;
        minDistance = minCurrentDistance;
      }
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildQuantumBackground(),
          _buildSwarmLayout(),
          _buildCrystallineToolbar(),
        ],
      ),
    );
  }

  Widget _buildQuantumBackground() {
    return AnimatedBuilder(
      animation: _swarmController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: QuantumBackgroundPainter(
            progress: _swarmController.value,
          ),
        );
      },
    );
  }

  Widget _buildSwarmLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _widgets.map((widget) {
            return Positioned(
              left: widget.position.dx * constraints.maxWidth,
              top: widget.position.dy * constraints.maxHeight,
              child: _buildQuantumWidget(widget),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuantumWidget(QuantumWidget widget) {
    return AnimatedBuilder(
      animation: _crystalController,
      builder: (context, child) {
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getCrystalColor(widget.state),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getCrystalColor(widget.state).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCrystalIcon(widget),
                    SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    _buildQuantumIndicator(widget.state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCrystalIcon(QuantumWidget widget) {
    return CustomPaint(
      size: Size(40, 40),
      painter: CrystalPainter(
        color: _getCrystalColor(widget.state),
        progress: _crystalController.value,
      ),
    );
  }

  Widget _buildQuantumIndicator(double state) {
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            _getCrystalColor(state),
            _getCrystalColor((state + 0.5) % 1.0),
          ],
          stops: [state, state],
        ),
      ),
    );
  }

  Widget _buildCrystallineToolbar() {
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
            _buildToolbarItem(Icons.dashboard, 'Dashboard'),
            _buildToolbarItem(Icons.analytics, 'Analytics'),
            _buildToolbarItem(Icons.settings, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Color _getCrystalColor(double state) {
    final colors = [
      Colors.cyan,
      Colors.purple,
      Colors.blue,
      Colors.teal,
    ];
    final index = (state * colors.length).floor();
    final nextIndex = (index + 1) % colors.length;
    final t = (state * colors.length) - index;
    return Color.lerp(colors[index], colors[nextIndex], t)!;
  }

  @override
  void dispose() {
    _swarmController.dispose();
    _crystalController.dispose();
    super.dispose();
  }
}

class QuantumWidget {
  final String title;
  final Offset position;
  final double state;

  QuantumWidget({
    required this.title,
    required this.position,
    required this.state,
  });
}

class QuantumBackgroundPainter extends CustomPainter {
  final double progress;

  QuantumBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final cellSize = 30.0;
    for (double x = 0; x < size.width; x += cellSize) {
      for (double y = 0; y < size.height; y += cellSize) {
        final wave = math.sin(progress * 2 * math.pi +
            (x / size.width + y / size.height) * 4 * math.pi);
        paint.color = Colors.blue.withOpacity((wave + 1) / 4 * 0.3);
        canvas.drawRect(
          Rect.fromLTWH(x, y, cellSize, cellSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(QuantumBackgroundPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class CrystalPainter extends CustomPainter {
  final Color color;
  final double progress;

  CrystalPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    for (var i = 0; i < 6; i++) {
      final angle = i * math.pi / 3 + progress * 2 * math.pi;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, paint);
    }
  }

  @override
  bool shouldRepaint(CrystalPainter oldDelegate) =>
      color != oldDelegate.color || progress != oldDelegate.progress;
}
