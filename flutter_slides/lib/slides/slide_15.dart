import 'package:flutter/material.dart';

class Slide15 extends StatefulWidget {
  final int step;
  const Slide15({super.key, required this.step});

  @override
  State<Slide15> createState() => _Slide15State();
}

class _Slide15State extends State<Slide15> with SingleTickerProviderStateMixin {
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

  Animatable<double> _iv(double a, double b) => Tween(
    begin: 0.0,
    end: 1.0,
  ).chain(CurveTween(curve: Interval(a, b, curve: Curves.easeOut)));

  Widget _fade(Animatable<double> anim, {double? dy, required Widget child}) {
    return AnimatedBuilder(
      animation: _entry,
      builder: (context, _) {
        final t = anim.evaluate(_entry);
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (dy ?? 18) * (1 - t)),
            child: child,
          ),
        );
      },
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

  // ── Left panel: Segurança Elétrica ─────────────────────────────────────────

  Widget _dotItem(double s, String text, Color dotColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '● ',
            style: TextStyle(fontSize: 13 * s, color: dotColor, height: 1.4),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12 * s,
                color: const Color(0xFFD0E4F5),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(double s) {
    const redColor = Color(0xFFFF453A);
    return Container(
      decoration: BoxDecoration(
        color: redColor.withValues(alpha: 0.06),
        border: Border.all(color: redColor.withValues(alpha: 0.5), width: 1.5),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      padding: EdgeInsets.all(20 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ SEGURANÇA ELÉTRICA',
            style: TextStyle(
              fontSize: 15 * s,
              color: redColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16 * s),
          _dotItem(
            s,
            'Tensão de entrada: 220V CA — risco de choque letal',
            redColor,
          ),
          _dotItem(
            s,
            'Obrigatório: isolamento galvânico antes de conexão ao ADC',
            redColor,
          ),
          _dotItem(
            s,
            'Potência dos resistores deve respeitar limites físicos',
            redColor,
          ),
          _dotItem(
            s,
            'Testar com baixa tensão antes de conectar à rede',
            redColor,
          ),
        ],
      ),
    );
  }

  // ── Right panel: Próximas Etapas ───────────────────────────────────────────

  Widget _checkItem(double s, String text, Color checkColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓ ',
            style: TextStyle(
              fontSize: 13 * s,
              color: checkColor,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12 * s,
                color: const Color(0xFFD0E4F5),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(double s) {
    const greenColor = Color(0xFF30D158);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: greenColor.withValues(alpha: 0.06),
              border: Border.all(
                color: greenColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12 * s),
            ),
            padding: EdgeInsets.all(20 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚀 PRÓXIMAS ETAPAS',
                  style: TextStyle(
                    fontSize: 15 * s,
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 16 * s),
                _checkItem(
                  s,
                  'Simulação SPICE / LTSpice para validar o circuito',
                  greenColor,
                ),
                _checkItem(
                  s,
                  'Montagem em protoboard com fonte de baixa tensão',
                  greenColor,
                ),
                _checkItem(
                  s,
                  'Medição com osciloscópio para confirmar formas de onda',
                  greenColor,
                ),
                _checkItem(
                  s,
                  'Integração com microcontrolador (ADC + firmware)',
                  greenColor,
                ),
                _checkItem(s, 'Design de PCB para versão final', greenColor),
              ],
            ),
          ),
        ),
        SizedBox(height: 12 * s),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 10 * s),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8 * s),
          ),
          child: Text(
            '📚 Consulte a norma NR-10 para trabalhos com eletricidade em laboratório.',
            style: TextStyle(
              fontSize: 11.5 * s,
              color: const Color(0xFF7B8EA2),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

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
                      _iv(0.0, 0.5),
                      child: Text(
                        'Segurança Elétrica & Próximas Etapas',
                        style: TextStyle(
                          fontSize: 36 * s,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _fade(
                      _iv(0.1, 0.6),
                      child: Text(
                        '',
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
                            child: _reveal(
                              widget.step >= 1,
                              _buildLeftPanel(s),
                            ),
                          ),
                          SizedBox(width: 20 * s),
                          Expanded(
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
