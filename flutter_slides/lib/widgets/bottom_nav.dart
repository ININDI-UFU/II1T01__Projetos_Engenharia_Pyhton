import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentSlide;
  final int totalSlides;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final void Function(int) onJump;

  const BottomNavBar({
    super.key,
    required this.currentSlide,
    required this.totalSlides,
    required this.onPrev,
    required this.onNext,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentSlide + 1) / totalSlides;
    final canPrev = currentSlide > 0;
    final canNext = currentSlide < totalSlides - 1;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
        ),
      ),
      child: Column(
        children: [
          // Thin progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (_, value, _) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF30D158),
                  ),
                  minHeight: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Controls row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavArrow(
                  icon: Icons.chevron_left_rounded,
                  onTap: canPrev ? onPrev : null,
                  enabled: canPrev,
                ),
                const SizedBox(width: 12),
                _SlideDots(
                  current: currentSlide,
                  total: totalSlides,
                  onTap: onJump,
                ),
                const SizedBox(width: 12),
                _NavArrow(
                  icon: Icons.chevron_right_rounded,
                  onTap: canNext ? onNext : null,
                  enabled: canNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _NavArrow({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  State<_NavArrow> createState() => _NavArrowState();
}

class _NavArrowState extends State<_NavArrow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovering && widget.enabled ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? Colors.white.withValues(alpha: _hovering ? 0.22 : 0.10)
                      : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: widget.enabled ? (_hovering ? 0.4 : 0.2) : 0.07,
                    ),
                    width: 0.5,
                  ),
                  boxShadow: _hovering && widget.enabled
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF007AFF,
                            ).withValues(alpha: 0.3),
                            blurRadius: 14,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white.withValues(
                    alpha: widget.enabled ? 1.0 : 0.18,
                  ),
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideDots extends StatelessWidget {
  final int current;
  final int total;
  final void Function(int) onTap;

  const _SlideDots({
    required this.current,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const maxVisible = 9;
    final start = (current - maxVisible ~/ 2).clamp(
      0,
      (total - maxVisible).clamp(0, total),
    );
    final end = (start + maxVisible).clamp(0, total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (start > 0) ...[_buildFadeDot(), const SizedBox(width: 4)],
        for (int i = start; i < end; i++) ...[
          _buildDot(i),
          if (i < end - 1) const SizedBox(width: 5),
        ],
        if (end < total) ...[const SizedBox(width: 4), _buildFadeDot()],
      ],
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF007AFF)
                : Colors.white.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.7),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFadeDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
    );
  }
}
