import 'package:flutter/material.dart';

class Slide06 extends StatefulWidget {
  final int step;
  const Slide06({super.key, this.step = 0});
  @override
  State<Slide06> createState() => _Slide06State();
}

class _Slide06State extends State<Slide06> with TickerProviderStateMixin {
  late final AnimationController _entry;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b) => CurvedAnimation(
    parent: _entry,
    curve: Interval(a, b, curve: Curves.easeOutCubic),
  );

  Widget _fade(
    Animation<double> a, {
    required double dy,
    required Widget child,
  }) => AnimatedBuilder(
    animation: a,
    builder: (context, _) => Opacity(
      opacity: a.value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, dy * (1 - a.value)),
        child: child,
      ),
    ),
  );

  Widget _reveal(int threshold, Widget child) {
    final visible = widget.step >= threshold;
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.75,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.00, 0.40);
    final step = widget.step;

    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 960).clamp(0.25, 2.5);

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0C1B30), Color(0xFF071320), Color(0xFF040D18)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _DotGrid(s: s)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(36 * s, 28 * s, 36 * s, 16 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fade(
                      titleA,
                      dy: -20.0 * s,
                      child: Text(
                        'Esquemático do Circuito Condicionador',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36 * s,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 14 * s),
                    Expanded(child: _buildContent(s, step)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(double s, int step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left — circuit diagram
        Expanded(child: _reveal(1, _buildCircuitPanel(s))),
        SizedBox(width: 16 * s),
        // Right — component descriptions
        Expanded(child: _reveal(2, _buildInfoPanel(s))),
      ],
    );
  }

  Widget _buildCircuitPanel(double s) {
    return Container(
      padding: EdgeInsets.all(12 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(
          color: const Color(0xFF1E4080).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8 * s),
        child: Image.asset(
          'assets/condSinal.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildInfoPanel(double s) {
    const teal = Color(0xFF00BFA5);
    const orange = Color(0xFFFF9F0A);
    const green = Color(0xFF30D158);
    const purple = Color(0xFF9B7BE8);

    return Container(
      padding: EdgeInsets.all(20 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(
          color: const Color(0xFF1E4080).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FUNÇÃO DOS COMPONENTES',
            style: TextStyle(
              color: teal,
              fontSize: 10 * s,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16 * s),
          _infoItem(
            s,
            'R3 (Série)',
            orange,
            'Atenua o sinal CA. Forma divisor de tensão com R1‖R2.',
          ),
          SizedBox(height: 14 * s),
          _infoItem(
            s,
            'R1 (para Vcc)',
            green,
            'Introduz offset CC positivo. Eleva o sinal para faixa 0-5V.',
          ),
          SizedBox(height: 14 * s),
          _infoItem(
            s,
            'R2 (para GND)',
            purple,
            'Completa divisor de tensão. R2 = R1 simplifica o cálculo.',
          ),
          SizedBox(height: 14 * s),
          _infoItem(
            s,
            'Vout',
            orange,
            'Vcc + ganho_CA × Vpico. Deve ficar entre 0V e 5V.',
          ),
        ],
      ),
    );
  }

  Widget _infoItem(double s, String title, Color color, String desc) {
    return Container(
      padding: EdgeInsets.only(left: 10 * s),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: color, width: 3 * s),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12 * s,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3 * s),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11 * s,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circuit Painter ────────────────────────────────────────────────────────────
// Reference SVG viewBox: 0 0 560 420
// Coordinates are scaled by (canvasWidth/560) and (canvasHeight/420).

class _CircuitPainter extends CustomPainter {
  const _CircuitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double sx = size.width / 560;
    final double sy = size.height / 420;

    Offset o(double x, double y) => Offset(x * sx, y * sy);

    RRect rr(double x, double y, double w, double h) => RRect.fromRectAndRadius(
      Rect.fromLTWH(x * sx, y * sy, w * sx, h * sy),
      Radius.circular(4 * sx),
    );

    Paint stroke(Color c) => Paint()
      ..color = c
      ..strokeWidth = 1.5 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint fillP(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.fill;

    const wireColor = Color(0xFF6A8FA8);
    const cyan = Color(0xFF00BFA5);
    const orange = Color(0xFFFF9F0A);
    const blue = Color(0xFF5B9BD5);
    const green = Color(0xFF30D158);
    const purple = Color(0xFF9B7BE8);
    const bgColor = Color(0xFF081828);

    final wireP = stroke(wireColor);

    // ── 1. Wires (drawn first so component fills cover their ends) ────────────

    // 220V source right edge → R3 left edge
    canvas.drawLine(o(105, 220), o(150, 220), wireP);
    // R3 right edge → junction node
    canvas.drawLine(o(250, 220), o(320, 220), wireP);
    // Junction → Vout box left edge
    canvas.drawLine(o(320, 220), o(385, 220), wireP);
    // Junction up → R1 bottom edge
    canvas.drawLine(o(320, 215), o(320, 175), wireP);
    // R1 top edge → Vcc bottom edge
    canvas.drawLine(o(320, 110), o(320, 83), wireP);
    // Junction down → R2 top edge
    canvas.drawLine(o(320, 225), o(320, 280), wireP);
    // R2 bottom edge → GND top edge
    canvas.drawLine(o(320, 345), o(320, 375), wireP);
    // Vout right edge → ADC left edge
    canvas.drawLine(o(460, 220), o(480, 220), wireP);

    // ── 2. Component background fills (covers wire ends inside boxes) ─────────

    final bg = fillP(bgColor.withValues(alpha: 0.85));
    canvas.drawCircle(o(70, 220), 35 * sx, bg);
    canvas.drawRRect(rr(150, 195, 100, 50), bg);
    canvas.drawRRect(rr(290, 110, 60, 65), bg);
    canvas.drawRRect(rr(285, 55, 70, 28), bg);
    canvas.drawRRect(rr(290, 280, 60, 65), bg);
    canvas.drawRRect(rr(290, 375, 60, 25), bg);
    canvas.drawRRect(rr(385, 198, 75, 44), bg);
    canvas.drawRRect(rr(480, 195, 70, 50), bg);

    // ── 3. Component borders ──────────────────────────────────────────────────

    canvas.drawCircle(o(70, 220), 35 * sx, stroke(cyan)); // 220V source
    canvas.drawRRect(rr(150, 195, 100, 50), stroke(orange)); // R3
    canvas.drawRRect(rr(290, 110, 60, 65), stroke(blue)); // R1
    canvas.drawRRect(rr(285, 55, 70, 28), stroke(green)); // +Vcc
    canvas.drawRRect(rr(290, 280, 60, 65), stroke(purple)); // R2
    canvas.drawRRect(rr(290, 375, 60, 25), stroke(orange)); // GND
    canvas.drawRRect(rr(385, 198, 75, 44), stroke(orange)); // Vout
    canvas.drawRRect(rr(480, 195, 70, 50), stroke(green)); // ADC

    // ── 4. Arrowhead: Vout → ADC ──────────────────────────────────────────────

    final arrowHead = Path()
      ..moveTo(o(484, 220).dx, o(484, 220).dy)
      ..lineTo(o(479, 215).dx, o(479, 215).dy)
      ..lineTo(o(479, 225).dx, o(479, 225).dy)
      ..close();
    canvas.drawPath(arrowHead, fillP(wireColor));

    // ── 5. Junction node dot ──────────────────────────────────────────────────

    canvas.drawCircle(o(320, 220), 5 * sx, fillP(Colors.white));
    canvas.drawCircle(o(320, 220), 5 * sx, stroke(wireColor));

    // ── 6. Text labels ────────────────────────────────────────────────────────

    void label(String text, double cx, double cy, Color color, double fs) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: fs * sx,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 90 * sx);
      tp.paint(canvas, o(cx, cy) - Offset(tp.width / 2, tp.height / 2));
    }

    label('220V\nRMS', 70, 220, cyan, 9.5);
    label('R3', 200, 220, orange, 13);
    label('R1', 320, 142, blue, 13);
    label('+Vcc\n(5V)', 320, 69, green, 9);
    label('R2', 320, 312, purple, 13);
    label('GND', 320, 387, orange, 9);
    label('Vout\n0–5V', 422, 220, orange, 9);
    label('ADC', 515, 220, green, 13);
  }

  @override
  bool shouldRepaint(_CircuitPainter old) => false;
}

// ── Dot Grid ──────────────────────────────────────────────────────────────────

class _DotGrid extends CustomPainter {
  final double s;
  const _DotGrid({required this.s});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1E3854).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    final sp = 30.0 * s;
    final r = 1.0 * s;
    for (double x = sp; x < size.width; x += sp) {
      for (double y = sp; y < size.height; y += sp) {
        canvas.drawCircle(Offset(x, y), r, p);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGrid o) => false;
}
