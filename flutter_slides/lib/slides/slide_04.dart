import 'package:flutter/material.dart';

class Slide04 extends StatefulWidget {
  final int step;
  const Slide04({super.key, this.step = 0});
  @override
  State<Slide04> createState() => _Slide04State();
}

class _Slide04State extends State<Slide04> with TickerProviderStateMixin {
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

  Widget _glassPanel({required double s, required Widget child}) {
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
      child: child,
    );
  }

  Widget _formulaBox({
    required double s,
    required String text,
    required Color color,
    double? fontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 10 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF041020).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8 * s),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: (fontSize ?? 14) * s,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
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
                        'Formulação do Problema',
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
    const teal = Color(0xFF00BFA5);
    const orange = Color(0xFFFF9F0A);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left panel — RMS to peak conversion
              Expanded(
                child: _reveal(
                  1,
                  _glassPanel(
                    s: s,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONVERSÃO RMS → PICO',
                          style: TextStyle(
                            color: teal,
                            fontSize: 10 * s,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 10 * s),
                        Text(
                          'Para obter o valor instantâneo máximo:',
                          style: TextStyle(
                            color: const Color(0xFF7B8EA2),
                            fontSize: 12 * s,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 12 * s),
                        _formulaBox(
                          s: s,
                          text: 'V_pico = V_RMS × √2',
                          color: teal,
                        ),
                        SizedBox(height: 12 * s),
                        Text(
                          'Para 220 V RMS:',
                          style: TextStyle(
                            color: const Color(0xFF7B8EA2),
                            fontSize: 12 * s,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 8 * s),
                        _formulaBox(
                          s: s,
                          text: 'V_pico ≈ 311,13 V',
                          color: orange,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16 * s),

              // Right panel — conditioning requirements
              Expanded(
                child: _reveal(
                  2,
                  _glassPanel(
                    s: s,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CIRCUITO CONDICIONADOR',
                          style: TextStyle(
                            color: orange,
                            fontSize: 10 * s,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 10 * s),
                        Text(
                          'A rede resistiva deve:',
                          style: TextStyle(
                            color: const Color(0xFF7B8EA2),
                            fontSize: 12 * s,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 10 * s),
                        _arrowBullet(
                          'Atenuar o sinal CA de ±311 V para ±2,5 V',
                          s,
                        ),
                        SizedBox(height: 6 * s),
                        _arrowBullet('Adicionar offset CC de +2,5 V', s),
                        SizedBox(height: 6 * s),
                        _arrowBullet('Resultado: saída entre 0 V e 5 V', s),
                        SizedBox(height: 6 * s),
                        _arrowBullet(
                          'Usar apenas resistores comerciais (R1, R2, R3)',
                          s,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12 * s),

        // Warning banner
        _reveal(
          3,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 12 * s),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9F0A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8 * s),
              border: Border.all(
                color: const Color(0xFFFF9F0A).withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFFF9F0A),
                  size: 20 * s,
                ),
                SizedBox(width: 12 * s),
                Expanded(
                  child: Text(
                    'O sinal de entrada possui semiciclos positivo (+311 V) e negativo (−311 V) — ambos devem ser mapeados para 0–5 V',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12 * s,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _arrowBullet(String text, double s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u25B8 ',
          style: TextStyle(
            color: const Color(0xFF7B8EA2),
            fontSize: 12 * s,
            height: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12 * s,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
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
