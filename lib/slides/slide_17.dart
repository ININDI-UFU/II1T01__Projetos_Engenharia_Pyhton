import 'dart:js_interop';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:highlight/languages/python.dart';

// ── JS interop declarations ───────────────────────────────────────────────────

@JS('isPyodideReady')
external bool _isPyodideReady();

@JS('runPythonCode')
external JSPromise<JSAny?> _runPythonCode(JSString code);

@JS('getPyResult')
external JSString? _getPyResult();

// ─────────────────────────────────────────────────────────────────────────────
// Slide 16 — Python Interativo (Pyodide)
// Permite executar código Python diretamente no browser.
// ─────────────────────────────────────────────────────────────────────────────

class Slide16 extends StatefulWidget {
  const Slide16({super.key});

  @override
  State<Slide16> createState() => _Slide16State();
}

class _Slide16State extends State<Slide16> with SingleTickerProviderStateMixin {
  late final AnimationController _entry;
  late final CodeController _codeCtrl;
  late final ScrollController _outputScroll;

  Timer? _pollTimer;
  bool _pyodideReady = false;
  bool _running = false;
  bool _hasOutput = false;
  bool _hasError = false;
  bool _editorFullscreen = false;
  bool _outputFullscreen = false;
  String _output = '';

  // ── Código pré-carregado (notebook 05_projeto_condicionador_sinais) ────────
  static const _sample = r'''# ─────────────────────────────────────
# Condicionador de Sinais — Busca Monte Carlo
# Encontra combinações de resistores comerciais (Série E24)
# que adaptam 220 V AC para a faixa de 0–5 V.
# ─────────────────────────────────────
import math
import random
import pandas as pd

random.seed(42)

# ── 1) Parâmetros do problema ──────────────
saida_desejada = [5.0, 0.0]
entrada_rms = 220.0
max_tentativas = 8000

print(f"Saída desejada: {saida_desejada[1]} V a {saida_desejada[0]} V")
print(f"Entrada RMS   : {entrada_rms} V")
print(f"Max tentativas: {max_tentativas}")

# ── 2) Preparação do sinal de entrada ────────
if isinstance(entrada_rms, (int, float)):
    entrada_rms = [entrada_rms, -entrada_rms]

entrada_pico = [v * math.sqrt(2) for v in entrada_rms]
print(f"Entrada pico  : {entrada_pico[0]:.2f} V  /  {entrada_pico[1]:.2f} V")

# ── 3) Resistores comerciais (Série E24) ──────
valores_base = [10, 11, 12, 13, 15, 16, 18, 20, 22, 24, 27,
                30, 33, 36, 39, 43, 47, 51, 56, 62, 68, 75, 82]
decadas = [1, 10, 100, 1_000, 10_000, 100_000, 1_000_000]
resistores_comerciais = [b * d for b in valores_base for d in decadas]
print(f"Resistores disponíveis: {len(resistores_comerciais)}")

# ────────── 4) Funções auxiliares ──────────
def paralelo(r1, r2):
    return (r1 * r2) / (r1 + r2)

def calcular_ganho_ca_real(r1, r2, r3):
    r1r2 = paralelo(r1, r2)
    return r1r2 / (r3 + r1r2)

def calcular_offset_cc(r1, r2, r3, tensao_cc):
    r3r2 = paralelo(r3, r2)
    return (r3r2 / (r1 + r3r2)) * tensao_cc

def calcular_ganho_ca_ideal(tensao_cc, tensao_ca_pico):
    return (tensao_cc / 2.0) / tensao_ca_pico

def calcular_saida_final(valor_cc, ganho_ca, ent_pico):
    return [valor_cc + ganho_ca * ent_pico[0],
            valor_cc + ganho_ca * ent_pico[1]]

def circuito_valido(r1, r2, r3, ganho_real, gca_ideal, vout, saida_des):
    return (
        r3 < 500_000 and
        max(saida_des) / (r1 + r2) < 0.001 and
        ganho_real <= gca_ideal and
        max(vout) >= 0.90 * max(saida_des) and
        min(vout) >= 0.04 * min(saida_des)
    )

# ─────────── 5) Ganho CA ideal ───────────
ganho_ca_ideal = calcular_ganho_ca_ideal(
    tensao_cc=max(saida_desejada),
    tensao_ca_pico=max(entrada_pico)
)
print(f"Ganho CA ideal: {ganho_ca_ideal:.6f}")

# ───── 6) Busca aleatória (Monte Carlo) ─────
circuitos = []
registrados = set()

for _ in range(max_tentativas):
    r1 = random.choice(resistores_comerciais)
    r2 = r1
    r3 = random.choice(resistores_comerciais)

    ganho_real = calcular_ganho_ca_real(r1, r2, r3)
    valor_cc   = calcular_offset_cc(r1, r2, r3, saida_desejada[0])
    vout       = calcular_saida_final(valor_cc, ganho_real, entrada_pico)

    if circuito_valido(r1, r2, r3, ganho_real, ganho_ca_ideal, vout, saida_desejada):
        chave = (float(r1), float(r2), float(r3))
        if chave not in registrados:
            registrados.add(chave)
            circuitos.append({
                "r1_ohm": r1, "r2_ohm": r2, "r3_ohm": r3,
                "vout_max_v": max(vout), "vout_min_v": min(vout),
                "ganho_ca": ganho_real, "offset_cc_v": valor_cc,
            })

print(f"Circuitos válidos: {len(circuitos)}")

# ──────────── 7) Resultados ────────────
df = pd.DataFrame(circuitos)

if df.empty:
    print("Nenhum circuito válido encontrado.")
else:
    df = df.sort_values(
        by=["vout_max_v", "vout_min_v"], ascending=[False, False]
    ).reset_index(drop=True)
   
    print(df.round(6).to_string())
''';

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _codeCtrl = CodeController(text: _sample, language: python);
    _outputScroll = ScrollController();
    _startPyodidePoll();
  }

  void _startPyodidePoll() {
    // Check immediately in case already loaded
    _checkReady();
    // Then poll every second
    _pollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _checkReady(),
    );
  }

  void _checkReady() {
    try {
      final ready = _isPyodideReady();
      if (ready && mounted && !_pyodideReady) {
        setState(() => _pyodideReady = true);
        _pollTimer?.cancel();
      }
    } catch (_) {
      // JS not available (e.g. non-web platform)
    }
  }

  @override
  void dispose() {
    _entry.dispose();
    _codeCtrl.dispose();
    _outputScroll.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  // ── Animation helpers ─────────────────────────────────────────────────────

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

  // ── Run code ─────────────────────────────────────────────────────────────

  Future<void> _runCode() async {
    if (!_pyodideReady || _running) return;
    setState(() {
      _running = true;
      _hasOutput = false;
    });

    // Let Flutter redraw the "Executando..." state before blocking
    await Future.delayed(const Duration(milliseconds: 60));

    try {
      // Await the async JS work (loads packages + runs code)
      await _runPythonCode(_codeCtrl.fullText.toJS).toDart;
      // Result is stored in window._pyResult — read it synchronously
      final raw =
          _getPyResult()?.toDart ??
          '{"success":false,"output":"Sem resultado"}';
      final Map<String, dynamic> json = jsonDecode(raw);
      final output = json['output'] as String? ?? '';
      final success = json['success'] as bool? ?? false;

      if (mounted) {
        setState(() {
          _running = false;
          _hasError = !success;
          _hasOutput = true;
          _output = output;
        });
        // Scroll output to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_outputScroll.hasClients) {
            _outputScroll.animateTo(
              _outputScroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _running = false;
          _hasError = true;
          _hasOutput = true;
          _output = 'Erro ao chamar Pyodide: $e';
        });
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
                    _fade(_iv(0.0, 0.40), child: _buildHeader(s)),
                    SizedBox(height: 14 * s),
                    Expanded(
                      child: _fade(_iv(0.2, 0.70), child: _buildBody(s)),
                    ),
                  ],
                ),
              ),
              // ── Fullscreen editor overlay ───────────────────────────────
              if (_editorFullscreen)
                Positioned.fill(
                  child: DecoratedBox(
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
                          padding: EdgeInsets.fromLTRB(
                            36 * s,
                            22 * s,
                            36 * s,
                            14 * s,
                          ),
                          child: _buildEditor(s),
                        ),
                      ],
                    ),
                  ),
                ),
              // ── Fullscreen output overlay ───────────────────────────────
              if (_outputFullscreen)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF060E18),
                          Color(0xFF040D18),
                          Color(0xFF020A12),
                        ],
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomPaint(painter: _DotGrid(s: s)),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            36 * s,
                            22 * s,
                            36 * s,
                            14 * s,
                          ),
                          child: _buildOutput(s),
                        ),
                      ],
                    ),
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
    final readyColor = _pyodideReady
        ? const Color(0xFF30D158)
        : const Color(0xFFFF9F0A);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Python Interativo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10 * s),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 * s,
                    vertical: 3 * s,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A7BF0).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6 * s),
                    border: Border.all(
                      color: const Color(0xFF3A7BF0).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'Pyodide',
                    style: TextStyle(
                      color: const Color(0xFF79AAFF),
                      fontSize: 10 * s,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Execute código Python diretamente no browser via WebAssembly',
              style: TextStyle(
                color: const Color(0xFF8EB4D8),
                fontSize: 13 * s,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Status badge
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 7 * s),
          decoration: BoxDecoration(
            color: readyColor.withValues(alpha: 0.10),
            border: Border.all(color: readyColor.withValues(alpha: 0.45)),
            borderRadius: BorderRadius.circular(20 * s),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_pyodideReady)
                Icon(
                  Icons.check_circle_rounded,
                  color: readyColor,
                  size: 13 * s,
                )
              else
                SizedBox(
                  width: 12 * s,
                  height: 12 * s,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8 * s,
                    color: readyColor,
                  ),
                ),
              SizedBox(width: 7 * s),
              Text(
                _pyodideReady ? 'Pyodide pronto ✓' : 'Carregando Pyodide...',
                style: TextStyle(
                  color: readyColor,
                  fontSize: 11 * s,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Body (editor + output) ─────────────────────────────────────────────────

  Widget _buildBody(double s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 58, child: _buildEditor(s)),
        SizedBox(width: 16 * s),
        Expanded(flex: 42, child: _buildOutput(s)),
      ],
    );
  }

  // ── Code editor ──────────────────────────────────────────────────────────

  Widget _buildEditor(double s) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(
          color: const Color(0xFF00C7FF).withValues(alpha: 0.30),
        ),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panelHeader(
            icon: Icons.code_rounded,
            label: 'CÓDIGO PYTHON',
            color: const Color(0xFF00C7FF),
            s: s,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.copy_rounded,
                    color: Colors.white38,
                    size: 14 * s,
                  ),
                  tooltip: 'Copiar código',
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: _codeCtrl.fullText),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 26 * s,
                    minHeight: 26 * s,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _editorFullscreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white54,
                    size: 16 * s,
                  ),
                  tooltip: _editorFullscreen
                      ? 'Restaurar tamanho'
                      : 'Expandir editor',
                  onPressed: () =>
                      setState(() => _editorFullscreen = !_editorFullscreen),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 26 * s,
                    minHeight: 26 * s,
                  ),
                ),
              ],
            ),
          ),
          // Code editor with Python syntax highlighting (VS Code dark theme)
          Expanded(
            child: CodeTheme(
              data: CodeThemeData(styles: vs2015Theme),
              child: CodeField(
                controller: _codeCtrl,
                expands: true,
                background: const Color(0xFF1E1E1E),
                textStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.5 * s,
                  height: 1.65,
                ),
                padding: EdgeInsets.fromLTRB(4 * s, 10 * s, 14 * s, 8 * s),
                gutterStyle: GutterStyle(
                  width: 44 * s,
                  background: const Color(0xFF161616),
                  textStyle: TextStyle(color: Colors.white38),
                  showErrors: false,
                  showFoldingHandles: true,
                ),
              ),
            ),
          ),
          // Run button
          Padding(
            padding: EdgeInsets.fromLTRB(14 * s, 0, 14 * s, 14 * s),
            child: _buildRunButton(s),
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton(double s) {
    final canRun = _pyodideReady && !_running;
    final accent = const Color(0xFF30D158);
    return GestureDetector(
      onTap: canRun ? _runCode : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40 * s,
        decoration: BoxDecoration(
          color: canRun
              ? accent.withValues(alpha: 0.13)
              : Colors.white.withValues(alpha: 0.04),
          border: Border.all(
            color: canRun
                ? accent.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(8 * s),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_running)
              SizedBox(
                width: 13 * s,
                height: 13 * s,
                child: CircularProgressIndicator(
                  strokeWidth: 2 * s,
                  color: accent,
                ),
              )
            else
              Icon(
                Icons.play_arrow_rounded,
                color: canRun ? accent : Colors.white24,
                size: 18 * s,
              ),
            SizedBox(width: 8 * s),
            Text(
              _running
                  ? 'Executando...'
                  : !_pyodideReady
                  ? 'Aguardando Pyodide...'
                  : 'Executar',
              style: TextStyle(
                color: canRun ? accent : Colors.white30,
                fontSize: 12 * s,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Output panel ─────────────────────────────────────────────────────────

  Widget _buildOutput(double s) {
    final Color borderColor;
    if (!_hasOutput) {
      borderColor = const Color(0xFF1E3854);
    } else if (_hasError) {
      borderColor = const Color(0xFFFF453A);
    } else {
      borderColor = const Color(0xFF30D158);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF060E18),
        border: Border.all(color: borderColor.withValues(alpha: 0.40)),
        borderRadius: BorderRadius.circular(12 * s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panelHeader(
            icon: _hasError
                ? Icons.error_outline_rounded
                : Icons.terminal_rounded,
            label: _hasError ? 'ERRO' : 'SAÍDA',
            color: borderColor,
            s: s,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasOutput)
                  IconButton(
                    icon: Icon(
                      Icons.cleaning_services_rounded,
                      color: Colors.white38,
                      size: 13 * s,
                    ),
                    tooltip: 'Limpar saída',
                    onPressed: () => setState(() {
                      _output = '';
                      _hasOutput = false;
                      _hasError = false;
                    }),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 26 * s,
                      minHeight: 26 * s,
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    _outputFullscreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white54,
                    size: 16 * s,
                  ),
                  tooltip: _outputFullscreen
                      ? 'Restaurar tamanho'
                      : 'Expandir saída',
                  onPressed: () =>
                      setState(() => _outputFullscreen = !_outputFullscreen),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 26 * s,
                    minHeight: 26 * s,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _hasOutput
                ? Padding(
                    padding: EdgeInsets.all(14 * s),
                    child: Scrollbar(
                      controller: _outputScroll,
                      child: SingleChildScrollView(
                        controller: _outputScroll,
                        child: SelectableText(
                          _output,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12 * s,
                            color: _hasError
                                ? const Color(0xFFFF9898)
                                : const Color(0xFF9EE09E),
                            height: 1.65,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.terminal_rounded,
                          color: Colors.white10,
                          size: 40 * s,
                        ),
                        SizedBox(height: 10 * s),
                        Text(
                          _pyodideReady
                              ? 'Pressione  ▶ Executar  para rodar o código'
                              : 'Aguardando Pyodide carregar (~5–20 s)...',
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 11 * s,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Shared panel header ───────────────────────────────────────────────────

  Widget _panelHeader({
    required IconData icon,
    required String label,
    required Color color,
    required double s,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11 * s),
          topRight: Radius.circular(11 * s),
        ),
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.18)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13 * s),
          SizedBox(width: 7 * s),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9.5 * s,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const Spacer(),
          ?trailing,
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
