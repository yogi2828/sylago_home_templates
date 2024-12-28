import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class HomeScreen5 extends StatefulWidget {
  @override
  _HomeScreen5State createState() => _HomeScreen5State();
}

class _HomeScreen5State extends State<HomeScreen5>
    with TickerProviderStateMixin {
  late AnimationController _patternController;
  late AnimationController _cardController;
  final List<NeuralCard> _cards = [];
  double _gestureZ = 0.0;

  final List<String> _cardTitles = [
    'Daily Summary',
    'Task Priority',
    'Analytics',
    'Messages',
    'Calendar',
    'Projects'
  ];

  @override
  void initState() {
    super.initState();
    _patternController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _cardController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeCards();
  }

  void _initializeCards() {
    final random = math.Random();
    for (int i = 0; i < _cardTitles.length; i++) {
      _cards.add(NeuralCard(
        title: _cardTitles[i],
        position: Offset(
          random.nextDouble() * 0.5 + 0.25,
          random.nextDouble() * 0.5 + 0.25,
        ),
        importance: random.nextDouble(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildNeuralBackground(),
          _buildCardGrid(),
          _buildGestureOverlay(),
        ],
      ),
    );
  }

  Widget _buildNeuralBackground() {
    return AnimatedBuilder(
      animation: _patternController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: NeuralPatternPainter(
            progress: _patternController.value,
            intensity: _gestureZ,
          ),
        );
      },
    );
  }

  Widget _buildCardGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _cards.map((card) {
            return Positioned(
              left: card.position.dx * constraints.maxWidth,
              top: card.position.dy * constraints.maxHeight,
              child: _buildNeuralCard(card),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNeuralCard(NeuralCard card) {
    return GestureDetector(
      onPanUpdate: (details) => _handleCardDrag(card, details),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(card.importance * 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForCard(card.title),
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 12),
                  Text(
                    card.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGestureOverlay() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _gestureZ =
              (details.localPosition.dy / context.size!.height).clamp(0.0, 1.0);
        });
      },
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  void _handleCardDrag(NeuralCard card, DragUpdateDetails details) {
    setState(() {
      final size = context.size!;
      card.position = Offset(
        (card.position.dx * size.width + details.delta.dx) / size.width,
        (card.position.dy * size.height + details.delta.dy) / size.height,
      );
      _optimizeCardPositions(card);
    });
  }

  void _optimizeCardPositions(NeuralCard movedCard) {
    for (var card in _cards) {
      if (card != movedCard) {
        final distance = (card.position - movedCard.position).distance;
        if (distance < 0.2) {
          final angle = math.atan2(
            card.position.dy - movedCard.position.dy,
            card.position.dx - movedCard.position.dx,
          );
          card.position = Offset(
            card.position.dx + math.cos(angle) * 0.01,
            card.position.dy + math.sin(angle) * 0.01,
          );
        }
      }
    }
  }

  IconData _getIconForCard(String title) {
    final icons = {
      'Daily Summary': Icons.dashboard,
      'Task Priority': Icons.assignment,
      'Analytics': Icons.analytics,
      'Messages': Icons.message,
      'Calendar': Icons.calendar_today,
      'Projects': Icons.work,
    };
    return icons[title] ?? Icons.widgets;
  }

  @override
  void dispose() {
    _patternController.dispose();
    _cardController.dispose();
    super.dispose();
  }
}

class NeuralCard {
  final String title;
  Offset position;
  final double importance;

  NeuralCard({
    required this.title,
    required this.position,
    required this.importance,
  });
}

class NeuralPatternPainter extends CustomPainter {
  final double progress;
  final double intensity;

  NeuralPatternPainter({required this.progress, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final random = math.Random(42);
    final points = List.generate(20, (index) {
      return Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
    });

    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        final distance = (points[i] - points[j]).distance;
        if (distance < 100 + intensity * 50) {
          final opacity = (1 - distance / 150) * 0.5;
          paint.color = Colors.white.withOpacity(opacity * (1 - progress));
          canvas.drawLine(points[i], points[j], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(NeuralPatternPainter oldDelegate) =>
      progress != oldDelegate.progress || intensity != oldDelegate.intensity;
}
