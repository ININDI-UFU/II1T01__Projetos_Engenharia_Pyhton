import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Slide 09 — Arquitetura do Software
// max step: 3  (Entrada → Processamento → Saída)
// step=0 → layer frames visible (skeleton), content hidden
// step=1 → ENTRADA content revealed
// step=2 → PROCESSAMENTO content + arrow 1→2
// step=3 → SAÍDA content + arrow 2→3
// ─────────────────────────────────────────────────────────────────────────────

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

  Widget _fade(Animation<double> anim,
          {double dy = 24, required Widget child}) =>
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
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: visible ? 1.0 : 0.92,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutBack,
          child: child,
        ),
      );

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
              colors: [Color(0xFF0C1B30), Color(0xFF071320), Color(0xFF040D18)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _DotGrid(s: s)),
              Padding(
                padding: EdgeInsets.fromLTRB(36 * s, 22 * s, 36 * s, 14 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _fade(_iv(0.0, 0.35), child: _buildHeader(s)),
                    SizedBox(height: 14 * s),
                    Expanded(child: _buildPipeline(s)),
                    SizedBox(height: 10 * s),
                    _fade(_iv(0.55, 0.95), child: _buildFooter(s)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(double s) {
    const cyan = Color(0xFF00C7FF);
    const orange = Color(0xFFFF9F0A);
    const green = Color(0xFF30D158);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Arquitetura do Software',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28 * s,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Organização em camadas  ·  Entrada → Processamento → Saída',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF8EB4D8),
                  fontSize: 13 * s,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16 * s),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statBadge('3', 'CAMADAS', cyan, s),
            SizedBox(width: 8 * s),
            _statBadge('8 000', 'ITERAÇÕES', orange, s),
            SizedBox(width: 8 * s),
            _statBadge('161', 'RESISTORES', green, s),
          ],
        ),
      ],
    );
  }

  Widget _statBadge(String number, String label, Color color, double s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 6 * s),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.40)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16 * s,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 7.5 * s,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pipeline ──────────────────────────────────────────────────────────────

  Widget _buildPipeline(double s) {
    const cyan = Color(0xFF00C7FF);
    const orange = Color(0xFFFF9F0A);
    const green = Color(0xFF30D158);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Layer 1: ENTRADA ──
        Expanded(
          flex: 30,
          child: _layerShell(
            label: 'ENTRADA',
            sublabel: 'Parâmetros',
            color: cyan,
            threshold: 1,
            s: s,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _dataCard(
                      'entrada_rms', '220.0 V', 'Tensão\nAC fase', cyan, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard('saida_desejada', '[5.0, 0.0]',
                      'Vout_max /\nVout_min', cyan, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard('max_tentativas', '8 000',
                      'Iterações\nseed=42', cyan, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard('resistores[]', '161 valores',
                      'Série E24\n× décadas', cyan, s),
                ),
              ],
            ),
          ),
        ),

        // Arrow 1→2
        _flowArrow(widget.step >= 2, cyan, orange, s),

        // ── Layer 2: PROCESSAMENTO ──
        Expanded(
          flex: 38,
          child: _layerShell(
            label: 'PROCESSAMENTO',
            sublabel: 'Funções Core',
            color: orange,
            threshold: 2,
            s: s,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _funcCard(
                      'gerar_resistores()',
                      'Série E24 × décadas / 161 valores',
                      const Color(0xFF2997FF),
                      s),
                ),
                SizedBox(width: 5 * s),
                Expanded(
                  child: _funcCard('calcular_ganho_ca()',
                      'R1‖R2 / (R3 + R1‖R2)', orange, s),
                ),
                SizedBox(width: 5 * s),
                Expanded(
                  child: _funcCard('calcular_offset_cc()',
                      '(R3‖R2/(R1+R3‖R2)) × Vcc', const Color(0xFF5AC8FA), s),
                ),
                SizedBox(width: 5 * s),
                Expanded(
                  child: _funcCard(
                      'circuito_valido()', '5 critérios verificados', green, s),
                ),
              ],
            ),
          ),
        ),

        // Arrow 2→3
        _flowArrow(widget.step >= 3, orange, green, s),

        // ── Layer 3: SAÍDA ──
        Expanded(
          flex: 30,
          child: _layerShell(
            label: 'SAÍDA',
            sublabel: 'Resultados',
            color: green,
            threshold: 3,
            s: s,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _dataCard(
                      'DataFrame', 'pandas', 'Circuitos\nválidos', green, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard('sort_values()', 'Vout_max ↓',
                      'Ordenação\ndecrescente', green, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard(
                      'display()', 'Jupyter', 'Tabela\nformatada', green, s),
                ),
                SizedBox(width: 6 * s),
                Expanded(
                  child: _dataCard(
                      'export CSV', 'opcional', 'Para\nanálise', green, s),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Layer shell (always visible as skeleton) ──────────────────────────────

  Widget _layerShell({
    required String label,
    required String sublabel,
    required Color color,
    required int threshold,
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
            width: 72 * s,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6 * s, vertical: 4 * s),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6 * s),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 8.5 * s,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4 * s),
                  Text(
                    sublabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.55),
                      fontSize: 7.5 * s,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: color.withValues(alpha: 0.2),
            width: 18 * s,
          ),
          Expanded(
            child: _reveal(widget.step >= threshold, content),
          ),
        ],
      ),
    );
  }

  // ── Flow arrow between layers ─────────────────────────────────────────────

  Widget _flowArrow(bool visible, Color from, Color to, double s) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 380),
      child: SizedBox(
        height: 20 * s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_arrow_down_rounded,
                color: from.withValues(alpha: 0.7), size: 18 * s),
            SizedBox(width: 3 * s),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: Color.lerp(from, to, 0.5)!.withValues(alpha: 0.7),
                size: 18 * s),
            SizedBox(width: 3 * s),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: to.withValues(alpha: 0.7), size: 18 * s),
          ],
        ),
      ),
    );
  }

  // ── Data Card ─────────────────────────────────────────────────────────────

  Widget _dataCard(
      String label, String value, String sub, Color color, double s) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.75),
        border: Border(left: BorderSide(color: color, width: 3)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6 * s, vertical: 6 * s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8 * s,
              color: color,
            ),
          ),
          SizedBox(height: 2 * s),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12 * s,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 2 * s),
          Text(
            sub,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 7.5 * s,
              height: 1.3,
              color: const Color(0xFF8EB4D8),
            ),
          ),
        ],
      ),
    );
  }

  // ── Func Card ─────────────────────────────────────────────────────────────

  Widget _funcCard(String name, String formula, Color color, double s) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      padding: EdgeInsets.all(7 * s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8 * s,
              color: color,
            ),
          ),
          SizedBox(height: 4 * s),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6 * s, vertical: 4 * s),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1E38).withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(4 * s),
            ),
            child: Text(
              formula,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 7.5 * s,
                height: 1.3,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(double s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF6E3ABA).withValues(alpha: 0.15),
        border: Border.all(
            color: const Color(0xFF9B72D4).withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: Text(
        '🔄  Loop Monte Carlo: 8 000 iterações  ·  seed = 42  ·  '
        'sorteia R1, R2, R3 da Série E24 a cada iteração',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: const Color(0xFFCFB3F5), fontSize: 11 * s),
      ),
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
