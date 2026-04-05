import 'dart:math';
import 'package:flutter/material.dart';

class Slide06 extends StatefulWidget {
  final int step;
  const Slide06({super.key, required this.step});
  @override
  State<Slide06> createState() => _Slide06State();
}

class _Slide06State extends State<Slide06> with SingleTickerProviderStateMixin {
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

  Widget _reveal(bool visible, Widget child) {
    return AnimatedOpacity(
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
  }

  Widget _card({
    required double s,
    required bool visible,
    required String badgeNum,
    required Color labelColor,
    required String label,
    required String desc,
    required String formula,
    required String additional,
    Color? additionalColor,
  }) {
    return _reveal(
      visible,
      Container(
        margin: EdgeInsets.all(4 * s),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1929),
          borderRadius: BorderRadius.circular(10 * s),
          border: Border.all(
            color: const Color(0xFF1E3854).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(12 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24 * s,
                  height: 24 * s,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2997FF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeNum,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * s,
                    ),
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10 * s,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * s),
            Text(
              desc,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10 * s,
                height: 1.4,
              ),
            ),
            SizedBox(height: 8 * s),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12 * s,
                vertical: 6 * s,
              ),
              decoration: BoxDecoration(
                color: const Color(0x330A1E38),
                borderRadius: BorderRadius.circular(6 * s),
                border: Border.all(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                formula,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: const Color(0xFF00BCD4),
                  fontSize: 11 * s,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              additional,
              style: TextStyle(
                color: additionalColor ?? Colors.white.withValues(alpha: 0.7),
                fontSize: 9.5 * s,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _ = sqrt(2); // dart:math used
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
                        'Derivação Matemática do Circuito',
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
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _card(
                                    s: s,
                                    visible: widget.step >= 1,
                                    badgeNum: '1',
                                    labelColor: Colors.orange,
                                    label: 'ETAPA 1: CONVERSÃO RMS → PICO',
                                    desc:
                                        'O valor RMS é o valor eficaz da tensão CA senoidal. Para obter o valor de pico:',
                                    formula: 'V_pico = V_RMS × √2',
                                    additional: '220 × 1,4142 ≈ 311,13 V',
                                    additionalColor: const Color(0xFF00BCD4),
                                  ),
                                ),
                                Expanded(
                                  child: _card(
                                    s: s,
                                    visible: widget.step >= 2,
                                    badgeNum: '2',
                                    labelColor: const Color(0xFF2997FF),
                                    label:
                                        'ETAPA 2: GANHO CA — DIVISOR DE TENSÃO',
                                    desc:
                                        'Para o sinal CA, Vcc é curto-circuito. R1 e R2 ficam em paralelo:',
                                    formula: 'R1‖R2 = (R1 × R2) / (R1 + R2)',
                                    additional: 'G_CA = R1‖R2 / (R3 + R1‖R2)',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _card(
                                    s: s,
                                    visible: widget.step >= 3,
                                    badgeNum: '3',
                                    labelColor: Colors.green,
                                    label: 'ETAPA 3: OFFSET CC — NÍVEL DC',
                                    desc:
                                        'Para CC, a entrada CA é zero. O offset vem de Vcc através de R1:',
                                    formula:
                                        'V_CC = [R3‖R2 / (R1 + R3‖R2)] × Vcc',
                                    additional:
                                        'Este nível DC desloca a senoide para que o vale fique próximo de 0V.',
                                  ),
                                ),
                                Expanded(
                                  child: _card(
                                    s: s,
                                    visible: widget.step >= 4,
                                    badgeNum: '4',
                                    labelColor: Colors.red,
                                    label: 'ETAPA 4: SAÍDA FINAL COMBINADA',
                                    desc:
                                        'Superposição: somamos a componente CA atenuada com o offset CC:',
                                    formula: 'V_out = V_CC + G_CA × V_pico',
                                    additional:
                                        'Critério: 0 ≤ V_out ≤ 5V para compatibilidade com ADC.',
                                    additionalColor: Colors.green,
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
              ),
            ],
          ),
        );
      },
    );
  }
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
