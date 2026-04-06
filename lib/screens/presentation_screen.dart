import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/fullscreen_util.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/fullscreen_button.dart';
import '../slides/slide_01.dart';
import '../slides/slide_02.dart';
import '../slides/slide_03.dart';
import '../slides/slide_04.dart';
import '../slides/slide_05.dart';
import '../slides/slide_06.dart';
import '../slides/slide_07.dart';
import '../slides/slide_08.dart';
import '../slides/slide_09.dart';
import '../slides/slide_10.dart';
import '../slides/slide_11.dart';
import '../slides/slide_12.dart';
import '../slides/slide_13.dart';
import '../slides/slide_14.dart';
import '../slides/slide_15.dart';
import '../slides/slide_16.dart';
import '../slides/slide_17.dart';

const int kTotalSlides = 17;

// Accent colors cycling per slide
const _kAccents = [
  Color(0xFF007AFF), // blue
  Color(0xFF00C7FF), // cyan
  Color(0xFF5E5CE6), // indigo
  Color(0xFF30D158), // green
  Color(0xFFFF9F0A), // orange
];

// Glow alignment positions per slide index
const _kGlowPositions = [
  Alignment.topLeft,
  Alignment.topRight,
  Alignment.bottomRight,
  Alignment.bottomLeft,
  Alignment.topCenter,
  Alignment.centerRight,
  Alignment.bottomCenter,
  Alignment.centerLeft,
  Alignment.topLeft,
  Alignment.topRight,
  Alignment.bottomRight,
  Alignment.bottomLeft,
  Alignment.topCenter,
  Alignment.centerRight,
  Alignment.bottomCenter, // 14
  Alignment.centerRight, // 15
];

class PresentationScreen extends StatefulWidget {
  final int initialSlide;
  const PresentationScreen({super.key, this.initialSlide = 0});
  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

// Max sub-steps per slide index (0 = no sub-steps).
// Ordem: 0=Slide01, 1=Slide17(Python-cos/sin), 2=Slide02, 3=Slide03, ...
int _maxSubStep(int slide) {
  const steps = {
    1: 5, // Cadeia de Medição
    2: 3, // Contexto do Problema
    3: 3, // Formulação do Problema
    4: 2, // Esquemático
    5: 4, // Derivação Matemática
    6: 4, // Estratégia Computacional
    7: 0, // Fluxograma
    8: 3, // Arquitetura do Software
    9: 2, // Série E24
    10: 2, // Implementação Python
    11: 2, // Funções Auxiliares
    12: 2, // Busca Aleatória
    13: 2, // Análise Resultados
    14: 2, // Segurança Elétrica
  };
  return steps[slide] ?? 0;
}

class _PresentationScreenState extends State<PresentationScreen>
    with TickerProviderStateMixin {
  late int _slide;
  int _subStep = 0; // current sub-step within _slide (0 = no blocks shown yet)
  bool _forward = true;
  bool _isFS = false;

  late final AnimationController _glowCtrl;
  late final AnimationController _badgeCtrl;
  late final AnimationController _cornerCtrl;

  late Animation<double> _glow1;
  late Animation<double> _glow2;
  late Animation<double> _badge;
  late Animation<double> _corner;

  @override
  void initState() {
    super.initState();
    _slide = widget.initialSlide;

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _cornerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _rebuildAnims();
    _glowCtrl.forward();
    _badgeCtrl.forward();
    _cornerCtrl.forward();

    onFullscreenChange((v) {
      if (mounted) setState(() => _isFS = v);
    });
  }

  void _rebuildAnims() {
    _glow1 = CurvedAnimation(
      parent: _glowCtrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
    );
    _glow2 = CurvedAnimation(
      parent: _glowCtrl,
      curve: const Interval(0.15, 0.8, curve: Curves.easeOutBack),
    );
    _badge = CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOutBack);
    _corner = CurvedAnimation(
      parent: _cornerCtrl,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
    );
  }

  void _handleNext() {
    final maxSub = _maxSubStep(_slide);
    if (_subStep < maxSub) {
      setState(() => _subStep++);
    } else {
      _goToSlide(_slide + 1, forward: true);
    }
  }

  void _handlePrev() {
    if (_subStep > 0) {
      setState(() => _subStep--);
    } else {
      _goToSlide(_slide - 1, forward: false);
    }
  }

  void _goToSlide(int idx, {required bool forward}) {
    if (idx < 0 || idx >= kTotalSlides) return;
    setState(() {
      _forward = forward;
      _slide = idx;
      // Going backward → start at last sub-step (all revealed).
      // Going forward → start at 0 (nothing revealed yet).
      _subStep = forward ? 0 : _maxSubStep(idx);
    });
    _restartSlideAnims();
    // Update URL to reflect current slide number (1-based)
    _updateUrl(idx);
  }

  void _updateUrl(int idx) {
    final uri = '/${idx + 1}';
    // Use replaceRoute so back-button isn't polluted
    Navigator.of(context).pushReplacementNamed(uri);
  }

