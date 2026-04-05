import 'dart:math';
import 'package:flutter/material.dart';

// ── Block metadata ────────────────────────────────────────────────────────────

const _kBlocks = [
  _BlockData(
    title: 'Grandeza\nFísica',
    subtitle: 'Tensão, Corrente,\nTemperatura, Pressão',
    bg: Color(0xFF1A2D50),
    border: Color(0xFF2A4D80),
    titleColor: Color(0xFFFFFFFF),
    topLabel: '220V RMS',
    topLabelColor: Color(0xFFBBCCDD),
  ),
  _BlockData(
    title: 'Transdutor\n/ Sensor',
    subtitle: 'Converte grandeza\nem sinal elétrico',
    bg: Color(0xFF0D3040),
    border: Color(0xFF0099BB),
    titleColor: Color(0xFF00C5E8),
  ),
  _BlockData(
    title: 'Condicionador\nde Sinais',
    subtitle: 'Atenua, amplifica,\nfiltra, adiciona offset',
    bg: Color(0xFF5C2000),
    border: Color(0xFFFF6B00),
    titleColor: Color(0xFFFFFFFF),
    topLabel: '±311V pico',
    topLabelColor: Color(0xFFFF8833),
    highlighted: true,
  ),
  _BlockData(
    title: 'Conversor\nA/D (ADC)',
    subtitle: 'Converte analógico\npara digital (0–5V)',
    bg: Color(0xFF0D3020),
    border: Color(0xFF00BB55),
    titleColor: Color(0xFF00DD66),
    topLabel: '0 – 5 V',
    topLabelColor: Color(0xFF00C5A0),
  ),
  _BlockData(
    title: 'Micro-\ncontrolador',
    subtitle: 'Processa dados\ndigitais',
    bg: Color(0xFF2A1550),
    border: Color(0xFF6644CC),
    titleColor: Color(0xFF9977EE),
    topLabel: 'Bits',
    topLabelColor: Color(0xFF9977EE),
  ),
];

const _kArrowColors = [
  Color(0x66FFFFFF), // block0→1
  Color(0xCCFF6B00), // block1→2 (into condicionador)
  Color(0x9900BB55), // block2→3
  Color(0x886644CC), // block3→4
];

// ── Widget ────────────────────────────────────────────────────────────────────

class Slide02 extends StatefulWidget {
  /// 0 = title/sub visible, chain empty.
  /// 1-5 = blocks revealed one by one; 5 also shows info box.
  final int step;
  const Slide02({super.key, this.step = 0});

  @override
  State<Slide02> createState() => _Slide02State();
}

