import 'package:flutter/material.dart';

class Slide13 extends StatefulWidget {
  final int step;
  const Slide13({super.key, required this.step});

  @override
  State<Slide13> createState() => _Slide13State();
}

class _Slide13State extends State<Slide13> with SingleTickerProviderStateMixin {
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

  // ── Code block ─────────────────────────────────────────────────────────────

  Widget _codeLine(double s, List<TextSpan> spans) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10.5 * s,
          height: 1.65,
          color: const Color(0xFFD0E4F5),
        ),
        children: spans,
      ),
    );
  }

  Widget _buildCodeBlock(double s) {
    const orange = Color(0xFFFF9F0A);
    const cyan = Color(0xFF64D2FF);
    const green = Color(0xFF4A8A5A);
    const str = Color(0xFFFF8FA3);
    const purple = Color(0xFFBF5AF2);
    const white = Color(0xFFD0E4F5);

    TextSpan kw(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: orange),
    );
    TextSpan fn(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: cyan),
    );
    TextSpan cm(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: green, fontStyle: FontStyle.italic),
    );
    TextSpan sv(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: str),
    );
    TextSpan va(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: purple),
    );
    TextSpan w(String t) => TextSpan(
      text: t,
      style: const TextStyle(color: white),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF060E1A),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _codeLine(s, [va('circuitos_encontrados'), w(' = []')]),
            _codeLine(s, [
              kw('for'),
              w(' i '),
              kw('in'),
              w(' '),
              fn('range'),
              w('(max_tentativas):'),
            ]),
            _codeLine(s, [
              w('    r1 = '),
              fn('random.choice'),
              w('(resistores)'),
            ]),
            _codeLine(s, [
              w('    r2 = '),
              fn('random.choice'),
              w('(resistores)'),
            ]),
            _codeLine(s, [
              w('    r3 = '),
              fn('random.choice'),
              w('(resistores)'),
            ]),
            _codeLine(s, [w('')]),
            _codeLine(s, [
              w('    ganho  = '),
              fn('calcular_ganho_ca'),
              w('(r1, r2, r3)'),
            ]),
            _codeLine(s, [
              w('    offset = '),
              fn('calcular_offset_cc'),
              w('(r1, r2, r3, Vcc)'),
            ]),
            _codeLine(s, [w('    vmax   = offset + ganho * Vpico')]),
            _codeLine(s, [w('    vmin   = offset - ganho * Vpico')]),
            _codeLine(s, [w('')]),
            _codeLine(s, [
              w('    '),
              kw('if'),
              w(' '),
              fn('circuito_valido'),
              w('(r1,r2,r3,vmax,vmin):'),
            ]),
            _codeLine(s, [
              w('        circuitos_encontrados.'),
              fn('append'),
              w('({'),
            ]),
            _codeLine(s, [
              w('            '),
              sv("'R1'"),
              w(': r1, '),
              sv("'R2'"),
              w(': r2,'),
            ]),
            _codeLine(s, [w('            '), sv("'R3'"), w(': r3,')]),
            _codeLine(s, [
              w('            '),
              sv("'Vout_max'"),
              w(': vmax,'),
              cm('  # V'),
            ]),
            _codeLine(s, [w('            '), sv("'Vout_min'"), w(': vmin')]),
            _codeLine(s, [w('        })')]),
          ],
        ),
      ),
    );
  }

  // ── Left panel ─────────────────────────────────────────────────────────────

  Widget _buildLeftPanel(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔍 LOOP PRINCIPAL DE BUSCA',
          style: TextStyle(
            fontSize: 13 * s,
            color: const Color(0xFFFF9F0A),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 10 * s),
        Expanded(child: _buildCodeBlock(s)),
      ],
    );
  }

  // ── Criterion item ─────────────────────────────────────────────────────────

  Widget _criterion(double s, String title, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓',
            style: TextStyle(
              fontSize: 14 * s,
              color: const Color(0xFF30D158),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12 * s,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2 * s),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11 * s,
                    color: const Color(0xFF7B8EA2),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Right panel ────────────────────────────────────────────────────────────

  Widget _buildRightPanel(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✅ CRITÉRIOS DE VALIDAÇÃO',
          style: TextStyle(
            fontSize: 13 * s,
            color: const Color(0xFF30D158),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8 * s),
        Container(
          padding: EdgeInsets.all(14 * s),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1E38).withValues(alpha: 0.7),
            border: Border.all(
              color: const Color(0xFF30D158).withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10 * s),
          ),
          child: Column(
            children: [
              _criterion(
                s,
                'Faixa de saída',
                '0 ≤ V_out ≤ 5V (proteção do ADC)',
              ),
              Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
              _criterion(
                s,
                'Potência ≤ 0,25 W',
                'Limite de resistores 1/4W padrão',
              ),
              Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
              _criterion(
                s,
                'Corrente ≤ 10 mA',
                'Segurança e eficiência energética',
              ),
              Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
              _criterion(
                s,
                'Offset centralizado',
                'V_CC próximo de 2,5 V (metade da faixa)',
              ),
              Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
              _criterion(
                s,
                'Simetria da saída',
                'Margem positiva ≈ margem negativa',
              ),
            ],
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
                        'Busca Aleatória e Validação',
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
