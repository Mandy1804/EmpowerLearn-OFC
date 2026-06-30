import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedFilter = 0;
  int _userId = 0;
  String _userTipo = 'aluno';
  bool _carregando = true;
  String? _erro;
  List<dynamic> _tarefas = [];

  final List<Color> _paletaCores = [
    Colors.cyan,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  final Map<String, Color> _coresPorMateria = {};

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  bool get _isProfessor {
    return _userTipo == 'professor' || _userTipo == 'admin';
  }

  List<String> get _filtros {
    if (_isProfessor) {
      return ['Todas', 'Criadas'];
    }

    return ['Todas', 'A Fazer', 'Enviadas'];
  }

  List<dynamic> get _tarefasPendentes {
    return _tarefas.where((tarefa) => !_foiEnviada(tarefa)).toList();
  }

  List<dynamic> get _tarefasEnviadas {
    return _tarefas.where((tarefa) => _foiEnviada(tarefa)).toList();
  }

  List<dynamic> get _tarefasFiltradas {
    if (_selectedFilter == 0) {
      return _tarefas;
    }

    final filtro = _filtros[_selectedFilter];

    if (_isProfessor && filtro == 'Criadas') {
      return _tarefas;
    }

    if (!_isProfessor && filtro == 'A Fazer') {
      return _tarefasPendentes;
    }

    if (!_isProfessor && filtro == 'Enviadas') {
      return _tarefasEnviadas;
    }

    return _tarefas;
  }

  Future<void> _carregar() async {
    if (mounted) {
      setState(() {
        _carregando = true;
        _erro = null;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final tipo = prefs.getString('userTipo') ?? 'aluno';
      final userId = int.tryParse(prefs.getString('userId') ?? '0') ?? 0;

      final tarefas = await ApiService.getTarefas(0);

      if (!mounted) return;

      setState(() {
        _userTipo = tipo.toLowerCase();
        _userId = userId;
        _tarefas = tarefas;
        _selectedFilter = 0;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar tarefas.';
        _tarefas = [];
        _carregando = false;
      });
    }
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  int _parseId(dynamic valor) {
    if (valor is int) return valor;
    return int.tryParse(valor?.toString() ?? '') ?? 0;
  }

  bool _foiEnviada(dynamic tarefa) {
    final submissoes = tarefa['submissoes'];

    if (submissoes is! List) {
      return false;
    }

    return submissoes.any((item) {
      final submissao = _asMap(item);
      return _parseId(submissao?['alunoId']) == _userId;
    });
  }

  String _statusTarefa(dynamic tarefa) {
    if (_isProfessor) {
      return 'Criadas';
    }

    return _foiEnviada(tarefa) ? 'Enviada' : 'A Fazer';
  }

  String _formatarPrazo(dynamic valor) {
    if (valor == null) {
      return 'Sem prazo';
    }

    try {
      final data = DateTime.parse(valor.toString());
      final dia = data.day.toString().padLeft(2, '0');
      final mes = data.month.toString().padLeft(2, '0');
      final ano = data.year.toString();

      return '$dia/$mes/$ano';
    } catch (_) {
      return valor.toString();
    }
  }

  String _nomeMateria(dynamic tarefa) {
    final materia = _asMap(tarefa['materia']);

    final nomeDireto = tarefa['materiaNome']?.toString();
    if (nomeDireto != null && nomeDireto.trim().isNotEmpty) {
      return nomeDireto.trim();
    }

    final nomeMateria = materia?['nome']?.toString();
    if (nomeMateria != null && nomeMateria.trim().isNotEmpty) {
      return nomeMateria.trim();
    }

    final tituloMateria = materia?['titulo']?.toString();
    if (tituloMateria != null && tituloMateria.trim().isNotEmpty) {
      return tituloMateria.trim();
    }

    final idMateria = _parseId(tarefa['materiaId']);
    if (idMateria > 0) {
      return 'Matéria $idMateria';
    }

    return 'Sem matéria';
  }

  String _nomeCurso(dynamic tarefa) {
    final materia = _asMap(tarefa['materia']);
    final cursoDireto = _asMap(tarefa['curso']);
    final cursoDaMateria = _asMap(materia?['curso']);

    final nomeDireto = tarefa['cursoNome']?.toString();
    if (nomeDireto != null && nomeDireto.trim().isNotEmpty) {
      return nomeDireto.trim();
    }

    final nomeCursoDireto = cursoDireto?['nome']?.toString();
    if (nomeCursoDireto != null && nomeCursoDireto.trim().isNotEmpty) {
      return nomeCursoDireto.trim();
    }

    final tituloCursoDireto = cursoDireto?['titulo']?.toString();
    if (tituloCursoDireto != null && tituloCursoDireto.trim().isNotEmpty) {
      return tituloCursoDireto.trim();
    }

    final nomeCursoMateria = cursoDaMateria?['nome']?.toString();
    if (nomeCursoMateria != null && nomeCursoMateria.trim().isNotEmpty) {
      return nomeCursoMateria.trim();
    }

    final tituloCursoMateria = cursoDaMateria?['titulo']?.toString();
    if (tituloCursoMateria != null && tituloCursoMateria.trim().isNotEmpty) {
      return tituloCursoMateria.trim();
    }

    return 'Curso não informado';
  }

  String _chaveMateria(dynamic tarefa) {
    final idMateria = _parseId(tarefa['materiaId']);

    if (idMateria > 0) {
      return 'materia_$idMateria';
    }

    final nome = _nomeMateria(tarefa).trim().toLowerCase();

    if (nome.isNotEmpty) {
      return nome;
    }

    return 'sem_materia';
  }

  Color _corDaMateria(dynamic tarefa) {
    final chave = _chaveMateria(tarefa);

    if (_coresPorMateria.containsKey(chave)) {
      return _coresPorMateria[chave]!;
    }

    final cor = _paletaCores[_coresPorMateria.length % _paletaCores.length];
    _coresPorMateria[chave] = cor;
    return cor;
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Widget _campo(TextEditingController ctrl, String hint, {int linhas = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: linhas,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _abrirSubmeter(dynamic tarefa) {
    final tarefaId = _parseId(tarefa['id']);

    if (tarefaId <= 0) {
      _mostrarMensagem('Tarefa inválida.', Colors.redAccent);
      return;
    }

    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SubmitTaskSheet(
          tarefaId: tarefaId,
          titulo: tarefa['titulo']?.toString() ?? 'Tarefa',
          descricao: tarefa['descricao']?.toString() ?? '',
        );
      },
    ).then((enviou) async {
      if (enviou != true || !mounted) {
        return;
      }

      _mostrarMensagem('Tarefa enviada!', Colors.green);
      await _carregar();
    });
  }

  Widget _statCard(String titulo, String valor, {Color? valueColor}) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const Spacer(),
          Text(
            valor,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filtroChip(int index) {
    final selected = _selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C63FF) : const Color(0xFF111C3D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          _filtros[index],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _estadoCarregando() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _estadoErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            Text(
              _erro ?? 'Erro ao carregar tarefas.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _carregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: Colors.white30,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _isProfessor
                ? 'Nenhuma tarefa criada.\nCrie tarefas pelo botão da matéria.'
                : 'Nenhuma tarefa disponível.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _cardTarefa(dynamic tarefa, int index) {
    final cor = _corDaMateria(tarefa);
    final titulo = tarefa['titulo']?.toString() ?? 'Tarefa sem título';
    final descricao = tarefa['descricao']?.toString() ?? '';
    final nomeMateria = _nomeMateria(tarefa);
    final nomeCurso = _nomeCurso(tarefa);
    final prazo = _formatarPrazo(tarefa['prazo']);
    final enviada = _foiEnviada(tarefa);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: cor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    nomeMateria,
                    style: TextStyle(
                      color: cor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (descricao.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                descricao,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white38,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  prazo,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.school_outlined,
                  color: Colors.white38,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    nomeCurso,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (!_isProfessor) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: enviada ? null : () => _abrirSubmeter(tarefa),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enviada
                        ? Colors.white12
                        : cor.withOpacity(0.22),
                    foregroundColor: enviada ? Colors.white38 : cor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    enviada ? 'Enviada' : 'Responder',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _listaTarefas() {
    final tarefas = _tarefasFiltradas;

    if (tarefas.isEmpty) {
      return _estadoVazio();
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tarefas.length,
        itemBuilder: (_, index) {
          return _cardTarefa(tarefas[index], index);
        },
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return _estadoCarregando();
    }

    if (_erro != null) {
      return _estadoErro();
    }

    final segundoCardTitulo = _isProfessor ? 'Criadas' : 'Pendentes';
    final segundoCardValor = _isProfessor
        ? _tarefas.length.toString()
        : _tarefasPendentes.length.toString();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 30),
            const Text(
              'Atividades',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _carregar,
              icon: const Icon(Icons.refresh, color: Colors.white70),
              tooltip: 'Atualizar tarefas',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _statCard('Tarefas', _tarefas.length.toString())),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                segundoCardTitulo,
                segundoCardValor,
                valueColor: const Color(0xFFFFB020),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filtros.length,
            itemBuilder: (_, index) {
              return _filtroChip(index);
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(child: _listaTarefas()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: _conteudo()),
      ),
    );
  }
}

class _SubmitTaskSheet extends StatefulWidget {
  final int tarefaId;
  final String titulo;
  final String descricao;

  const _SubmitTaskSheet({
    required this.tarefaId,
    required this.titulo,
    required this.descricao,
  });

  @override
  State<_SubmitTaskSheet> createState() => _SubmitTaskSheetState();
}

class _SubmitTaskSheetState extends State<_SubmitTaskSheet> {
  final TextEditingController _respostaCtrl = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _respostaCtrl.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Future<void> _enviar() async {
    if (_enviando) return;

    final resposta = _respostaCtrl.text.trim();

    if (resposta.isEmpty) {
      _mostrarMensagem('Informe sua resposta.', Colors.orange);
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      await ApiService.submeterTarefa(widget.tarefaId, resposta);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _enviando = false;
      });

      _mostrarMensagem('Erro ao enviar tarefa: $e', Colors.redAccent);
    }
  }

  Widget _campoResposta() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _respostaCtrl,
        maxLines: 5,
        enabled: !_enviando,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Sua resposta...',
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _botaoEnviar() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _enviando ? null : _enviar,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6CFF),
          disabledBackgroundColor: const Color(0xFF26345F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _enviando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Enviar Resposta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height * 0.6;
    final teclado = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: Container(
        height: altura,
        decoration: const BoxDecoration(
          color: Color(0xFF081225),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: teclado + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.descricao.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.descricao,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: _campoResposta(),
              ),
            ),
            const SizedBox(height: 16),
            _botaoEnviar(),
          ],
        ),
      ),
    );
  }
}
