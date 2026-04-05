import 'package:flutter/material.dart';

class Slide01 extends StatefulWidget {
  const Slide01({super.key});

  @override
  State<Slide01> createState() => _Slide01State();
}

class _Slide01State extends State<Slide01> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _glow;
  late final AnimationController _scan;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _entry.dispose();
    _glow.dispose();
    _scan.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b) => CurvedAnimation(
    parent: _entry,
    curve: Interval(a, b, curve: Curves.easeOutCubic),
  );

  @override
  Widget build(BuildContext context) {
    final chipA = _iv(0.00, 0.45);
    final titleA = _iv(0.20, 0.60);
    final lineA = _iv(0.35, 0.65);
    final subA = _iv(0.45, 0.75);
    final bodyA = _iv(0.60, 1.00);
    final glowA = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glow, curve: Curves.easeInOut));
    final scanA = CurvedAnimation(parent: _scan, curve: Curves.linear);

    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final h = box.maxHeight;
        final s = (w / 960).clamp(0.25, 2.5);

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
              // ── Dot grid ────────────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(painter: _DotGrid(s: s)),
              ),

              // ── Scan line ───────────────────────────────────────────────
              AnimatedBuilder(
                animation: scanA,
                builder: (context, _) => Positioned(
                  top: -2,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, (h + 4) * scanA.value),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF00BCD4).withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Corner traces ────────────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                child: CustomPaint(
                  size: Size(100 * s, 70 * s),
                  painter: _CornerTrace(s: s, flip: false),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(100 * s, 70 * s),
                  painter: _CornerTrace(s: s, flip: true),
                ),
              ),

              // ── Radial glow behind chip ──────────────────────────────────
              AnimatedBuilder(
                animation: glowA,
                builder: (context, _) => Positioned(
                  top: h * 0.04,
                  left: w * 0.3,
                  right: w * 0.3,
                  child: Container(
                    height: h * 0.55,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          const Color(
                            0xFF00BCD4,
                          ).withValues(alpha: 0.07 * glowA.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main content ─────────────────────────────────────────────
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48 * s),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chip
                      AnimatedBuilder(
                        animation: Listenable.merge([chipA, glowA]),
                        builder: (context, _) => Opacity(
                          opacity: chipA.value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, (1 - chipA.value) * -28 * s),
                            child: SizedBox(
                              width: 96 * s,
                              height: 96 * s,
                              child: CustomPaint(
                                painter: _ChipIC(glow: glowA.value, s: s),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 26 * s),

                      // Title
                      AnimatedBuilder(
                        animation: titleA,
                        builder: (context, _) => Opacity(
                          opacity: titleA.value.clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(0, (1 - titleA.value) * 22 * s),
                            child: Text(
                              'Condicionador de Sinais',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44 * s,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8 * s,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16 * s),

                      // Expanding separator
                      AnimatedBuilder(
                        animation: lineA,
                        builder: (context, _) => Container(
                          width: 280 * s * lineA.value,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF00BCD4).withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16 * s),

                      // Subtitle
                      AnimatedBuilder(
                        animation: subA,
                        builder: (context, _) => Opacity(
                          opacity: subA.value.clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(0, (1 - subA.value) * 14 * s),
                            child: Text(
                              'Resolvendo problemas com Python na Engenharia',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF7B8EA2),
                                fontSize: 17 * s,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 44 * s),

                      // Description card
                      AnimatedBuilder(
                        animation: bodyA,
                        builder: (context, _) => Opacity(
                          opacity: bodyA.value.clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(0, (1 - bodyA.value) * 18 * s),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 680 * s),
                              padding: EdgeInsets.only(top: 16 * s),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: const Color(
                                      0xFF1E5080,
                                    ).withValues(alpha: 0.6),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: const Color(0xFF6B7D8E),
                                    fontSize: 14 * s,
                                    height: 1.6,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Dimensionar um condicionador de sinais para adaptar uma entrada de ',
                                    ),
                                    TextSpan(
                                      text: '220 V RMS',
                                      style: TextStyle(
                                        color: const Color(0xFFFF9F0A),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14 * s,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          ' a uma faixa compatível com um dispositivo digital de ',
                                    ),
                                    TextSpan(
                                      text: '0 a 5 V',
                                      style: TextStyle(
                                        color: const Color(0xFFFF9F0A),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14 * s,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Chip IC Painter ──────────────────────────────────────────────────────────

class _ChipIC extends CustomPainter {
  final double glow;
  final double s;

  const _ChipIC({required this.glow, required this.s});

  static const _cyan = Color(0xFF00BCD4);

  @override
  void paint(Canvas canvas, Size sz) {
    final cx = sz.width / 2;
    final cy = sz.height / 2;
    final cw = sz.width * 0.50;
    final ch = sz.height * 0.50;

    final chip = Rect.fromCenter(center: Offset(cx, cy), width: cw, height: ch);

    // Glow halo
    canvas.drawRRect(
      RRect.fromRectAndRadius(chip.inflate(6), const Radius.circular(6)),
      Paint()
        ..color = _cyan.withValues(alpha: 0.22 * glow)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    final stroke = Paint()
      ..color = _cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * s;

    // Outer chip body
    canvas.drawRRect(
      RRect.fromRectAndRadius(chip, const Radius.circular(4 * 1)),
      stroke,
    );

    // Inner die area
    final die = Rect.fromCenter(
      center: Offset(cx, cy),
      width: cw * 0.52,
      height: ch * 0.52,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(die, const Radius.circular(2)),
      stroke,
    );

    // Cross lines inside die
    final faint = Paint()
      ..color = _cyan.withValues(alpha: 0.45)
      ..strokeWidth = 0.9 * s
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(die.left + 4 * s, cy),
      Offset(die.right - 4 * s, cy),
      faint,
    );
    canvas.drawLine(
      Offset(cx, die.top + 4 * s),
      Offset(cx, die.bottom - 4 * s),
      faint,
    );

    // Center dot
    canvas.drawCircle(
      Offset(cx, cy),
      2.5 * s,
      Paint()
        ..color = _cyan.withValues(alpha: 0.7 + 0.3 * glow)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * glow),
    );

    // Pins: 3 per side
    const n = 3;
    const pLen = 13.0;
    final pin = Paint()
      ..color = _cyan
      ..strokeWidth = 1.3 * s
      ..strokeCap = StrokeCap.round;
    final dot = Paint()
      ..color = _cyan
      ..style = PaintingStyle.fill;

    for (int i = 0; i < n; i++) {
      final t = (i + 1) / (n + 1);
      final px = chip.left + chip.width * t;
      final py = chip.top + chip.height * t;

      // Top
      canvas.drawLine(
        Offset(px, chip.top),
        Offset(px, chip.top - pLen * s),
        pin,
      );
      canvas.drawCircle(Offset(px, chip.top - pLen * s), 2.2 * s, dot);
      // Bottom
      canvas.drawLine(
        Offset(px, chip.bottom),
        Offset(px, chip.bottom + pLen * s),
        pin,
      );
      canvas.drawCircle(Offset(px, chip.bottom + pLen * s), 2.2 * s, dot);
      // Left
      canvas.drawLine(
        Offset(chip.left, py),
        Offset(chip.left - pLen * s, py),
        pin,
      );
      canvas.drawCircle(Offset(chip.left - pLen * s, py), 2.2 * s, dot);
      // Right
      canvas.drawLine(
        Offset(chip.right, py),
        Offset(chip.right + pLen * s, py),
        pin,
      );
      canvas.drawCircle(Offset(chip.right + pLen * s, py), 2.2 * s, dot);
    }
  }

  @override
  bool shouldRepaint(_ChipIC o) => o.glow != glow;
}

// ── Dot Grid ─────────────────────────────────────────────────────────────────

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

// ── Corner Circuit Trace ─────────────────────────────────────────────────────

class _CornerTrace extends CustomPainter {
  final double s;
  final bool flip;
  const _CornerTrace({required this.s, required this.flip});

  @override
  void paint(Canvas canvas, Size sz) {
    if (flip) {
      canvas.translate(sz.width, sz.height);
      canvas.scale(-1, -1);
    }

    final stroke = Paint()
      ..color = const Color(0xFF00BCD4).withValues(alpha: 0.18)
      ..strokeWidth = 1.0 * s
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dot = Paint()
      ..color = const Color(0xFF00BCD4).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    // L-shaped traces
    final path = Path()
      ..moveTo(0, 20 * s)
      ..lineTo(0, 0)
      ..lineTo(20 * s, 0)
      ..moveTo(0, 45 * s)
      ..lineTo(0, 35 * s)
      ..lineTo(15 * s, 35 * s)
      ..moveTo(40 * s, 0)
      ..lineTo(55 * s, 0)
      ..lineTo(55 * s, 15 * s);

    canvas.drawPath(path, stroke);

    for (final pt in [
      Offset(15 * s, 35 * s),
      Offset(55 * s, 15 * s),
      Offset(20 * s, 0),
    ]) {
      canvas.drawCircle(pt, 2.0 * s, dot);
    }
  }

  @override
  bool shouldRepaint(_CornerTrace o) => false;
}