  // Jump from dots/external — treat as forward if idx > _slide
  void _goTo(int idx) {
    if (idx < 0 || idx >= kTotalSlides || idx == _slide) return;
    _goToSlide(idx, forward: idx > _slide);
  }

  void _restartSlideAnims() {
    _glowCtrl.reset();
    _badgeCtrl.reset();
    _cornerCtrl.reset();
    _rebuildAnims();
    _glowCtrl.forward();
    _badgeCtrl.forward();
    _cornerCtrl.forward();
  }

  Future<void> _toggleFS() async {
    await toggleFullscreen();
    if (mounted) setState(() => _isFS = isFullscreen);
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight ||
        k == LogicalKeyboardKey.arrowDown ||
        k == LogicalKeyboardKey.space) {
      _handleNext();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.arrowUp) {
      _handlePrev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape && _isFS) {
      _toggleFS();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyF) {
      _toggleFS();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _badgeCtrl.dispose();
    _cornerCtrl.dispose();
    super.dispose();
  }

  Color get _accent => _kAccents[_slide % _kAccents.length];
  Color get _accent2 => _kAccents[(_slide + 2) % _kAccents.length];

  @override
  Widget build(BuildContext context) {
    final slide = _slide;
    final fwd = _forward;
    final sub = _subStep;

    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Animated radial background
            _buildBg(),

            // Animated glow orbs (behind slide)
            _buildGlows(),

            // Main slide (AnimatedSwitcher)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 80,
              child: _buildSlides(slide, fwd, sub),
            ),

            // Corner accent brackets
            _buildCornerAccents(),

            // Badge top-left
            Positioned(top: 20, left: 20, child: _buildBadge()),

            // Fullscreen button top-right
            Positioned(
              top: 20,
              right: 20,
              child: FullscreenButton(isFullscreen: _isFS, onTap: _toggleFS),
            ),

            // Bottom nav
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavBar(
                currentSlide: _slide,
                totalSlides: kTotalSlides,
                onPrev: _handlePrev,
                onNext: _handleNext,
                onJump: _goTo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Background ──────────────────────────────────────────────────────────────

  Widget _buildBg() {
    final centers = [
      const Alignment(-0.7, -0.5),
      const Alignment(0.6, -0.4),
      const Alignment(-0.2, 0.6),
      const Alignment(0.5, 0.5),
      const Alignment(0.0, -0.8),
    ];
    final center = centers[_slide % centers.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: 1.6,
          colors: [
            _accent.withValues(alpha: 0.14),
            _accent2.withValues(alpha: 0.04),
            Colors.black,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  // ── Glow Orbs ───────────────────────────────────────────────────────────────

  Widget _buildGlows() {
    final pos1 = _kGlowPositions[_slide];
    final pos2 = _kGlowPositions[(_slide + 4) % _kGlowPositions.length];

    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (context, _) {
        final t1 = _glow1.value;
        final t2 = _glow2.value;
        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Primary glow
              Align(
                alignment: pos1,
                child: Opacity(
                  opacity: (t1 * 0.65).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.2 + t1 * 0.8,
                    child: _GlowBlob(color: _accent, size: 480),
                  ),
                ),
              ),
              // Secondary glow
              Align(
                alignment: pos2,
                child: Opacity(
                  opacity: (t2 * 0.45).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.2 + t2 * 0.8,
                    child: _GlowBlob(color: _accent2, size: 360),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Slide Area ──────────────────────────────────────────────────────────────

  Widget _buildSlides(int slide, bool fwd, int sub) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 780),
      transitionBuilder: (child, anim) {
        final key = child.key as ValueKey<int>;
        final incoming = key.value == slide;
        return _buildTransition(child, anim, incoming, fwd);
      },
      child: _SlideFrame(
        key: ValueKey<int>(slide),
        slideIndex: slide,
        accent: _accent,
        subStep: sub,
      ),
    );
  }

  Widget _buildTransition(
    Widget child,
    Animation<double> anim,
    bool incoming,
    bool fwd,
  ) {
    // Alternate between horizontal and diagonal transitions for variety
    final isDiag = _slide % 3 == 2;
    final dy = isDiag ? (fwd ? -0.06 : 0.06) : 0.0;

    if (incoming) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: anim, curve: const Interval(0, 0.45)),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(fwd ? 1.15 : -1.15, dy),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutQuart)),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.93, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutQuart),
            ),
            child: child,
          ),
        ),
      );
    } else {
      // Outgoing: shrink-and-slide away; the "bloom" scale gives a push feel
      return FadeTransition(
        opacity: anim, // goes 1→0
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(fwd ? -0.12 : 0.12, fwd ? dy * 0.5 : -dy * 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInQuart)),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 1.06,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInQuart)),
            child: child,
          ),
        ),
      );
    }
  }

  // ── Corner Accent Brackets ──────────────────────────────────────────────────

  Widget _buildCornerAccents() {
    return AnimatedBuilder(
      animation: _cornerCtrl,
      builder: (context, _) {
        final t = _corner.value;
        const thickness = 2.0;
        const len = 28.0;
        final color = _accent.withValues(alpha: t * 0.7);
        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Top-left bracket — slides in from top-left
              Positioned(
                top: 8 + (1 - t) * -30,
                left: 8 + (1 - t) * -30,
                child: Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: _Corner(
                    color: color,
                    thickness: thickness,
                    len: len,
                    quadrant: 0,
                  ),
                ),
              ),
              // Top-right bracket — slides in from top-right
              Positioned(
                top: 8 + (1 - t) * -30,
                right: 8 + (1 - t) * -30,
                child: Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: _Corner(
                    color: color,
                    thickness: thickness,
                    len: len,
                    quadrant: 1,
                  ),
                ),
              ),
              // Bottom-left bracket — slides in from bottom-left
              Positioned(
                bottom: 88 + (1 - t) * -30,
                left: 8 + (1 - t) * -30,
                child: Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: _Corner(
                    color: color,
                    thickness: thickness,
                    len: len,
                    quadrant: 2,
                  ),
                ),
              ),
              // Bottom-right bracket — slides in from bottom-right
              Positioned(
                bottom: 88 + (1 - t) * -30,
                right: 8 + (1 - t) * -30,
                child: Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: _Corner(
                    color: color,
                    thickness: thickness,
                    len: len,
                    quadrant: 3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Badge ───────────────────────────────────────────────────────────────────

  Widget _buildBadge() {
    return AnimatedBuilder(
      animation: _badgeCtrl,
      builder: (context, _) {
        final t = _badge.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(-20 * (1 - t), 0),
            child: _SlideBadge(
              current: _slide + 1,
              total: kTotalSlides,
              accent: _accent,
            ),
          ),
        );
      },
    );
  }
}

