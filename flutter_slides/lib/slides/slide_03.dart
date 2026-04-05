import 'package:flutter/material.dart';

class Slide03 extends StatefulWidget {
  final int step;
  const Slide03({super.key, this.step = 0});
  @override
  State<Slide03> createState() => _Slide03State();
}

class _Slide03State extends State<Slide03> with TickerProviderStateMixin {
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

  Widget _card({
    required double s,
    required Color border,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(20 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(color: border.withValues(alpha: 0.7), width: 1.5),
        boxShadow: [
          BoxShadow(color: border.withValues(alpha: 0.12), blurRadius: 16 * s),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.00, 0.40);
    final subA = _iv(0.15, 0.55);
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
                        'Contexto do Problema',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36 * s,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    _fade(
                      subA,
                      dy: 12.0 * s,
                      child: Text(
                        'Adaptar um sinal de alta tensão para uma faixa segura de leitura digital usando uma rede resistiva.',
                        style: TextStyle(
                          color: const Color(0xFF7B8EA2),
                          fontSize: 12.5 * s,
                          height: 1.4,
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
    const green = Color(0xFF30D158);
    const red = Color(0xFFFF453A);

    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card 1 — ENTRADA
          Expanded(
            flex: 5,
            child: _reveal(
              1,
              _card(
                s: s,
                border: orange,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ENTRADA',
                      style: TextStyle(
                        color: orange,
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8 * s),
                    Text(
                      '220 V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48 * s,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    Text(
                      'RMS (tensão alternada\nda rede elétrica)',
                      style: TextStyle(
                        color: const Color(0xFF7B8EA2),
                        fontSize: 12 * s,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Arrow 1 — visible when card 2 is visible
          Expanded(
            flex: 2,
            child: _reveal(2, _ArrowWidget(color: teal, s: s)),
          ),

          // Card 2 — SAÍDA DESEJADA
          Expanded(
            flex: 5,
            child: _reveal(
              2,
              _card(
                s: s,
                border: green,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAÍDA DESEJADA',
                      style: TextStyle(
                        color: green,
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8 * s),
                    Text(
                      '0 a 5 V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48 * s,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    Text(
                      'Faixa compatível com\ndispositivo digital (ADC)',
                      style: TextStyle(
                        color: const Color(0xFF7B8EA2),
                        fontSize: 12 * s,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Arrow 2 — visible when card 3 is visible
          Expanded(
            flex: 2,
            child: _reveal(3, _ArrowWidget(color: teal, s: s)),
          ),

          // Card 3 — ESTRATÉGIA
          Expanded(
            flex: 5,
            child: _reveal(
              3,
              _card(
                s: s,
                border: red,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTRATÉGIA',
                      style: TextStyle(
                        color: red,
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8 * s),
                    Text(
                      'Rede Resistiva',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20 * s,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 10 * s),
                    _bullet('Atenuar componente CA', s),
                    SizedBox(height: 4 * s),
                    _bullet('Introduzir offset CC', s),
                    SizedBox(height: 4 * s),
                    _bullet('Manter saída na faixa', s),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text, double s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
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

// ── Arrow Widget ───────────────────────────────────────────────────────────────

class _ArrowWidget extends StatelessWidget {
  final Color color;
  final double s;
  const _ArrowWidget({required this.color, required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(40 * s, 24 * s),
        painter: _ArrowPainter(color: color),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  const _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final arrowW = size.width * 0.35;

    canvas.drawLine(Offset(0, midY), Offset(size.width - arrowW, midY), line);

    final path = Path()
      ..moveTo(size.width, midY)
      ..lineTo(size.width - arrowW, midY - size.height * 0.4)
      ..lineTo(size.width - arrowW, midY + size.height * 0.4)
      ..close();
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(_ArrowPainter o) => o.color != color;
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
