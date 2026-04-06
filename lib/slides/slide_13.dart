import 'package:flutter/material.dart';

class Slide12 extends StatefulWidget {
  final int step;
  const Slide12({super.key, required this.step});

  @override
  State<Slide12> createState() => _Slide12State();
}

class _Slide12State extends State<Slide12> with SingleTickerProviderStateMixin {
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

  Widget _card({
    required double s,
    required Color borderColor,
    required String name,
    required String desc,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1E38).withValues(alpha: 0.8),
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          borderRadius: BorderRadius.circular(10 * s),
        ),
        padding: EdgeInsets.all(14 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11 * s,
                color: borderColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6 * s),
            Text(
              desc,
              style: TextStyle(
                fontSize: 11 * s,
                color: const Color(0xFFB0C4D8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 960).clamp(0.25, 2.5);

        final row1 = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              s: s,
              borderColor: const Color(0xFFFF9F0A),
              name: 'calcular_ganho_ca(R1,R2,R3)',
              desc:
                  'Paralelo de R1 e R2, depois divisor com R3. Retorna o fator de atenuação CA.',
            ),
            SizedBox(width: 12 * s),
            _card(
              s: s,
              borderColor: const Color(0xFF2997FF),
              name: 'calcular_offset_cc(R1,R2,R3,Vcc)',
              desc:
                  'Paralelo de R3 e R2, depois divisor com R1. Retorna o nível DC do offset.',
            ),
            SizedBox(width: 12 * s),
            _card(
              s: s,
              borderColor: const Color(0xFF30D158),
              name: 'circuito_valido(R1,R2,R3,...)',
              desc:
                  'Verifica 5 critérios: faixa de saída, potência, corrente, offset e simetria.',
            ),
          ],
        );

        final row2 = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              s: s,
              borderColor: const Color(0xFFBF5AF2),
              name: 'formatar_resistor(valor)',
              desc:
                  'Transforma valor numérico em string legível: kΩ, MΩ com prefixo SI.',
            ),
            SizedBox(width: 12 * s),
            _card(
              s: s,
              borderColor: const Color(0xFF64D2FF),
              name: 'calcular_saida(R1,R2,R3,...)',
              desc:
                  'Calcula Vout_max e Vout_min combinando ganho CA + offset CC.',
            ),
            SizedBox(width: 12 * s),
            _card(
              s: s,
              borderColor: const Color(0xFFFF453A),
              name: 'busca_aleatoria(tentativas)',
              desc:
                  'Loop principal: sorteia, calcula, valida e armazena os circuitos válidos.',
            ),
          ],
        );

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
                        'Funções Auxiliares',
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
                      child: Column(
                        children: [
                          Expanded(child: _reveal(widget.step >= 1, row1)),
                          SizedBox(height: 8 * s),
                          Expanded(child: _reveal(widget.step >= 2, row2)),
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