// ── Slide Frame ─────────────────────────────────────────────────────────────

class _SlideFrame extends StatelessWidget {
  final int slideIndex;
  final Color accent;
  final int subStep;

  const _SlideFrame({
    required super.key,
    required this.slideIndex,
    required this.accent,
    this.subStep = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (slideIndex == 0) return const Slide01();
    if (slideIndex == 1) return Slide02(step: subStep);
    if (slideIndex == 2) return Slide03(step: subStep);
    if (slideIndex == 3) return Slide04(step: subStep);
    if (slideIndex == 4) return Slide05(step: subStep);
    if (slideIndex == 5) return Slide06(step: subStep);
    if (slideIndex == 6) return Slide07(step: subStep);
    if (slideIndex == 7) return Slide08(step: subStep);
    if (slideIndex == 8) return Slide09(step: subStep);
    if (slideIndex == 9) return Slide10(step: subStep);
    if (slideIndex == 10) return Slide11(step: subStep);
    if (slideIndex == 11) return Slide12(step: subStep);
    if (slideIndex == 12) return Slide13(step: subStep);
    if (slideIndex == 13) return Slide14(step: subStep);
    if (slideIndex == 14) return Slide15(step: subStep);
    if (slideIndex == 15) return const Slide16();
    if (slideIndex == 16) return const Slide17(); // Python interativo (último)

    final path =
        'assets/pdf_slide_${(slideIndex + 1).toString().padLeft(2, '0')}.png';

    return Center(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          // Maintain 16:9 with padding
          final maxW = constraints.maxWidth - 48;
          final maxH = constraints.maxHeight - 24;
          final w = (maxH * 16 / 9 < maxW) ? maxH * 16 / 9 : maxW;
          final h = w * 9 / 16;

          return SizedBox(
            width: w,
            height: h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.75),
                    blurRadius: 70,
                    offset: const Offset(0, 30),
                    spreadRadius: -10,
                  ),
                  BoxShadow(
                    color: accent.withValues(alpha: 0.18),
                    blurRadius: 80,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFF1C1C1E),
                    child: Center(
                      child: Text(
                        'Slide ${slideIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Glow Blob ───────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: size * 0.55,
            spreadRadius: size * 0.15,
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: size * 0.9,
            spreadRadius: size * 0.3,
          ),
        ],
      ),
    );
  }
}

// ── Corner Bracket ──────────────────────────────────────────────────────────
// quadrant: 0=TL, 1=TR, 2=BL, 3=BR

class _Corner extends StatelessWidget {
  final Color color;
  final double thickness;
  final double len;
  final int quadrant;

  const _Corner({
    required this.color,
    required this.thickness,
    required this.len,
    required this.quadrant,
  });

  @override
  Widget build(BuildContext context) {
    final flipX = quadrant == 1 || quadrant == 3;
    final flipY = quadrant == 2 || quadrant == 3;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
        flipX ? -1.0 : 1.0,
        flipY ? -1.0 : 1.0,
        1.0,
      ),
      child: SizedBox(
        width: len,
        height: len,
        child: CustomPaint(
          painter: _CornerPainter(color: color, thickness: thickness),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  const _CornerPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Vertical line
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
    // Horizontal line
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.color != color || old.thickness != thickness;
}

// ── Slide Badge ─────────────────────────────────────────────────────────────

class _SlideBadge extends StatelessWidget {
  final int current;
  final int total;
  final Color accent;

  const _SlideBadge({
    required this.current,
    required this.total,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.8),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$current / $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
