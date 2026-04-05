import 'dart:math';
import 'package:flutter/material.dart';

// ── Widget ────────────────────────────────────────────────────────────────────

class Slide14 extends StatefulWidget {
  final int step;
  const Slide14({super.key, required this.step});

  @override
  State<Slide14> createState() => _Slide14State();
}

// ── State ─────────────────────────────────────────────────────────────────────

class _Slide14State extends State<Slide14> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _osc;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _osc = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _entry.dispose();
    _osc.dispose();
    super.dispose();
  }

  // ── Animation helpers ──────────────────────────────────────────────────────

  Animation<double> _iv(double a, double b) =>
      CurvedAnimation(parent: _entry, curve: Interval(a, b, curve: Curves.easeOut));

  Widget _fade(Animation<double> anim, {double dy = 24, required Widget child}) =>
      AnimatedBuilder(
        animation: anim,
        builder: (context, _) => Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, dy * (1 - anim.value)),
            child: child,
          ),
        ),
      );

  Widget _reveal(bool visible, Widget child) => AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: visible ? 1.0 : 0.90,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          child: child,
        ),
      );

  // ── Oscilloscope widget ────────────────────────────────────────────────────

  Widget _buildOscilloscope(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 6 * s),
          decoration: BoxDecoration(
            color: const Color(0xFF001A00),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10 * s),
              topRight: Radius.circular(10 * s),
            ),
            border: Border.all(
              color: const Color(0xFF00FF41).withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8 * s,
                height: 8 * s,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF41),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8 * s),
              Text(
                'OSCILLOSCOPE  ·  V_out',
                style: TextStyle(
                  color: const Color(0xFF00FF41).withValues(alpha: 0.85),
                  fontSize: 10 * s,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                '∿ RUNNING',
                style: TextStyle(
                  color: const Color(0xFF00FF41).withValues(alpha: 0.6),
                  fontSize: 9 * s,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        // Screen area
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF00FF41).withValues(alpha: 0.3),
                width: 1.5 * s,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10 * s),
                bottomRight: Radius.circular(10 * s),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(9 * s),
                bottomRight: Radius.circular(9 * s),
              ),
              child: AnimatedBuilder(
                animation: _osc,
                builder: (context, _) => CustomPaint(
                  painter: _OscPainter(s: s, phase: _osc.value),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Right info panel ───────────────────────────────────────────────────────

  Widget _bullet(double s, String text, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13 * s,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5 * s,
                color: const Color(0xFFB0C4D8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPanel({
    required double s,
    required String header,
    required Color headerColor,
    required List<String> items,
  }) {
    return Container(
      padding: EdgeInsets.all(14 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.8),
        border: Border.all(
          color: headerColor.withValues(alpha: 0.35),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: 11 * s,
              color: headerColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 6 * s),
          ...items.map((item) => _bullet(s, item, headerColor)),
        ],
      ),
    );
  }

  Widget _buildRightPanel(double s) {
    return Column(
      children: [
        Expanded(
          child: _infoPanel(
            s: s,
            header: 'INTERPRETAÇÃO DOS RESULTADOS',
            headerColor: const Color(0xFF64D2FF),
            items: [
              'Saída oscila entre 0 V e 5 V, compatível com ADC',
              'Offset CC posiciona senoide no centro da faixa',
              'Componente CA é atenuada corretamente pelo divisor resistivo',
            ],
          ),
        ),
        SizedBox(height: 12 * s),
        Expanded(
          child: _infoPanel(
            s: s,
            header: 'PARÂMETROS DO MELHOR CIRCUITO',
            headerColor: const Color(0xFFFF9F0A),
            items: [
              'R1 = 1,5MΩ · R2 = 120kΩ · R3 = 82MΩ',
              'V_out_max ≈ 5,00 V',
              'V_out_min ≈ 0,02 V',
              'Potência total < 0,25 W ✓',
            ],
          ),
        ),
      ],
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 960).clamp(0.25, 2.5);

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0C1B30),
                Color(0xFF071320),
                Color(0xFF040D18),
              ],
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
                      _iv(0.0, 0.4),
                      child: Text(
                        'Análise dos Resultados',
                        style: TextStyle(
                          fontSize: 36 * s,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _fade(
                      _iv(0.1, 0.5),
                      child: Text(
                        'Sinal condicionado em tempo real  ·  V_out ∈ [0V, 5V]',
                        style: TextStyle(
                          fontSize: 12.5 * s,
                          color: const Color(0xFF7B8EA2),
                        ),
                      ),
                    ),
                    SizedBox(height: 12 * s),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 58,
                            child: _reveal(
                              widget.step >= 1,
                              _buildOscilloscope(s),
                            ),
                          ),
                          SizedBox(width: 20 * s),
                          Expanded(
                            flex: 42,
                            child: _reveal(
                              widget.step >= 2,
                              _buildRightPanel(s),
                            ),
                          ),
                        ],
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

// ── Oscilloscope CustomPainter ─────────────────────────────────────────────────

class _OscPainter extends CustomPainter {
  final double s;
  final double phase; // 0.0 → 1.0, drives the scroll

  const _OscPainter({required this.s, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    // ── Screen background ────────────────────────────────────────────────────
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(8 * s),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFF000F00));
    canvas.clipRRect(screenRect);

    // ── CRT bezel inner glow ─────────────────────────────────────────────────
    canvas.drawRRect(
      screenRect,
      Paint()
        ..color = const Color(0xFF003300).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 * s,
    );

    // ── Grid (5×5) ───────────────────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xFF00FF41).withValues(alpha: 0.08)
      ..strokeWidth = 0.5 * s;
    const divisions = 5;
    for (int i = 0; i <= divisions; i++) {
      final y = (i / divisions) * size.height;
      final x = (i / divisions) * size.width;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Center crosshairs (slightly brighter)
    final centerPaint = Paint()
      ..color = const Color(0xFF00FF41).withValues(alpha: 0.18)
      ..strokeWidth = 0.8 * s;
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), centerPaint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), centerPaint);

    // Tick marks on center lines (every 1/50 of width/height)
    final tickPaint = Paint()
      ..color = const Color(0xFF00FF41).withValues(alpha: 0.25)
      ..strokeWidth = 0.7 * s;
    for (int i = 0; i <= 50; i++) {
      final x = (i / 50) * size.width;
      canvas.drawLine(
          Offset(x, size.height / 2 - 3 * s), Offset(x, size.height / 2 + 3 * s), tickPaint);
    }
    for (int i = 0; i <= 50; i++) {
      final y = (i / 50) * size.height;
      canvas.drawLine(
          Offset(size.width / 2 - 3 * s, y), Offset(size.width / 2 + 3 * s, y), tickPaint);
    }

    // ── Scrolling sine wave ──────────────────────────────────────────────────
    // Wave equation: v(x) = 2.5 + 2.5 * sin(4*pi*xFrac - 2*pi*phase*2)
    // At phase 0→1, the wave shifts 2 full cycles = smooth continuous scroll
    final phaseOffset = phase * 4 * pi; // 2 full cycles per repeat

    final path = Path();
    const nPoints = 400;
    for (int i = 0; i <= nPoints; i++) {
      final xFrac = i / nPoints;
      final v = 2.5 + 2.5 * sin(4 * pi * xFrac - phaseOffset);
      final px = xFrac * size.width;
      final py = size.height - (v / 5.0) * size.height;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    // Draw wave with phosphor glow: wide+dim, medium, thin+bright
    final glowLayers = <(double, double)>[
      (8.0 * s, 0.06),
      (3.5 * s, 0.18),
      (1.5 * s, 0.85),
    ];
    for (final layer in glowLayers) {
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF00FF41).withValues(alpha: layer.$2)
          ..strokeWidth = layer.$1
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // ── Sweep cursor line ────────────────────────────────────────────────────
    // Cursor sweeps left→right as phase goes 0→1
    final cursorX = phase * size.width;

    final cursorWidths = <(double, double)>[
      (12.0 * s, 0.04),
      (4.0 * s, 0.12),
      (1.5 * s, 0.45),
    ];
    for (final cw in cursorWidths) {
      canvas.drawLine(
        Offset(cursorX, 0),
        Offset(cursorX, size.height),
        Paint()
          ..color = const Color(0xFF88FF88).withValues(alpha: cw.$2)
          ..strokeWidth = cw.$1,
      );
    }

    // ── Voltage labels on left edge ──────────────────────────────────────────
    final labelStyle = TextStyle(
      fontSize: 9 * s,
      color: const Color(0xFF00FF41).withValues(alpha: 0.7),
      fontFamily: 'monospace',
    );
    const voltageLabels = {
      '5V': 5.0,
      '4V': 4.0,
      '3V': 3.0,
      '2.5V': 2.5,
      '2V': 2.0,
      '1V': 1.0,
      '0V': 0.0,
    };
    for (final entry in voltageLabels.entries) {
      final y = size.height - (entry.value / 5.0) * size.height;
      final tp = TextPainter(
        text: TextSpan(text: entry.key, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4 * s, y - tp.height / 2));
    }

    // ── Trigger labels (top right corner) ────────────────────────────────────
    final trigStyle = TextStyle(
      fontSize: 8.5 * s,
      color: const Color(0xFF00FF41).withValues(alpha: 0.6),
      fontFamily: 'monospace',
    );
    const trigLabels = [
      'CH1  AC  2.5V/div',
      'TIME  10ms/div',
      'TRIG  AUTO',
    ];
    for (int i = 0; i < trigLabels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: trigLabels[i], style: trigStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - tp.width - 6 * s, 6 * s + i * (10 * s)));
    }
  }

  @override
  bool shouldRepaint(_OscPainter o) => o.phase != phase || o.s != s;
}

// ── Dot grid ──────────────────────────────────────────────────────────────────

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
