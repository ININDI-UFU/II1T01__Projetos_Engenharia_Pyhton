import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide04b — Comparação visual entre o sinal de entrada (±311 V, com harmônico)
// e o sinal condicionado (0–5 V, mesmo formato, com offset CC).
// Inserido logo após o "Contexto do Problema" para reforçar visualmente
// o que o circuito condicionador precisa fazer.
// ─────────────────────────────────────────────────────────────────────────────

class Slide04b extends StatefulWidget {
  final int step;
  const Slide04b({super.key, this.step = 0});

  @override
  State<Slide04b> createState() => _Slide04bState();
}

class _Slide04bState extends State<Slide04b> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _osc;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _osc = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _entry.dispose();
    _osc.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b) => CurvedAnimation(
    parent: _entry,
    curve: Interval(a, b, curve: Curves.easeOutCubic),
  );

  Widget _fade(
    Animation<double> anim, {
    double dy = 18,
    required Widget child,
  }) => AnimatedBuilder(
    animation: anim,
    builder: (context, _) => Opacity(
      opacity: anim.value.clamp(0.0, 1.0),
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
      scale: visible ? 1.0 : 0.92,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      child: child,
    ),
  );

  // ── Oscilloscope ───────────────────────────────────────────────────────────

  Widget _buildOscilloscope({
    required double s,
    required String title,
    required String subtitle,
    required Color traceColor,
    required Color scaleColor,
    required double vMin,
    required double vMax,
    required List<({String label, double value})> ticks,
    required double Function(double tNorm, double phase) waveFn,
    required String trigText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 6 * s),
          decoration: BoxDecoration(
            color: const Color(0xFF001A00),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10 * s),
              topRight: Radius.circular(10 * s),
            ),
            border: Border.all(color: traceColor.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 8 * s,
                height: 8 * s,
                decoration: BoxDecoration(
                  color: traceColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8 * s),
              Text(
                title,
                style: TextStyle(
                  color: traceColor.withValues(alpha: 0.9),
                  fontSize: 10 * s,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              Text(
                '∿ RUNNING',
                style: TextStyle(
                  color: traceColor.withValues(alpha: 0.55),
                  fontSize: 9 * s,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        // Sub-header (subtitle)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 4 * s),
          color: const Color(0xFF001A00).withValues(alpha: 0.55),
          child: Text(
            subtitle,
            style: TextStyle(
              color: scaleColor.withValues(alpha: 0.9),
              fontSize: 10 * s,
              fontFamily: 'monospace',
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Screen
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: traceColor.withValues(alpha: 0.3),
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
                  painter: _OscPainter(
                    s: s,
                    phase: _osc.value,
                    traceColor: traceColor,
                    scaleColor: scaleColor,
                    vMin: vMin,
                    vMax: vMax,
                    ticks: ticks,
                    waveFn: waveFn,
                    trigText: trigText,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.0, 0.4);
    final subA = _iv(0.12, 0.5);

    // Forma de onda comum: senoide fundamental + 3º harmônico (não puramente senoidal).
    // Amplitude pico ≈ 311 V (1,15·rms = 220·√2), com 18% de 3º harmônico.
    // Normalizado em [-1, +1] (aproximado).
    const double a3 = 0.18;
    // pico real do composto:
    final double normPeak = 1.0 + a3; // ≈ usado para reescalar a versão 0–5V
    double waveNorm(double tNorm, double phase) {
      // tNorm ∈ [0,1] varre 2 ciclos da fundamental
      final theta = 4 * pi * tNorm - 2 * pi * phase * 2;
      return sin(theta) - a3 * sin(3 * theta);
    }

    // Entrada: ±311 V
    double waveInput(double tNorm, double phase) =>
        311.0 * waveNorm(tNorm, phase);

    // Saída condicionada: mesma forma, mas reescalada para 0–5 V com offset 2,5 V.
    // V_out(t) = 2,5 + 2,5 · waveNorm(t) / normPeak
    double waveOutput(double tNorm, double phase) =>
        2.5 + 2.5 * waveNorm(tNorm, phase) / normPeak;

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
                      dy: -20 * s,
                      child: Text(
                        'O que o circuito precisa fazer',
                        style: TextStyle(
                          fontSize: 36 * s,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    _fade(
                      subA,
                      dy: 12 * s,
                      child: Text(
                        'Mesma forma de onda, mesma fase — apenas escalada e deslocada para a faixa segura do ADC.',
                        style: TextStyle(
                          fontSize: 12.5 * s,
                          color: const Color(0xFF7B8EA2),
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 14 * s),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Osciloscópio 1 — Entrada ±311 V
                          Expanded(
                            child: _reveal(
                              widget.step >= 0,
                              _buildOscilloscope(
                                s: s,
                                title: 'OSCILOSCÓPIO  ·  V_in (rede)',
                                subtitle:
                                    'Entrada: senoide + 3º harmônico  ·  ±311 V de pico',
                                traceColor: const Color(0xFF00FF41),
                                scaleColor: const Color(0xFF00FF41),
                                vMin: -350,
                                vMax: 350,
                                ticks: const [
                                  (label: '+311 V', value: 311),
                                  (label: '+200 V', value: 200),
                                  (label: '+100 V', value: 100),
                                  (label: '  0 V', value: 0),
                                  (label: '−100 V', value: -100),
                                  (label: '−200 V', value: -200),
                                  (label: '−311 V', value: -311),
                                ],
                                waveFn: waveInput,
                                trigText:
                                    'CH1  AC  100V/div\nTIME  5ms/div\nTRIG  AUTO',
                              ),
                            ),
                          ),
                          SizedBox(width: 18 * s),
                          // Seta indicando o condicionamento
                          _reveal(widget.step >= 1, _buildArrow(s)),
                          SizedBox(width: 18 * s),
                          // Osciloscópio 2 — Saída 0–5 V (mesma forma, com offset)
                          Expanded(
                            child: _reveal(
                              widget.step >= 1,
                              _buildOscilloscope(
                                s: s,
                                title: 'OSCILOSCÓPIO  ·  V_out (ADC)',
                                subtitle:
                                    'Saída: mesma forma  ·  0–5 V  ·  offset CC = 2,5 V',
                                traceColor: const Color(0xFF00FF41),
                                scaleColor: const Color(0xFFFF9F0A),
                                // Faixa exibida simétrica em torno de 0 V para
                                // deixar claro que o sinal está deslocado do zero.
                                vMin: -2.5,
                                vMax: 7.5,
                                ticks: const [
                                  (label: '+5,0 V', value: 5.0),
                                  (label: '+2,5 V', value: 2.5),
                                  (label: '  0 V', value: 0.0),
                                  (label: '−2,5 V', value: -2.5),
                                ],
                                waveFn: waveOutput,
                                trigText:
                                    'CH2  DC  1V/div\nTIME  5ms/div\nTRIG  AUTO',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10 * s),
                    _reveal(widget.step >= 2, _legend(s)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArrow(double s) {
    return SizedBox(
      width: 70 * s,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            size: 36 * s,
            color: const Color(0xFFFF9F0A),
          ),
          SizedBox(height: 6 * s),
          Text(
            'Condicionador',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFFF9F0A),
              fontSize: 10.3 * s,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            'atenua + offset',
            textAlign: TextAlign.center,
            style: TextStyle(color: const Color(0xFF7B8EA2), fontSize: 9.5 * s),
          ),
        ],
      ),
    );
  }

  Widget _legend(double s) {
    Widget chip(Color c, String text) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 5 * s),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20 * s),
        border: Border.all(color: c.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8 * s,
            height: 8 * s,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          SizedBox(width: 6 * s),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFFE6EEF8),
              fontSize: 11 * s,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return Wrap(
      spacing: 10 * s,
      runSpacing: 8 * s,
      children: [
        chip(const Color(0xFF00FF41), 'Forma de onda preservada (mesma fase)'),
        chip(
          const Color(0xFFFF9F0A),
          'Escala da saída em destaque · offset CC = 2,5 V',
        ),
        chip(
          const Color(0xFF64D2FF),
          'Zero ao centro nos dois osciloscópios → o offset fica evidente',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Osc Painter — desenha grade simétrica com 0 V no centro vertical.
// ─────────────────────────────────────────────────────────────────────────────

class _OscPainter extends CustomPainter {
  final double s;
  final double phase;
  final Color traceColor;
  final Color scaleColor;
  final double vMin;
  final double vMax;
  final List<({String label, double value})> ticks;
  final double Function(double tNorm, double phase) waveFn;
  final String trigText;

  const _OscPainter({
    required this.s,
    required this.phase,
    required this.traceColor,
    required this.scaleColor,
    required this.vMin,
    required this.vMax,
    required this.ticks,
    required this.waveFn,
    required this.trigText,
  });

  double _yOf(double v, Size size) {
    final frac = (v - vMin) / (vMax - vMin); // 0 (bottom) → 1 (top)
    return size.height - frac * size.height;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Fundo CRT
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(8 * s),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFF000F00));
    canvas.clipRRect(screenRect);

    // Glow interno
    canvas.drawRRect(
      screenRect,
      Paint()
        ..color = const Color(0xFF003300).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 * s,
    );

    // Grade
    final gridPaint = Paint()
      ..color = traceColor.withValues(alpha: 0.08)
      ..strokeWidth = 0.5 * s;
    const divisions = 10;
    for (int i = 0; i <= divisions; i++) {
      final y = (i / divisions) * size.height;
      final x = (i / divisions) * size.width;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Linha central horizontal = 0 V (destaque)
    final zeroY = _yOf(0, size);
    canvas.drawLine(
      Offset(0, zeroY),
      Offset(size.width, zeroY),
      Paint()
        ..color = scaleColor.withValues(alpha: 0.45)
        ..strokeWidth = 1.0 * s,
    );
    // Linha central vertical
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = traceColor.withValues(alpha: 0.18)
        ..strokeWidth = 0.8 * s,
    );

    // Ticks finos sobre o eixo zero
    final tickPaint = Paint()
      ..color = scaleColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.7 * s;
    for (int i = 0; i <= 50; i++) {
      final x = (i / 50) * size.width;
      canvas.drawLine(
        Offset(x, zeroY - 3 * s),
        Offset(x, zeroY + 3 * s),
        tickPaint,
      );
    }

    // ── Forma de onda ─────────────────────────────────────────────────────
    final path = Path();
    const nPoints = 500;
    for (int i = 0; i <= nPoints; i++) {
      final tNorm = i / nPoints;
      final v = waveFn(tNorm, phase);
      final px = tNorm * size.width;
      final py = _yOf(v, size);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    // Phosphor glow
    final glowLayers = <(double, double)>[
      (8.0 * s, 0.06),
      (3.5 * s, 0.18),
      (1.5 * s, 0.85),
    ];
    for (final layer in glowLayers) {
      canvas.drawPath(
        path,
        Paint()
          ..color = traceColor.withValues(alpha: layer.$2)
          ..strokeWidth = layer.$1
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Cursor de varredura
    final cursorX = phase * size.width;
    canvas.drawLine(
      Offset(cursorX, 0),
      Offset(cursorX, size.height),
      Paint()
        ..color = const Color(0xFF88FF88).withValues(alpha: 0.35)
        ..strokeWidth = 1.5 * s,
    );

    // ── Rótulos das escalas ───────────────────────────────────────────────
    for (final t in ticks) {
      final isZero = t.value.abs() < 1e-9;
      final y = _yOf(t.value, size);

      // Marcador horizontal sutil
      canvas.drawLine(
        Offset(0, y),
        Offset(8 * s, y),
        Paint()
          ..color = scaleColor.withValues(alpha: isZero ? 0.7 : 0.45)
          ..strokeWidth = 1.0 * s,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: t.label,
          style: TextStyle(
            fontSize: isZero ? 11 * s : 10 * s,
            color: scaleColor.withValues(alpha: isZero ? 1.0 : 0.85),
            fontFamily: 'monospace',
            fontWeight: isZero ? FontWeight.bold : FontWeight.w600,
            shadows: [
              Shadow(
                color: scaleColor.withValues(alpha: 0.6),
                blurRadius: 4 * s,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(11 * s, y - tp.height / 2));
    }

    // ── Trigger / canto superior direito ──────────────────────────────────
    final trigStyle = TextStyle(
      fontSize: 9 * s,
      color: scaleColor.withValues(alpha: 0.75),
      fontFamily: 'monospace',
      height: 1.3,
    );
    final tpTrig = TextPainter(
      text: TextSpan(text: trigText, style: trigStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    )..layout();
    tpTrig.paint(canvas, Offset(size.width - tpTrig.width - 8 * s, 8 * s));
  }

  @override
  bool shouldRepaint(_OscPainter o) =>
      o.phase != phase ||
      o.s != s ||
      o.vMin != vMin ||
      o.vMax != vMax ||
      o.traceColor != traceColor ||
      o.scaleColor != scaleColor;
}

// ─────────────────────────────────────────────────────────────────────────────

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
