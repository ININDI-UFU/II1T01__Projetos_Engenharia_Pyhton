# EININDI02 — Projetos de Engenharia com Python

## Instrumentação Industrial I — Universidade Federal de Uberlândia (UFU)

Repositório de materiais didáticos da disciplina **Instrumentação Industrial I (ININD1)**, ministrada na Faculdade de Engenharia Elétrica da UFU. O projeto reúne aulas práticas, simulações e projetos de engenharia desenvolvidos integralmente com **Python**, utilizando tanto o ambiente local (VSCode + Jupyter Notebook) quanto a plataforma de nuvem **Google Colaboratory (Colab)**.

O foco principal da disciplina é capacitar o estudante a resolver problemas reais de engenharia — como o projeto de **circuitos condicionadores de sinais**, a **simulação de instrumentos de medição** e a **análise computacional de sinais elétricos** — utilizando ferramentas modernas de programação e computação científica.

---

## Índice

1. [Visão Geral do Projeto](#visão-geral-do-projeto)
2. [Python como Ferramenta de Engenharia](#python-como-ferramenta-de-engenharia)
3. [Google Colab e Jupyter Notebook](#google-colab-e-jupyter-notebook)
4. [Resolução de Problemas Computacionais com Python e Colab](#resolução-de-problemas-computacionais-com-python-e-colab)
5. [Condicionadores de Sinais — Conceitos Fundamentais](#condicionadores-de-sinais--conceitos-fundamentais)
6. [Descrição dos Arquivos do Projeto](#descrição-dos-arquivos-do-projeto)
   - [01_instalLib.bat — Script de Instalação de Bibliotecas](#01_installibat--script-de-instalação-de-bibliotecas)
   - [02_aprendendo_python.py — Primeiro Contato com Python](#02_aprendendo_pythonpy--primeiro-contato-com-python)
   - [03_python_Jupyter.ipynb — Introdução ao Python e ao Jupyter Notebook](#03_python_jupyteripynb--introdução-ao-python-e-ao-jupyter-notebook)
   - [04_simulação_do_voltímetro_no_python.ipynb — Simulação de Voltímetro RMS](#04_simulação_do_voltímetro_no_pythonipynb--simulação-de-voltímetro-rms)
   - [05_projeto_condicionador_sinais.ipynb — Projeto de Condicionador de Sinais](#05_projeto_condicionador_sinaisipynb--projeto-de-condicionador-de-sinais)
   - [Teoria_quinta_01.pptx — Apresentação Teórica: Introdução ao Python](#teoria_quinta_01pptx--apresentação-teórica-introdução-ao-python)
7. [Bibliotecas Utilizadas](#bibliotecas-utilizadas)
8. [Como Executar os Materiais](#como-executar-os-materiais)
9. [Links Úteis](#links-úteis)

---

## Visão Geral do Projeto

Este repositório contém uma sequência progressiva de materiais que conduz o aluno desde os primeiros passos em Python até a resolução de problemas complexos de engenharia elétrica e instrumentação industrial. A abordagem é eminentemente prática: cada arquivo corresponde a uma etapa do aprendizado, partindo da instalação de bibliotecas, passando por conceitos fundamentais da linguagem Python, até chegar ao projeto computacional completo de um **circuito condicionador de sinais** para leitura de tensão da rede elétrica.

A metodologia privilegia o uso de **notebooks interativos** (Jupyter/Colab), nos quais o estudante pode combinar teoria (em Markdown), código executável (em Python) e resultados visuais (gráficos, tabelas) em um único documento — facilitando a compreensão, a experimentação e a documentação do trabalho de engenharia.

---

## Python como Ferramenta de Engenharia

**Python** é uma linguagem de programação de alto nível, interpretada e multiparadigma, criada por Guido van Rossum em 1991. Sua sintaxe limpa e direta a torna especialmente adequada para o meio acadêmico e para engenheiros que precisam de resultados rápidos sem sacrificar a legibilidade e a manutenibilidade do código.

No contexto da engenharia elétrica e da instrumentação industrial, Python se destaca por:

- **Computação numérica e científica**: bibliotecas como NumPy e SciPy oferecem operações vetoriais, álgebra linear, processamento de sinais e otimização com desempenho próximo ao de linguagens compiladas.
- **Visualização de dados**: Matplotlib permite a criação de gráficos de alta qualidade para análise de sinais, respostas em frequência, diagramas de Bode e muito mais.
- **Análise e manipulação de dados**: Pandas facilita a organização, filtragem e apresentação de dados tabelados — essencial ao comparar resultados de simulação ou de medição em bancada.
- **Prototipagem rápida**: a natureza interpretada do Python e seu ecossistema de bibliotecas permitem que o engenheiro implemente, teste e valide algoritmos de forma extremamente ágil.
- **Ampla comunidade e documentação**: milhões de desenvolvedores e pesquisadores contribuem com bibliotecas, tutoriais e suporte, tornando Python uma das linguagens mais acessíveis do mundo.

### Principais Recursos da Linguagem

| Recurso | Descrição |
|---------|-----------|
| Sintaxe simples e legível | Facilita o aprendizado e a leitura do código |
| Multiparadigma | Suporta programação procedural, orientada a objetos e funcional |
| Biblioteca padrão extensa | Ferramentas prontas para arquivos, redes, matemática, etc. |
| Portabilidade | Funciona em Windows, Linux e macOS |
| Ecossistema científico maduro | NumPy, SciPy, Pandas, Matplotlib, SymPy, entre outros |

---

## Google Colab e Jupyter Notebook

### Jupyter Notebook

O **Jupyter Notebook** (nome derivado de **Ju**lia + **Py**thon + **R**) é um ambiente interativo que permite a criação de documentos contendo código executável, texto rico formatado em Markdown, equações em LaTeX, imagens e visualizações gráficas — tudo em um único arquivo com extensão `.ipynb`.

Essa abordagem, conhecida como **notebook** ("caderno"), é amplamente adotada em ciência de dados, engenharia e pesquisa, pois promove a documentação natural do raciocínio ao longo do desenvolvimento do código. O engenheiro pode, no mesmo documento, explicar a teoria por trás de um problema, implementar a solução e visualizar os resultados — criando um registro completo e reprodutível do trabalho.

### Google Colaboratory (Colab)

O **Google Colab** é um serviço gratuito baseado em nuvem, hospedado pelo Google, que executa notebooks Jupyter diretamente no navegador, sem necessidade de instalação local. É especialmente útil por:

- **Acesso imediato**: não requer nenhuma configuração no computador do aluno.
- **Ambiente pré-configurado**: já vem com Python, NumPy, Pandas, Matplotlib, SciPy e diversas outras bibliotecas instaladas.
- **Recursos de hardware gratuitos**: oferece acesso a GPUs e TPUs para tarefas de maior carga computacional.
- **Compartilhamento fácil**: os notebooks podem ser compartilhados como links do Google Drive, facilitando a colaboração entre alunos e professor.
- **Compatibilidade com Jupyter**: arquivos `.ipynb` podem ser abertos e editados tanto no Colab quanto no VSCode com a extensão Jupyter.

### VSCode como Alternativa Local

O **Visual Studio Code (VSCode)** também suporta nativamente notebooks Jupyter através de extensões. O aluno pode trabalhar tanto com **código bruto** (arquivos `.py`) quanto com **notebooks interativos** (arquivos `.ipynb`), tendo a vantagem de um editor mais poderoso, com IntelliSense, depuração avançada e controle de versão integrado.

---

## Resolução de Problemas Computacionais com Python e Colab

A combinação de **Python** e **Colab/Jupyter** constitui uma plataforma extremamente poderosa para a resolução de problemas de engenharia. O fluxo de trabalho típico adotado nesta disciplina segue as etapas:

1. **Formulação do problema**: definição dos parâmetros de entrada, das grandezas conhecidas e das incógnitas. No notebook, isso é feito em células Markdown com equações em LaTeX.

2. **Modelagem matemática**: tradução do problema físico (circuito, sinal, sensor) em equações e algoritmos. Python permite implementar essas equações de forma direta, com suporte a operações vetoriais via NumPy.

3. **Implementação computacional**: desenvolvimento do código em células Python do notebook, com importação de bibliotecas, definição de funções, geração de dados e cálculos numéricos.

4. **Simulação e análise**: execução do código, geração de gráficos e tabelas para visualização dos resultados. Matplotlib e Pandas são utilizados extensivamente nesta etapa.

5. **Validação e refinamento**: comparação dos resultados com valores teóricos ou experimentais, ajuste de parâmetros e melhoria do modelo.

6. **Documentação integrada**: todo o processo fica registrado no notebook, com explicações textuais, código e resultados intercalados, formando um documento autocontido.

Essa abordagem é particularmente eficaz em problemas como:

- **Projeto de condicionadores de sinais**: busca sistemática por combinações de componentes que atendam a especificações elétricas.
- **Simulação de instrumentos de medição**: geração de sinais sintéticos, cálculo de RMS, aplicação de filtros e calibração por mínimos quadrados.
- **Análise de sinais**: decomposição espectral, filtragem, conversão de domínios (tempo/frequência) e visualização de formas de onda.

---

## Condicionadores de Sinais — Conceitos Fundamentais

Um **condicionador de sinais** é um circuito eletrônico projetado para transformar um sinal de entrada (geralmente de alta tensão, alta corrente ou com nível de ruído elevado) em um sinal de saída adequado para leitura por um sistema de aquisição de dados — tipicamente um conversor analógico-digital (ADC) com faixa de entrada entre **0 V e 5 V** (ou 0 V e 3,3 V).

### Por que condicionadores de sinais são necessários?

Na instrumentação industrial, os sinais elétricos reais frequentemente possuem níveis incompatíveis com os circuitos de medição digital:

- A tensão da rede elétrica brasileira pode ser de **127 V** ou **220 V RMS**, correspondendo a valores de pico de aproximadamente **180 V** e **311 V**, respectivamente.
- Esses valores estão muito acima da faixa de entrada de um ADC típico (0–5 V).
- Além disso, os sinais podem ser bipolares (positivos e negativos), enquanto muitos ADCs aceitam apenas sinais unipolares.

### O que o condicionador faz?

O condicionador de sinais realiza duas operações fundamentais:

1. **Atenuação (Ganho CA)**: reduz a amplitude do sinal de entrada para que a excursão de pico caiba dentro da faixa do ADC. Isso é feito por um **divisor resistivo**.

2. **Adição de offset CC**: desloca o sinal atenuado verticalmente, de forma que o semiciclo negativo não ultrapasse 0 V na saída. Isso é essencial para ADCs que não aceitam tensões negativas.

### Formulação Matemática

Para uma entrada de **220 V RMS**, o valor de pico é:

$$V_{pico} = V_{RMS} \times \sqrt{2} \approx 311{,}13\ \text{V}$$

O objetivo é encontrar resistores comerciais (R1, R2, R3) que, em uma configuração de divisor resistivo com offset, produzam uma saída entre **0 V** e **5 V**.

As equações do circuito envolvem:

- **Ganho CA real**: determinado pela associação em paralelo de R1 e R2, combinada com R3.
- **Offset CC**: determinado pela associação em paralelo de R3 e R2, combinada com R1, aplicada à tensão CC de referência.
- **Saída final**: soma do offset CC com o produto do ganho CA pela tensão de pico de entrada.

### Abordagem Computacional

O projeto computacional implementado neste repositório utiliza uma **busca aleatória (Monte Carlo)** sobre combinações de resistores comerciais, avaliando cada combinação contra critérios de validade elétrica. Essa abordagem demonstra como Python pode ser usado para resolver problemas de projeto que seriam extremamente tediosos de resolver manualmente.

---

## Descrição dos Arquivos do Projeto

### `01_instalLib.bat` — Script de Instalação de Bibliotecas

**Tipo**: Script batch para Windows (`.bat`)

Este é o ponto de partida do projeto. Trata-se de um script simples de linha de comando que automatiza a instalação de todas as bibliotecas Python necessárias para a execução dos materiais do curso. Ao ser executado, ele invoca o `pip` (gerenciador de pacotes do Python) para instalar as seguintes dependências:

- **requests**: biblioteca para requisições HTTP.
- **ipympl**: backend interativo do Matplotlib para notebooks Jupyter.
- **ipython**: shell interativo avançado para Python.
- **ipywidgets**: widgets interativos para notebooks Jupyter.
- **matplotlib**: biblioteca padrão para criação de gráficos e visualizações.
- **numpy**: biblioteca fundamental para computação numérica com arrays multidimensionais.

O script utiliza a flag `-q` (quiet) para suprimir a saída verbosa do pip, mantendo o terminal mais limpo durante a instalação.

**Comando executado:**
```bash
CALL pip -q install requests ipympl ipython ipywidgets matplotlib numpy
```

---

### `02_aprendendo_python.py` — Primeiro Contato com Python

**Tipo**: Script Python padrão (`.py`)

Este é o primeiro exercício prático da disciplina: um script Python puro (sem notebook) que demonstra como utilizar bibliotecas científicas para gerar e visualizar funções trigonométricas. O programa:

1. Importa funções matemáticas e de plotagem do **NumPy** e do **Matplotlib** (via `pylab`).
2. Define um período `T = 20` e um vetor de tempo `t` de 0 a 100 com passo de 0,1.
3. Calcula as funções **cosseno** e **seno** ao longo do tempo.
4. Gera um gráfico com as duas curvas sobrepostas, identificadas por uma legenda.
5. Exibe o gráfico com o título **"Aula 01 de Instrumentação Industrial"**.

Este script introduz conceitos fundamentais como importação de módulos, uso de funções matemáticas vetorizadas, geração de vetores numéricos e plotagem básica — habilidades essenciais que serão utilizadas nos notebooks subsequentes.

---

### `03_python_Jupyter.ipynb` — Introdução ao Python e ao Jupyter Notebook

**Tipo**: Jupyter Notebook (`.ipynb`) — 230 células (código e Markdown)

Este é o material mais extenso e abrangente do repositório. Trata-se de um **curso completo de introdução ao Python** organizado dentro de um Jupyter Notebook, cobrindo desde os fundamentos mais básicos da linguagem até tópicos mais avançados. O notebook foi projetado para ser utilizado tanto no **VSCode** quanto no **Google Colab**.

#### Conteúdo abordado:

1. **Instalação e uso de bibliotecas**: como instalar pacotes com `pip` diretamente dentro do notebook usando *magic commands* (`%pip`, `!pip`), como importar módulos (`import`, `from ... import`, `as`).

2. **Interação com o usuário**: uso de `print()` para saída de dados com formatação (`%s`, f-strings) e `input()` para entrada de dados pelo teclado.

3. **Fundamentos da linguagem**:
   - Indentação como delimitação de blocos.
   - Comentários de linha (`#`) e de bloco (`""" """`).
   - Tipos numéricos, operadores aritméticos, potenciação (`**`), módulo (`%`).
   - Funções built-in (`max`, `min`, `abs`, `round`).
   - Conversão de tipos (`int()`, `float()`, `str()`).

4. **Strings**: operações com strings, concatenação, repetição, slicing, métodos como `.upper()`, `.lower()`, `.strip()`, `.replace()`, `.split()`, `.find()`.

5. **Estruturas de dados**:
   - Listas: criação, acesso, slicing, métodos (`append`, `remove`, `sort`, etc.), compreensão de listas.
   - Tuplas: imutabilidade, empacotamento e desempacotamento.
   - Dicionários: pares chave-valor, acesso, iteração.

6. **Estruturas de controle**:
   - Condicionais: `if`, `elif`, `else`.
   - Laços: `for`, `while`, `break`, `continue`.
   - Funções: definição com `def`, parâmetros, retorno de valores, escopo de variáveis.
   - Tratamento de exceções: `try`, `except`, `finally`.

7. **Programação orientada a objetos**: classes, objetos, `__init__`, métodos, atributos.

8. **Trabalhando com arquivos**: abertura, leitura e escrita de arquivos com `open()` e o gerenciador de contexto `with`.

9. **Bibliotecas científicas**: introdução ao uso de NumPy, Matplotlib e Pandas para computação numérica, visualização e análise de dados.

10. **Gráficos e visualizações**: plotagem de funções, personalização de gráficos, múltiplas séries, legendas, rótulos de eixos.

Este notebook serve como referência permanente para os alunos ao longo de toda a disciplina, podendo ser consultado sempre que houver dúvida sobre sintaxe ou funcionalidades do Python.

---

### `04_simulação_do_voltímetro_no_python.ipynb` — Simulação de Voltímetro RMS

**Tipo**: Jupyter Notebook (`.ipynb`) — 7 células

Este notebook implementa uma **simulação completa de um voltímetro RMS digital** em Python (puro), demonstrando como o cálculo do valor RMS eficaz é realizado computacionalmente a partir de amostras de tensão alternada. É um excelente exemplo de como Python pode substituir (ou complementar) o uso de instrumentos físicos para fins de estudo e validação.

#### Estrutura do notebook:

**Etapa 1 — Importação de Bibliotecas**: o notebook utiliza `matplotlib`, `numpy`, `scipy` (para filtros FIR e álgebra linear), `math` e `pylab`. As bibliotecas são instaladas automaticamente via `%pip` no início da execução.

**Etapa 2 — Simulação do Voltímetro**: o código principal realiza as seguintes operações:

- Define parâmetros do sinal: frequência da rede (60 Hz), taxa de amostragem (1 kHz), tempo de simulação (3 s).
- Gera um sinal de tensão alternada senoidal com **quatro faixas de tensão RMS distintas** ao longo do tempo: **220 V**, **440 V**, **127 V** e **380 V** — simulando variações de tensão que um voltímetro real poderia encontrar.
- Calcula o valor **RMS** (Root Mean Square) a cada bloco de 100 amostras, utilizando o desvio padrão (`np.std`).
- Aplica o **Método dos Mínimos Quadrados (MMQ)** para realizar um ajuste linear entre os valores RMS calculados e os valores reais de referência, obtendo coeficientes de calibração (`VCAL_M` e `VCAL_B`).
- Gera um gráfico comparativo mostrando o **sinal AC original** (azul) e a **leitura RMS calibrada** (vermelho), com o título "Calibração|Ajuste".

**Etapa 3 — Tarefa prática**: o aluno deve inserir uma quinta faixa de tensão de **660 V** na simulação, exercitando a compreensão do código e a capacidade de modificá-lo.

Este notebook demonstra conceitos fundamentais de instrumentação digital: amostragem, cálculo de RMS, calibração por mínimos quadrados e visualização de sinais.

---

### `05_projeto_condicionador_sinais.ipynb` — Projeto de Condicionador de Sinais

**Tipo**: Jupyter Notebook (`.ipynb`) — 18 células (estruturado para conversão em slides via `nbconvert`)

Este é o **notebook principal do projeto de engenharia** da disciplina. Ele implementa, de forma completa e documentada, o projeto computacional de um **circuito condicionador de sinais** capaz de converter a tensão da rede elétrica (220 V RMS) para a faixa de entrada de um ADC (0 V a 5 V).

#### Estrutura detalhada do notebook:

**Esquemático de Referência**: o notebook inicia com a apresentação do circuito-base utilizado na análise — um divisor resistivo com três resistores (R1, R2, R3) que realizam simultaneamente a atenuação do sinal CA e a adição de um offset CC.

**Formulação do Problema**: apresentação da conversão de tensão RMS para tensão de pico ($V_{pico} = V_{RMS} \times \sqrt{2}$), resultando em aproximadamente 311,13 V para uma entrada de 220 V RMS. O objetivo é encontrar uma configuração resistiva que produza saída entre 0 V e 5 V.

**Estratégia Computacional**: a solução é organizada em quatro etapas lógicas: (1) definição de parâmetros, (2) geração da lista de resistores comerciais, (3) cálculo de ganho e offset para cada combinação, (4) filtragem dos circuitos que atendem aos critérios.

**1) Parâmetros do Problema**: definição da faixa de saída desejada (0 V a 5 V), da tensão de entrada (220 V RMS) e do número máximo de tentativas da busca aleatória (8.000).

**2) Preparação do Sinal de Entrada**: conversão automática de um valor RMS escalar para um par [positivo, negativo], seguida da conversão RMS para pico.

**3) Resistores Comerciais**: geração de uma biblioteca de resistores disponíveis a partir de 23 valores-base da série comercial (10, 11, 12, ..., 82) multiplicados por 7 décadas (1, 10, 100, 1k, 10k, 100k, 1M), totalizando **161 valores** de resistores reais que podem ser encontrados no mercado.

**4) Funções Auxiliares**: implementação de funções Python puras e bem documentadas para:
- `paralelo(r1, r2)`: cálculo do equivalente paralelo de dois resistores.
- `calcular_ganho_ca_real(r1, r2, r3)`: ganho CA do divisor resistivo.
- `calcular_offset_cc(r1, r2, r3, tensao_cc)`: offset CC na saída.
- `calcular_ganho_ca_ideal(tensao_cc, tensao_ca_pico)`: ganho de referência.
- `calcular_saida_final(valor_cc, ganho_ca, entrada_pico)`: tensão de saída máxima e mínima.
- `circuito_valido(...)`: validação contra critérios elétricos (R3 < 500 kΩ, corrente < 1 mA, ganho real ≤ ideal, saída ≥ 90% da desejada).

**5) Ganho CA Ideal**: cálculo do ganho de referência que serve como limite superior para a atenuação da rede resistiva.

**6) Busca Aleatória por Combinações (Monte Carlo)**: o algoritmo sorteia até 8.000 combinações de resistores comerciais, calcula os parâmetros de cada circuito e armazena as combinações que passam nos critérios de validação. Duplicatas são eliminadas usando um conjunto (`set`) de chaves.

**7) Organização dos Resultados**: os circuitos válidos encontrados são organizados em um **DataFrame do Pandas**, ordenados pela maior saída máxima, e exibidos em formato de tabela.

**Leitura dos Resultados e Próximos Passos**: ao final, o notebook discute possíveis evoluções do projeto, como busca exaustiva, inclusão de tolerâncias dos resistores, análise de potência dissipada e comparação de custo entre as soluções.

**Conversão para Slides**: instruções para converter o notebook em slides HTML usando `jupyter nbconvert --to slides`.

---

### `Teoria_quinta_01.pptx` — Apresentação Teórica: Introdução ao Python

**Tipo**: Apresentação PowerPoint (`.pptx`)

Este arquivo corresponde à **aula teórica expositiva** que acompanha os materiais práticos do repositório. A apresentação é utilizada pelo professor como suporte visual em sala de aula e cobre os seguintes tópicos:

1. **O que é Python?**: histórico da linguagem, criação por Guido van Rossum em 1991, áreas de aplicação (desenvolvimento web, análise de dados, inteligência artificial, automação, aplicações desktop).

2. **Principais recursos**: sintaxe simples e legível, suporte multiparadigma, biblioteca padrão ampla, portabilidade, comunidade ativa.

3. **Instalação do Python**: instruções passo a passo para Windows, macOS e Linux, verificação da instalação com `python --version`, e apresentação do **Google Colab** como alternativa na nuvem e do **VSCode** como ambiente local.

4. **Primeiros passos**: criação e execução do clássico "Hello, World!" em Python.

5. **Estrutura básica de código**: variáveis e tipos (string, inteiro, float, booleano), estruturas condicionais (`if`/`else`), laços de repetição (`for`), funções (`def`).

6. **Recursos avançados**: classes e objetos (POO), manipulação de arquivos (`open`, `with`), uso de bibliotecas externas com `pip install`.

7. **Principais bibliotecas e frameworks**: tabela organizada por categoria (Web: Flask/Django; Análise de dados: NumPy/Pandas/Matplotlib; IA/ML: TensorFlow/PyTorch/Scikit-learn; Automação: Selenium/BeautifulSoup; Testes: pytest/unittest).

8. **Próximos passos e comunidade**: incentivo à participação em eventos como a PyCon, exploração da documentação oficial e contribuição com projetos open source.

9. **Tarefa prática**: a apresentação inclui a tarefa de inserir uma faixa adicional de **660 Volts** na simulação do arquivo `04_simulação_do_voltímetro_no_python.ipynb`.

10. **Links úteis**: referências para o site oficial do Python, documentação, W3Schools, PyPI e Real Python.

---

## Bibliotecas Utilizadas

O projeto faz uso das seguintes bibliotecas Python, todas disponíveis via `pip`:

| Biblioteca | Finalidade no Projeto |
|---|---|
| **NumPy** | Operações vetoriais, geração de arrays, funções trigonométricas, cálculo de RMS |
| **SciPy** | Filtros FIR (`firwin`, `lfilter`), álgebra linear (`pinvh` para pseudo-inversa) |
| **Matplotlib** | Plotagem de gráficos de sinais, formas de onda e resultados de simulação |
| **Pandas** | Organização dos resultados da busca por circuitos em DataFrames e tabelas |
| **math** | Funções matemáticas básicas (`sqrt`, `floor`, constante `pi`) |
| **random** | Geração de combinações aleatórias de resistores (busca Monte Carlo) |
| **IPython / ipywidgets** | Suporte a widgets interativos e display enriquecido nos notebooks |
| **ipympl** | Backend interativo do Matplotlib para notebooks Jupyter |
| **requests** | Requisições HTTP (utilizado em exemplos introdutórios) |

---

## Como Executar os Materiais

### Opção 1 — Google Colab (recomendado para iniciantes)

1. Faça upload dos arquivos `.ipynb` para o [Google Colab](https://colab.research.google.com/).
2. Execute as células sequencialmente (Shift + Enter).
3. As bibliotecas necessárias serão instaladas automaticamente pelas primeiras células de cada notebook.

### Opção 2 — VSCode com Jupyter

1. Instale o [Python](https://www.python.org/) (marcando "Add Python to PATH").
2. Instale o [VSCode](https://code.visualstudio.com/) e a extensão **Jupyter**.
3. Execute o script `01_instalLib.bat` para instalar as dependências.
4. Abra os arquivos `.ipynb` no VSCode e execute as células.

### Opção 3 — Jupyter Notebook local

1. Instale o Jupyter com `pip install jupyter`.
2. No terminal, navegue até a pasta do projeto e execute `jupyter notebook`.
3. Abra os notebooks pelo navegador.

### Executando o script `.py`

```bash
python 02_aprendendo_python.py
```

---

## Links Úteis

- [Site Oficial do Python](https://www.python.org/)
- [Documentação Oficial do Python](https://docs.python.org/3/)
- [Google Colaboratory](https://colab.research.google.com/)
- [Tutorial Python no W3Schools](https://www.w3schools.com/python/)
- [PyPI — Repositório de Pacotes Python](https://pypi.org/)
- [Guia para Iniciantes — Real Python](https://realpython.com/)
- [Documentação do NumPy](https://numpy.org/doc/)
- [Documentação do Matplotlib](https://matplotlib.org/stable/contents.html)
- [Documentação do Pandas](https://pandas.pydata.org/docs/)
- [Documentação do SciPy](https://docs.scipy.org/doc/scipy/)

---

> **Universidade Federal de Uberlândia — Faculdade de Engenharia Elétrica**
> Disciplina: Instrumentação Industrial I (ININD1)
> Repositório: EININDI02_Projetos_Engenharia_Python
