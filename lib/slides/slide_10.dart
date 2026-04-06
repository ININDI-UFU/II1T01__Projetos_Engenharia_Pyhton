import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Slide 09 - Arquitetura do Software
// max step: 3  (Entrada -> Processamento -> Saida)
// step=0 -> layer frames visible (skeleton), content hidden
// step=1 -> ENTRADA content revealed
// step=2 -> PROCESSAMENTO content + arrow 1->2
// step=3 -> SAIDA content + arrow 2->3
// ---------------------------------------------------------------------------

class Slide09 extends StatefulWidget {
  final int step;
  const Slide09({super.key, required this.step});

  @override
  State<Slide09> createState() => _Slide09State();
}

class _Slide09State extends State<Slide09> with SingleTickerProviderStateMixin {
  late final AnimationController _entry;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
  }) => AnimatedBuilder(
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
    duration: const Duration(milliseconds: 450),
    curve: Curves.easeOut,
    child: AnimatedScale(
      scale: visible ? 1.0 : 0.92,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      child: child,
    ),
  );

  // -- Build -----------------------------------------------------------------

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
                padding: EdgeInsets.fromLTRB(36 * s, 22 * s, 36 * s, 18 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fade(
                      _iv(0.0, 0.35),
                      child: Text(
                        'Arquitetura do Software',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32 * s,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 14 * s),
                    Expanded(child: _buildLayers(s)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -- Layers ----------------------------------------------------------------

  Widget _buildLayers(double s) {
    const cyan = Color(0xFF00C7FF);
    const orange = Color(0xFFFF9F0A);
    const green = Color(0xFF30D158);

    return Column(
      children: [
        // -- ENTRADA --
        Expanded(
          flex: 22,
          child: _layerShell(
            label: 'ENTRADA',
            sublabel: 'Par\u00e2metros',
            color: cyan,
            visible: widget.step >= 1,
            s: s,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _paramBox(
                    'entrada_rms = 220.0\nsaida_desejada = [5.0, 0.0]',
                    cyan,
                    s,
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  child: _paramBox(
                    'max_tentativas = 8000\nrandom.seed(42)',
                    cyan,
                    s,
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  child: _paramBox(
                    'resistores_comerciais[]\n161 valores (E24 \u00d7 d\u00e9cadas)',
                    cyan,
                    s,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Arrow 1->2
        _vArrow(widget.step >= 2, s),

        // -- PROCESSAMENTO --
        Expanded(
          flex: 40,
          child: _layerShell(
            label: 'PROCESSAMENTO',
            sublabel: 'Fun\u00e7\u00f5es Core',
            color: orange,
            visible: widget.step >= 2,
            s: s,
            content: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _funcBox(
                          'gerar_resistores()',
                          'S\u00e9rie base \u00d7 d\u00e9cadas',
                          const Color(0xFF2997FF),
                          s,
                        ),
                      ),
                      _hArrow(const Color(0xFF2997FF), s),
                      Expanded(
                        child: _funcBox(
                          'calcular_ganho_ca()',
                          'R1\u2016R2 / (R3 + R1\u2016R2)',
                          orange,
                          s,
                        ),
                      ),
                      _hArrow(orange, s),
                      Expanded(
                        child: _funcBox(
                          'calcular_offset_cc()',
                          '(R3\u2016R2 / (R1+R3\u2016R2)) \u00d7\nVcc',
                          const Color(0xFF5AC8FA),
                          s,
                        ),
                      ),
                      _hArrow(green, s),
                      Expanded(
                        child: _funcBox(
                          'circuito_valido()',
                          '5 crit\u00e9rios',
                          green,
                          s,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6 * s),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * s,
                    vertical: 8 * s,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E38).withValues(alpha: 0.80),
                    borderRadius: BorderRadius.circular(6 * s),
                    border: Border.all(color: orange.withValues(alpha: 0.30)),
                  ),
                  child: Text(
                    'Loop: 8000 itera\u00e7\u00f5es \u2014 sorteio aleat\u00f3rio (Monte Carlo) com seed para reprodutibilidade',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF8EB4D8),
                      fontSize: 10 * s,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Arrow 2->3
        _vArrow(widget.step >= 3, s),

        // -- SAIDA --
        Expanded(
          flex: 22,
          child: _layerShell(
            label: 'SA\u00cdDA',
            sublabel: 'Resultados',
            color: green,
            visible: widget.step >= 3,
            s: s,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _saidaBox(
                    'pd.DataFrame()',
                    'circuitos_encontrados',
                    green,
                    s,
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  child: _saidaBox(
                    'sort_values()',
                    'Vout_max descrescente',
                    green,
                    s,
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  child: _saidaBox('display()', 'Tabela formatada', green, s),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -- Layer shell -----------------------------------------------------------

  Widget _layerShell({
    required String label,
    required String sublabel,
    required Color color,
    required bool visible,
    required double s,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      padding: EdgeInsets.all(8 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 80 * s,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 9 * s,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4 * s),
                  Text(
                    sublabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.60),
                      fontSize: 8 * s,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(color: color.withValues(alpha: 0.20), width: 16 * s),
          Expanded(child: _reveal(visible, content)),
        ],
      ),
    );
  }

  // -- Param box (ENTRADA) ---------------------------------------------------

  Widget _paramBox(String text, Color color, double s) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(8 * s),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9 * s,
            height: 1.6,
            color: const Color(0xFFFFB347),
          ),
        ),
      ),
    );
  }

  // -- Func box (PROCESSAMENTO) ----------------------------------------------

  Widget _funcBox(String name, String desc, Color color, double s) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.50)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      padding: EdgeInsets.all(8 * s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8.5 * s,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4 * s),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8 * s,
              height: 1.3,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ],
      ),
    );
  }

  // -- Saida box -------------------------------------------------------------

  Widget _saidaBox(String name, String desc, Color color, double s) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.40)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9.5 * s,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4 * s),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.5 * s,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // -- Vertical arrow between layers -----------------------------------------

  Widget _vArrow(bool visible, double s) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 380),
      child: SizedBox(
        height: 20 * s,
        child: Center(
          child: Icon(
            Icons.arrow_downward_rounded,
            color: const Color(0xFF8EB4D8).withValues(alpha: 0.6),
            size: 20 * s,
          ),
        ),
      ),
    );
  }

  // -- Horizontal arrow between func boxes -----------------------------------

  Widget _hArrow(Color color, double s) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2 * s),
      child: Center(
        child: Icon(
          Icons.arrow_forward_rounded,
          color: color.withValues(alpha: 0.7),
          size: 14 * s,
        ),
      ),
    );
  }
}

// -- Dot Grid ----------------------------------------------------------------

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
