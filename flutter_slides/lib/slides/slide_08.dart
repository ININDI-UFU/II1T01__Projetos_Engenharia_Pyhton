import 'dart:math';
import 'package:flutter/material.dart';

class Slide08 extends StatefulWidget {
  final int step;
  const Slide08({super.key, required this.step});
  @override
  State<Slide08> createState() => _Slide08State();
}

class _Slide08State extends State<Slide08> with SingleTickerProviderStateMixin {
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
    curve: Interval(a, b, curve: Curves.easeOut),
  );

  Widget _fade(
    Animation<double> anim, {
    double dy = 24,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, dy * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.0, 0.5);
    final subA = _iv(0.1, 0.6);

    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 960).clamp(0.25, 2.5);
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0C1B30), Color(0xFF071320), Color(0xFF040D18)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _DotGrid(s: s)),
              Padding(
                padding: EdgeInsets.fromLTRB(36 * s, 28 * s, 36 * s, 16 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fade(
                      titleA,
                      child: Text(
                        'Fluxograma do Algoritmo de Busca',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26 * s,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    _fade(subA, child: const SizedBox.shrink()),
                    SizedBox(height: 12 * s),
                    Expanded(
                      child: SizedBox.expand(
                        child: CustomPaint(painter: const _FlowchartPainter()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlowchartPainter extends CustomPainter {
  const _FlowchartPainter();

  static const _cyan = Color(0xFF00D4FF);
  static const _orange = Color(0xFFFF9F0A);
  static const _green = Color(0xFF30D158);
  static const _red = Color(0xFFFF453A);
  static const _purple = Color(0xFFBF5AF2);
  static const _darkFill = Color(0x1A00D4FF);

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos,
    TextStyle style, {
    TextAlign align = TextAlign.center,
    double maxWidth = 180,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    );
    tp.layout(maxWidth: maxWidth);
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  void _drawArrowLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color, {
    double strokeWidth = 1.5,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, paint);
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    const arrowSize = 7.0;
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * cos(angle - pi / 6),
        end.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        end.dx - arrowSize * cos(angle + pi / 6),
        end.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void _drawArrowPath(
    Canvas canvas,
    List<Offset> points,
    Color color, {
    double strokeWidth = 1.5,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
    final last = points[points.length - 1];
    final prev = points[points.length - 2];
    final angle = atan2(last.dy - prev.dy, last.dx - prev.dx);
    const arrowSize = 7.0;
    final arrowPath = Path()
      ..moveTo(last.dx, last.dy)
      ..lineTo(
        last.dx - arrowSize * cos(angle - pi / 6),
        last.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        last.dx - arrowSize * cos(angle + pi / 6),
        last.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 700;
    final sy = size.height / 520;

    Offset sc(double x, double y) => Offset(x * sx, y * sy);
    double sw(double w) => w * sx;
    double fs(double f) => f * (sx + sy) / 2;

    final boxStyle = TextStyle(
      color: Colors.white,
      fontSize: fs(10),
      height: 1.3,
    );
    final redLabelStyle = TextStyle(color: _red, fontSize: fs(9));
    final greenLabelStyle = TextStyle(color: _green, fontSize: fs(9));

    // ── 1. INÍCIO rounded rect (x=250,y=10,w=200,h=40) ──────────────────
    final startRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(250 * sx, 10 * sy, 200 * sx, 40 * sy),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      startRect,
      Paint()
        ..color = _darkFill
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      startRect,
      Paint()
        ..color = _cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'INÍCIO / i=0, max_tentativas=8000',
      sc(350, 30),
      boxStyle,
      maxWidth: sw(190),
    );

    // ── Arrow 1→2 ─────────────────────────────────────────────────────────
    _drawArrowLine(canvas, sc(350, 50), sc(350, 75), _cyan);

    // ── 2. Diamond "i < max_tentativas?" (350,75 480,130 350,185 220,130) ─
    final d1 = Path()
      ..moveTo(350 * sx, 75 * sy)
      ..lineTo(480 * sx, 130 * sy)
      ..lineTo(350 * sx, 185 * sy)
      ..lineTo(220 * sx, 130 * sy)
      ..close();
    canvas.drawPath(
      d1,
      Paint()
        ..color = const Color(0x1AFF9F0A)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      d1,
      Paint()
        ..color = _orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'i < max_tentativas?',
      sc(350, 130),
      boxStyle,
      maxWidth: sw(110),
    );

    // ── 3. NÃO arrow right (480,130)→FIM rect (x=580,y=105,w=110,h=50) ───
    _drawArrowLine(canvas, sc(480, 130), sc(580, 130), _red);
    _drawText(canvas, 'NÃO', sc(530, 118), redLabelStyle, maxWidth: sw(50));
    final fimRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(580 * sx, 105 * sy, 110 * sx, 50 * sy),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      fimRect,
      Paint()
        ..color = const Color(0x1AFF453A)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      fimRect,
      Paint()
        ..color = _red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'FIM\nOrdenar DataFrame',
      sc(635, 130),
      boxStyle,
      maxWidth: sw(100),
    );

    // ── 4. SIM arrow down (350,185)→Sortear rect (x=230,y=215,w=240,h=45) ─
    _drawArrowLine(canvas, sc(350, 185), sc(350, 215), _cyan);
    _drawText(canvas, 'SIM', sc(366, 200), greenLabelStyle, maxWidth: sw(40));
    final sortRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(230 * sx, 215 * sy, 240 * sx, 45 * sy),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      sortRect,
      Paint()
        ..color = const Color(0x1A00D4FF)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      sortRect,
      Paint()
        ..color = _cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'Sortear R1, R2, R3',
      sc(350, 237),
      boxStyle,
      maxWidth: sw(220),
    );

    // ── Arrow sort→calc ────────────────────────────────────────────────────
    _drawArrowLine(canvas, sc(350, 260), sc(350, 280), Colors.white54);

    // ── 5. Calcular rect (x=230,y=280,w=240,h=45) ────────────────────────
    final calcRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(230 * sx, 280 * sy, 240 * sx, 45 * sy),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      calcRect,
      Paint()
        ..color = const Color(0x1AFF9F0A)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      calcRect,
      Paint()
        ..color = _orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'Calcular ganho CA, offset CC, Vout',
      sc(350, 302),
      boxStyle,
      maxWidth: sw(220),
    );

    // ── Arrow calc→diamond2 ────────────────────────────────────────────────
    _drawArrowLine(canvas, sc(350, 325), sc(350, 350), Colors.white54);

    // ── 6. Diamond "circuito_valido()?" (350,350 470,395 350,440 230,395) ─
    final d2 = Path()
      ..moveTo(350 * sx, 350 * sy)
      ..lineTo(470 * sx, 395 * sy)
      ..lineTo(350 * sx, 440 * sy)
      ..lineTo(230 * sx, 395 * sy)
      ..close();
    canvas.drawPath(
      d2,
      Paint()
        ..color = const Color(0x1A30D158)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      d2,
      Paint()
        ..color = _green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'circuito_valido()?',
      sc(350, 395),
      boxStyle,
      maxWidth: sw(110),
    );

    // ── 7. NÃO arrow right (470,395)→"Descartar" at (580,393) ─────────────
    _drawArrowLine(canvas, sc(470, 395), sc(565, 395), _red);
    _drawText(canvas, 'NÃO', sc(518, 383), redLabelStyle, maxWidth: sw(50));
    _drawText(
      canvas,
      'Descartar',
      sc(610, 395),
      TextStyle(color: _red, fontSize: fs(10)),
      maxWidth: sw(80),
    );

    // ── 8. SIM arrow down (350,440)→Armazenar rect (x=270,y=460,w=160,h=40)
    _drawArrowLine(canvas, sc(350, 440), sc(350, 460), _green);
    _drawText(canvas, 'SIM', sc(366, 452), greenLabelStyle, maxWidth: sw(40));
    final storeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(270 * sx, 460 * sy, 160 * sx, 40 * sy),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      storeRect,
      Paint()
        ..color = const Color(0x1A30D158)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      storeRect,
      Paint()
        ..color = _green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(
      canvas,
      'Armazenar em\ncircuitos_encontrados[]',
      sc(350, 480),
      boxStyle,
      maxWidth: sw(150),
    );

    // ── Arrow store→i+1 ───────────────────────────────────────────────────
    _drawArrowLine(canvas, sc(350, 500), sc(350, 508), Colors.white54);

    // ── 9. i = i + 1 rect (x=290,y=508,w=120,h=25) ───────────────────────
    final incrRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(290 * sx, 508 * sy, 120 * sx, 25 * sy),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      incrRect,
      Paint()
        ..color = const Color(0x1ABF5AF2)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      incrRect,
      Paint()
        ..color = _purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawText(canvas, 'i = i + 1', sc(350, 520), boxStyle, maxWidth: sw(110));

    // ── 10. Loop back arrow (290,520)→(160,520)→(160,130)→(220,130) ───────
    _drawArrowPath(canvas, [
      sc(290, 520),
      sc(160, 520),
      sc(160, 130),
      sc(220, 130),
    ], _purple);
  }

  @override
  bool shouldRepaint(_FlowchartPainter old) => false;
}

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