class _Slide02State extends State<Slide02> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entry.dispose();
    _pulse.dispose();
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
  }) {
    return AnimatedBuilder(
      animation: a,
      builder: (context, _) => Opacity(
        opacity: a.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, dy * (1 - a.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.00, 0.40);
    final subA = _iv(0.15, 0.55);
    final step = widget.step;
    final pulseA = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    return LayoutBuilder(builder: (context, box) {
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
            Positioned.fill(child: CustomPaint(painter: _DotGrid(s: s))),
            Padding(
              padding: EdgeInsets.fromLTRB(36 * s, 28 * s, 36 * s, 16 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title — always animates on entry
                  _fade(titleA, dy: -20.0 * s, child: Text(
                    'Cadeia de Medição',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36 * s,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  )),
                  SizedBox(height: 6 * s),
                  // Subtitle
                  _fade(subA, dy: 12.0 * s, child: Text(
                    'O transdutor converte uma grandeza física em sinal elétrico. '
                    'O condicionador adapta esse sinal para o domínio digital.',
                    style: TextStyle(
                      color: const Color(0xFF7B8EA2),
                      fontSize: 12.5 * s,
                      height: 1.4,
                    ),
                  )),
                  SizedBox(height: 12 * s),
                  // Chain — step-controlled
                  Expanded(child: _buildChain(s, step, pulseA)),
                  SizedBox(height: 8 * s),
                  // Info box — only at step 5
                  AnimatedOpacity(
                    opacity: step >= 5 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOut,
                    child: AnimatedSlide(
                      offset: step >= 5 ? Offset.zero : const Offset(0, 0.25),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOut,
                      child: _buildInfoBox(s),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Chain ──────────────────────────────────────────────────────────────────

  Widget _buildChain(double s, int step, Animation<double> pulseA) {
    return LayoutBuilder(builder: (ctx, box) {
      // Fixed flex ratio: each block = 22, each arrow = 7 → total = 138
      const bFlex = 22, aFlex = 7, total = 5 * bFlex + 4 * aFlex;

      // Reserve space for labels above and badge below (in block scale units)
      // These use bs so they scale with the block, not independently.
      // For the initial calculation, estimate bs ≈ s then refine.
      final blockW = box.maxWidth * bFlex / total;
      // Reserve ~20px label + 8px gap + 26px badge + 8px gap at scale s
      final reservedH = (20 + 8 + 26 + 8) * s;
      final blockAreaH = (box.maxHeight - reservedH).clamp(40.0, double.infinity);
      final blockSize = min(blockW, blockAreaH);
      final bs = s * (blockSize / blockW).clamp(0.0, 1.0);
      final arrowW = box.maxWidth * aFlex / total;

      // Labels, blocks and badge are stacked in a tight column,
      // then the whole group is centered vertically in the available space.
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top labels — always directly above blocks ──
            _buildLabelRow(bs, step, blockSize, arrowW),
            SizedBox(height: 8 * bs),
            // ── Blocks + arrows ──
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++) ...[
                  _animatedBlock(i, bs, step, pulseA, blockSize),
                  if (i < 4) _animatedArrow(i, bs, step, arrowW, blockSize),
                ],
              ],
            ),
            SizedBox(height: 8 * bs),
            // ── "FOCO DESTA AULA" badge — always directly below blocks ──
            _buildBadgeRow(bs, step, blockSize, arrowW),
          ],
        ),
      );
    });
  }

  Widget _buildLabelRow(double bs, int step, double blockSize, double arrowW) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++) ...[
          SizedBox(
            width: blockSize,
            child: _kBlocks[i].topLabel != null
              ? AnimatedOpacity(
                  opacity: step >= i + 1 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _kBlocks[i].topLabel!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _kBlocks[i].topLabelColor ?? Colors.white70,
                      fontSize: 10 * bs,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ),
          if (i < 4) SizedBox(width: arrowW),
        ],
      ],
    );
  }

  Widget _buildBadgeRow(double bs, int step, double blockSize, double arrowW) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++) ...[
          SizedBox(
            width: blockSize,
            child: i == 2
              ? Center(
                  child: AnimatedOpacity(
                    opacity: step >= 3 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: AnimatedSlide(
                      offset: step >= 3 ? Offset.zero : const Offset(0, -0.5),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * bs,
                          vertical: 3 * bs,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          borderRadius: BorderRadius.circular(4 * bs),
                        ),
                        child: Text(
                          'FOCO DESTA AULA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8 * bs,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ),
          if (i < 4) SizedBox(width: arrowW),
        ],
      ],
    );
  }

  // ── Animated block ─────────────────────────────────────────────────────────

  Widget _animatedBlock(
    int i,
    double bs,
    int step,
    Animation<double> pulseA,
    double blockSize,
  ) {
    final visible = step >= i + 1;
    return SizedBox(
      width: blockSize,
      height: blockSize,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: visible ? 1.0 : 0.65,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          child: i == 2
            ? AnimatedBuilder(
                animation: pulseA,
                builder: (ctx, _) =>
                  _buildBlock(_kBlocks[i], bs, blockSize, pulseA.value),
              )
            : _buildBlock(_kBlocks[i], bs, blockSize, 0.0),
        ),
      ),
    );
  }

  // ── Animated arrow ─────────────────────────────────────────────────────────

  Widget _animatedArrow(int i, double bs, int step, double arrowW, double blockSize) {
    // Arrow appears together with its destination block (i+1)
    final visible = step >= i + 2;
    return SizedBox(
      width: arrowW,
      height: blockSize,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: CustomPaint(
          painter: _StaticArrow(arrowW: arrowW, color: _kArrowColors[i]),
        ),
      ),
    );
  }

  // ── Block widget ───────────────────────────────────────────────────────────

  Widget _buildBlock(_BlockData d, double bs, double blockSize, double pulse) {
    final radius = blockSize * 0.09;
    return Container(
      margin: EdgeInsets.all(bs * 2),
      decoration: BoxDecoration(
        color: d.bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: d.highlighted
            ? d.border.withValues(alpha: 0.50 + 0.45 * pulse)
            : d.border.withValues(alpha: 0.45),
          width: d.highlighted ? 2.0 * bs : 1.0 * bs,
        ),
        boxShadow: d.highlighted
          ? [
              BoxShadow(
                color: d.border.withValues(alpha: 0.20 + 0.18 * pulse),
                blurRadius: 18 * bs,
                spreadRadius: 2 * bs,
              ),
            ]
          : [
              BoxShadow(
                color: d.border.withValues(alpha: 0.10),
                blurRadius: 8 * bs,
              ),
            ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            d.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: d.titleColor,
              fontSize: 12 * bs,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6 * bs),
          Text(
            d.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 9.5 * bs,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Info box ───────────────────────────────────────────────────────────────

  Widget _buildInfoBox(double s) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 9 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E38).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10 * s),
        border: Border.all(
          color: const Color(0xFF1E4080).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TIPOS COMUNS DE TRANSDUTORES',
            style: TextStyle(
              color: const Color(0xFF00BCD4),
              fontSize: 9.5 * s,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4 * s),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 11 * s,
                height: 1.5,
              ),
              children: const [
                TextSpan(
                  text: 'Termopar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' (temperatura)  •  '),
                TextSpan(
                  text: 'Strain Gauge',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' (deformação)  •  '),
                TextSpan(
                  text: 'TC/TP',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' (corrente/tensão)  •  '),
                TextSpan(
                  text: 'LDR/Fotodiodo',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' (luminosidade)  •  '),
                TextSpan(
                  text: 'Acelerômetro',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' (vibração)'),
              ],
            ),
          ),
          SizedBox(height: 3 * s),
          Text(
            'Neste projeto: a rede elétrica (220V AC) é o próprio sinal de entrada '
            '— o condicionador é o foco principal.',
            style: TextStyle(
              color: const Color(0xFF00BCD4),
              fontSize: 10 * s,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Block data ────────────────────────────────────────────────────────────────

class _BlockData {
  final String title;
  final String subtitle;
  final Color bg;
  final Color border;
  final Color titleColor;
  final String? topLabel;
  final Color? topLabelColor;
  final bool highlighted;

  const _BlockData({
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.border,
    required this.titleColor,
    this.topLabel,
    this.topLabelColor,
    this.highlighted = false,
  });
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

// ── Static Arrow ──────────────────────────────────────────────────────────────

class _StaticArrow extends CustomPainter {
  final double arrowW;
  final Color color;

  const _StaticArrow({required this.arrowW, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final headH = (arrowW * 0.20).clamp(4.0, 16.0);
    final headW = headH * 1.3;
    final strokeW = (arrowW * 0.045).clamp(1.0, 3.0);

    // Line body
    canvas.drawLine(
      Offset(0, cy),
      Offset(size.width - headW, cy),
      Paint()
        ..color = color
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round,
    );

    // Filled arrowhead
    final path = Path()
      ..moveTo(size.width, cy)
      ..lineTo(size.width - headW, cy - headH)
      ..lineTo(size.width - headW, cy + headH)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_StaticArrow o) => o.color != color || o.arrowW != arrowW;
}
