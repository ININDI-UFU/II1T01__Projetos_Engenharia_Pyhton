import 'package:flutter/material.dart';

class Slide11 extends StatefulWidget {
  final int step;
  const Slide11({super.key, required this.step});

  @override
  State<Slide11> createState() => _Slide11State();
}

class _Slide11State extends State<Slide11> with SingleTickerProviderStateMixin {
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

  // ── Syntax highlight colours ──────────────────────────────────────────────

  static const _kw = Color(0xFFFF7B72); // keywords
  static const _cmt = Color(0xFF8B949E); // comments
  static const _num = Color(0xFF79C0FF); // numbers
  static const _reg = Color(0xFFE0E0E0); // regular code

  // ── Left code: imports & constants ───────────────────────────────────────

  List<InlineSpan> _leftSpans(double s) {
    ts(String t, Color c) => TextSpan(
      text: t,
      style: TextStyle(
        color: c,
        fontFamily: 'monospace',
        fontSize: 11 * s,
        height: 1.6,
      ),
    );
    return [
      ts('import', _kw),
      ts(' random\n', _reg),
      ts('import', _kw),
      ts(' math\n', _reg),
      ts('import', _kw),
      ts(' pandas ', _reg),
      ts('as', _kw),
      ts(' pd\n\n', _reg),
      ts('# Parâmetros de entrada\n', _cmt),
      ts('entrada_rms    = ', _reg),
      ts('220.0', _num),
      ts('\n', _reg),
      ts('saida          = [', _reg),
      ts('5.0', _num),
      ts(', ', _reg),
      ts('0.0', _num),
      ts(']\n', _reg),
      ts('Vcc            = ', _reg),
      ts('5.0', _num),
      ts('\n', _reg),
      ts('max_tentativas = ', _reg),
      ts('8000', _num),
      ts('\n', _reg),
      ts('random', _reg),
      ts('.seed(', _reg),
      ts('42', _num),
      ts(')\n', _reg),
    ];
  }

  // ── Right code: gerar_resistores ─────────────────────────────────────────

  List<InlineSpan> _rightSpans(double s) {
    ts(String t, Color c) => TextSpan(
      text: t,
      style: TextStyle(
        color: c,
        fontFamily: 'monospace',
        fontSize: 11 * s,
        height: 1.6,
      ),
    );
    return [
      ts('def', _kw),
      ts(' gerar_resistores():\n', _reg),
      ts('    bases_e24 = [\n', _reg),
      ts('        ', _reg),
      ts('10', _num),
      ts(', ', _reg),
      ts('11', _num),
      ts(', ', _reg),
      ts('12', _num),
      ts(', ', _reg),
      ts('13', _num),
      ts(', ', _reg),
      ts('15', _num),
      ts(',\n', _reg),
      ts('        ', _reg),
      ts('16', _num),
      ts(', ', _reg),
      ts('18', _num),
      ts(', ', _reg),
      ts('20', _num),
      ts(', ', _reg),
      ts('22', _num),
      ts(', ', _reg),
      ts('24', _num),
      ts(',\n', _reg),
      ts('        ', _reg),
      ts('27', _num),
      ts(', ', _reg),
      ts('30', _num),
      ts(', ', _reg),
      ts('33', _num),
      ts(', ', _reg),
      ts('36', _num),
      ts(', ', _reg),
      ts('39', _num),
      ts(',\n', _reg),
      ts('        ', _reg),
      ts('43', _num),
      ts(', ', _reg),
      ts('47', _num),
      ts(', ', _reg),
      ts('51', _num),
      ts(', ', _reg),
      ts('56', _num),
      ts(', ', _reg),
      ts('62', _num),
      ts(',\n', _reg),
      ts('        ', _reg),
      ts('68', _num),
      ts(', ', _reg),
      ts('75', _num),
      ts(', ', _reg),
      ts('82', _num),
      ts('\n', _reg),
      ts('    ]\n', _reg),
      ts('    decadas = [', _reg),
      ts('1', _num),
      ts(', ', _reg),
      ts('10', _num),
      ts(', ', _reg),
      ts('100', _num),
      ts(', ', _reg),
      ts('1e3', _num),
      ts(',\n', _reg),
      ts('               ', _reg),
      ts('1e4', _num),
      ts(', ', _reg),
      ts('1e5', _num),
      ts(', ', _reg),
      ts('1e6', _num),
      ts(']\n', _reg),
      ts('    return', _kw),
      ts(' [b*d ', _reg),
      ts('for', _kw),
      ts(' b ', _reg),
      ts('in', _kw),
      ts(' bases_e24\n', _reg),
      ts('                  ', _reg),
      ts('for', _kw),
      ts(' d ', _reg),
      ts('in', _kw),
      ts(' decadas]\n', _reg),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.00, 0.40);
    final subA = _iv(0.15, 0.55);

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
                        'Implementação em Python',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28 * s,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _fade(
                      subA,
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 16 * s,
                          color: const Color(0xFF8EB4D8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12 * s),
                    Expanded(child: _buildContent(s)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(double s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _reveal(widget.step >= 1, _buildLeft(s))),
        SizedBox(width: 20 * s),
        Expanded(child: _reveal(widget.step >= 2, _buildRight(s))),
      ],
    );
  }

  // ── Left column ───────────────────────────────────────────────────────────

  Widget _buildLeft(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionLabel(
          '📄 IMPORTAÇÕES & CONSTANTES',
          const Color(0xFFFF9F0A),
          s,
        ),
        SizedBox(height: 8 * s),
        _codeBlock(_leftSpans(s), s),
      ],
    );
  }

  // ── Right column ──────────────────────────────────────────────────────────

  Widget _buildRight(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionLabel('⚡ GERAÇÃO DE RESISTORES', const Color(0xFF2997FF), s),
        SizedBox(height: 8 * s),
        _codeBlock(_rightSpans(s), s),
      ],
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, Color color, double s) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 11 * s,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _codeBlock(List<InlineSpan> spans, double s) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050D1A),
        border: Border.all(
          color: const Color(0xFF1E3854).withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      padding: EdgeInsets.all(16 * s),
      child: RichText(text: TextSpan(children: spans)),
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
