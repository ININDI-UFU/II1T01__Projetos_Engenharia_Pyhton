import 'package:flutter/material.dart';

class Slide07 extends StatefulWidget {
  final int step;
  const Slide07({super.key, required this.step});
  @override
  State<Slide07> createState() => _Slide07State();
}

class _Slide07State extends State<Slide07> with SingleTickerProviderStateMixin {
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
  }) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, dy * (1 - anim.value)),
          child: child,
        ),
      ),
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

  Widget _stepCard(
    int num,
    IconData icon,
    Color color,
    String title,
    String desc,
    double s,
  ) {
    final visible = widget.step >= num;
    return _reveal(
      visible,
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.12),
              color.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(12 * s),
        ),
        padding: EdgeInsets.fromLTRB(16 * s, 18 * s, 16 * s, 16 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8 * s),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20 * s),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 * s,
                    vertical: 3 * s,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20 * s),
                  ),
                  child: Text(
                    '0$num',
                    style: TextStyle(
                      color: color,
                      fontSize: 11 * s,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14 * s),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * s,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8 * s),
            Expanded(
              child: Text(
                desc,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11 * s,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 10 * s),
            ClipRRect(
              borderRadius: BorderRadius.circular(2 * s),
              child: LinearProgressIndicator(
                value: 1.0,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(
                  color.withValues(alpha: 0.6),
                ),
                minHeight: 3 * s,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connector(bool visible, Color from, Color to, double s) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: SizedBox(
        width: 28 * s,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    LinearGradient(colors: [from, to]).createShader(bounds),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18 * s,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(double s) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 12 * s),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1929),
        borderRadius: BorderRadius.circular(10 * s),
        border: Border.all(
          color: const Color(0xFF1E3854).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code_rounded, color: const Color(0xFF00C7FF), size: 16 * s),
          SizedBox(width: 10 * s),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12 * s),
              children: [
                TextSpan(
                  text: '📓  Notebook estruturado para conversão via  ',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
                TextSpan(
                  text: 'nbconvert --to slides',
                  style: TextStyle(
                    color: const Color(0xFF00C7FF),
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '  →  apresentação interativa',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleA = _iv(0.0, 0.5);

    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 960).clamp(0.25, 2.5);

        const desc1 =
            'Faixa de saída (0–5 V), tensão RMS de entrada (220 V) e número máximo de tentativas Monte Carlo';
        const desc2 =
            'Expandir série base E24 × décadas de potência: lista de 161 valores comerciais disponíveis';
        const desc3 =
            'Ganho CA e offset CC para cada combinação (R1, R2, R3) sorteada aleatoriamente';
        const desc4 =
            'Validar por 5 critérios elétricos: faixa de tensão, potência máxima, resistências positivas';

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0C1B30),
                Color(0xFF071320),
                Color(0xFF040D18),
              ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estratégia Computacional',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28 * s,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4 * s),
                          Row(
                            children: [
                              Text(
                                'Pipeline de busca Monte Carlo  ·  ',
                                style: TextStyle(
                                  color: const Color(0xFF8EB4D8),
                                  fontSize: 13 * s,
                                ),
                              ),
                              Text(
                                '${widget.step > 0 ? widget.step * 25 : 0}% do pipeline revelado',
                                style: TextStyle(
                                  color: const Color(0xFF00C7FF),
                                  fontSize: 12 * s,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20 * s),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _stepCard(
                              1,
                              Icons.tune_rounded,
                              const Color(0xFF2997FF),
                              'Definir Parâmetros',
                              desc1,
                              s,
                            ),
                          ),
                          _connector(
                            widget.step >= 2,
                            const Color(0xFF2997FF),
                            const Color(0xFFBF5AF2),
                            s,
                          ),
                          Expanded(
                            child: _stepCard(
                              2,
                              Icons.memory_rounded,
                              const Color(0xFFBF5AF2),
                              'Gerar Resistores',
                              desc2,
                              s,
                            ),
                          ),
                          _connector(
                            widget.step >= 3,
                            const Color(0xFFBF5AF2),
                            const Color(0xFFFF453A),
                            s,
                          ),
                          Expanded(
                            child: _stepCard(
                              3,
                              Icons.calculate_rounded,
                              const Color(0xFFFF453A),
                              'Calcular Saídas',
                              desc3,
                              s,
                            ),
                          ),
                          _connector(
                            widget.step >= 4,
                            const Color(0xFFFF453A),
                            const Color(0xFF30D158),
                            s,
                          ),
                          Expanded(
                            child: _stepCard(
                              4,
                              Icons.filter_alt_rounded,
                              const Color(0xFF30D158),
                              'Filtrar Circuitos',
                              desc4,
                              s,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16 * s),
                    _reveal(widget.step >= 1, _buildFooter(s)),
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
