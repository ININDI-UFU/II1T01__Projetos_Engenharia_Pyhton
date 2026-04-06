import 'package:flutter/material.dart';

class Slide10 extends StatefulWidget {
  final int step;
  const Slide10({super.key, required this.step});

  @override
  State<Slide10> createState() => _Slide10State();
}

class _Slide10State extends State<Slide10> with SingleTickerProviderStateMixin {
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

  // ── Table data ────────────────────────────────────────────────────────────

  static const _headers = [
    'Base',
    '×1',
    '×10',
    '×100',
    '×1k',
    '×10k',
    '×100k',
    '×1M',
  ];

  static const _rows = [
    ['10', '10Ω', '100Ω', '1kΩ', '10kΩ', '100kΩ', '1MΩ', '10MΩ'],
    ['15', '15Ω', '150Ω', '1.5kΩ', '15kΩ', '150kΩ', '1.5MΩ', '15MΩ'],
    ['22', '22Ω', '220Ω', '2.2kΩ', '22kΩ', '220kΩ', '2.2MΩ', '22MΩ'],
    ['33', '33Ω', '330Ω', '3.3kΩ', '33kΩ', '330kΩ', '3.3MΩ', '33MΩ'],
    ['47', '47Ω', '470Ω', '4.7kΩ', '47kΩ', '470kΩ', '4.7MΩ', '47MΩ'],
    ['68', '68Ω', '680Ω', '6.8kΩ', '68kΩ', '680kΩ', '6.8MΩ', '68MΩ'],
    ['82', '82Ω', '820Ω', '8.2kΩ', '82kΩ', '820kΩ', '8.2MΩ', '82MΩ'],
    ['...', '...', '...', '...', '...', '...', '...', '...'],
  ];

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
                        'Série E24 — Resistores Comerciais',
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

  // ── Content: two columns ──────────────────────────────────────────────────

  Widget _buildContent(double s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _reveal(widget.step >= 1, _buildLeft(s))),
        SizedBox(width: 20 * s),
        Expanded(child: _reveal(widget.step >= 2, _buildRight(s))),
      ],
    );
  }

  // ── Left: table ───────────────────────────────────────────────────────────

  Widget _buildLeft(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTable(s),
        SizedBox(height: 10 * s),
        _buildBadge(s),
      ],
    );
  }

  Widget _buildTable(double s) {
    final borderColor = const Color(0xFF1E3854).withValues(alpha: 0.6);
    final bs = BorderSide(color: borderColor, width: 0.8);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8 * s),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            top: bs,
            bottom: bs,
            left: bs,
            right: bs,
            horizontalInside: bs,
            verticalInside: bs,
            borderRadius: BorderRadius.circular(8 * s),
          ),
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: const Color(0xFF2997FF).withValues(alpha: 0.15),
              ),
              children: _headers
                  .map(
                    (h) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6 * s,
                        vertical: 7 * s,
                      ),
                      child: Text(
                        h,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * s,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ..._rows.asMap().entries.map((entry) {
              final idx = entry.key;
              final row = entry.value;
              final bg = idx.isOdd
                  ? const Color(0xFF0A1828).withValues(alpha: 0.5)
                  : Colors.transparent;
              return TableRow(
                decoration: BoxDecoration(color: bg),
                children: row.asMap().entries.map((cell) {
                  final isBase = cell.key == 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4 * s,
                      vertical: 6 * s,
                    ),
                    child: Text(
                      cell.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isBase ? const Color(0xFFFF9F0A) : Colors.white,
                        fontWeight: isBase
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 10 * s,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(double s) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 9 * s),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9F0A).withValues(alpha: 0.10),
        border: Border.all(
          color: const Color(0xFFFF9F0A).withValues(alpha: 0.35),
        ),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: Text(
        'Biblioteca total: 161 resistores · Faixa: 10Ω a 82MΩ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFFF9F0A),
          fontSize: 11 * s,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Right: two info panels ────────────────────────────────────────────────

  Widget _buildRight(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _glassPanel(
          header: 'SÉRIE E24 — COMO FUNCIONA',
          headerColor: const Color(0xFF5AC8FA),
          items: const [
            '23 valores base de 10 a 82 (espaçamento logarítmico)',
            '7 décadas de ×1 até ×1M (multiplicadores)',
            'Total: 23 × 7 = 161 valores disponíveis para busca',
            'Tolerância típica: ±5%',
          ],
          s: s,
        ),
        SizedBox(height: 14 * s),
        _glassPanel(
          header: 'POR QUE SÉRIE COMERCIAL?',
          headerColor: const Color(0xFF5AC8FA),
          items: const [
            'Resistências com valores arbitrários não existem no mercado',
            'A busca garante que o circuito pode ser montado com peças reais',
            'Valores próximos são cobertos pela tolerância do componente',
          ],
          s: s,
        ),
      ],
    );
  }

  Widget _glassPanel({
    required String header,
    required Color headerColor,
    required List<String> items,
    required double s,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.6),
        border: Border.all(
          color: const Color(0xFF1E4080).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      padding: EdgeInsets.all(16 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            header,
            style: TextStyle(
              color: headerColor,
              fontSize: 11 * s,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 10 * s),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 7 * s),
              child: Text(
                '• $item',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11 * s,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
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
