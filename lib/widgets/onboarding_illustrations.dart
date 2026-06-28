import 'package:flutter/material.dart';

class ScanIllustration extends StatelessWidget {
  const ScanIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 260,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.08),
              borderRadius: BorderRadius.circular(24),
            ),
          ),

          Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (_) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'AI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ScanCornerPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FiltersIllustration extends StatelessWidget {
  const FiltersIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'name': 'Before', 'color': Colors.grey.shade300},
      {'name': 'Sharp', 'color': Colors.blue.shade100},
      {'name': 'Best', 'color': Colors.black87},
    ];

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          filters.length,
          (index) {
            final item = filters[index];

            return Container(
              margin: const EdgeInsets.all(6),
              width: 75,
              height: 120,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  if (index == 2)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "BEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item['name'].toString(),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PdfIllustration extends StatelessWidget {
  const PdfIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-12, 10),
            child: page(),
          ),
          Transform.translate(
            offset: const Offset(-6, 5),
            child: page(),
          ),
          mainPdfCard(),
        ],
      ),
    );
  }

  Widget page() {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget mainPdfCard() {
    return Container(
      width: 150,
      height: 190,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff14B8A6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'document.pdf',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '3 pages',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class ScanCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(30, 30),
      const Offset(60, 30),
      paint,
    );

    canvas.drawLine(
      const Offset(30, 30),
      const Offset(30, 60),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 60, 30),
      Offset(size.width - 30, 30),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 30, 30),
      Offset(size.width - 30, 60),
      paint,
    );

    canvas.drawLine(
      Offset(30, size.height - 30),
      Offset(60, size.height - 30),
      paint,
    );

    canvas.drawLine(
      Offset(30, size.height - 60),
      Offset(30, size.height - 30),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 60, size.height - 30),
      Offset(size.width - 30, size.height - 30),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 30, size.height - 60),
      Offset(size.width - 30, size.height - 30),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}