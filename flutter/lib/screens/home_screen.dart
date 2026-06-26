import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _DashboardMetric {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DashboardMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  String _nome = 'Usuário';
  String _inicial = 'U';
  String _tipoUsuario = 'aluno';
  String? _fotoUrl;
  int _userId = 0;

  bool _carregando = true;
  String? _erro;

  List<dynamic> _cursos = [];
  List<dynamic> _matriculas = [];
  List<dynamic> _tarefas = [];
  List<dynamic> _submissoes = [];
  List<dynamic> _progresso = [];

  final List<Color> _cores = [
    AppColors.blue,
    AppColors.purple,
    AppColors.green,
    AppColors.orange,
    Colors.cyan,
    Colors.pinkAccent,
    Colors.teal,
    Colors.indigoAccent,
  ];

  @override
  void initState() {
    super.initState();
    _carregarDashboard();
  }

  bool get _isAluno => _tipoUsuario == 'aluno';

  bool get _isProfessor => _tipoUsuario == 'professor';

  bool get _isAdmin => _tipoUsuario == 'admin';

  String get _primeiroNome {
    final nomeLimpo = _nome.trim();

    if (nomeLimpo.isEmpty) {
      if (_isProfessor) return 'Professor';
      if (_isAdmin) return 'Admin';
      return 'Aluno';
    }

    return nomeLimpo.split(RegExp(r'\s+')).first;
  }

  String? get _fotoUrlCompleta {
    final valor = _fotoUrl?.trim();

    if (valor == null || valor.isEmpty) {
      return null;
    }

    if (valor.startsWith('http://') || valor.startsWith('https://')) {
      return valor;
    }

    if (valor.startsWith('/')) {
      return '${ApiService.baseUrl}$valor';
    }

    return '${ApiService.baseUrl}/$valor';
  }

  Future<List<dynamic>> _buscarListaSegura(
    Future<List<dynamic>> Function() requisicao,
  ) async {
    try {
      return await requisicao();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> _buscarPerfilSeguro() async {
    try {
      return await ApiService.getMeuPerfil();
    } catch (_) {
      return null;
    }
  }

  Future<void> _carregarDashboard() async {
    if (mounted) {
      setState(() {
        _carregando = true;
        _erro = null;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      var nomeSalvo = prefs.getString('userNome') ?? 'Usuário';
      var tipoSalvo = (prefs.getString('userTipo') ?? 'aluno').toLowerCase();
      var fotoSalva = prefs.getString('userFotoUrl');
      final userIdSalvo = int.tryParse(prefs.getString('userId') ?? '0') ?? 0;

      final perfil = await _buscarPerfilSeguro();

      if (perfil != null) {
        final nomePerfil = perfil['nome']?.toString();
        final tipoPerfil = perfil['tipo']?.toString();
        final fotoPerfil = perfil['fotoUrl'] ?? perfil['foto_url'];

        if (nomePerfil != null && nomePerfil.trim().isNotEmpty) {
          nomeSalvo = nomePerfil.trim();
          await prefs.setString('userNome', nomeSalvo);
        }

        if (tipoPerfil != null && tipoPerfil.trim().isNotEmpty) {
          tipoSalvo = tipoPerfil.trim().toLowerCase();
          await prefs.setString('userTipo', tipoSalvo);
        }

        if (fotoPerfil != null && fotoPerfil.toString().trim().isNotEmpty) {
          fotoSalva = fotoPerfil.toString().trim();
          await prefs.setString('userFotoUrl', fotoSalva);
        }
      }

      final cursos = await _buscarListaSegura(ApiService.getCursos);
      final tarefas = await _buscarListaSegura(() => ApiService.getTarefas(0));

      var matriculas = <dynamic>[];
      var progresso = <dynamic>[];
      var submissoes = <dynamic>[];

      if (tipoSalvo == 'aluno') {
        matriculas = await _buscarListaSegura(ApiService.getMinhasMatriculas);
        progresso = await _buscarListaSegura(ApiService.getMeuProgresso);
      }

      if (tipoSalvo == 'professor' || tipoSalvo == 'admin') {
        submissoes = await _buscarListaSegura(
          () => ApiService.getSubmissoes(0),
        );
      }

      if (!mounted) return;

      setState(() {
        _nome = nomeSalvo;
        _inicial = nomeSalvo.trim().isNotEmpty
            ? nomeSalvo.trim()[0].toUpperCase()
            : 'U';
        _tipoUsuario = tipoSalvo;
        _fotoUrl = fotoSalva;
        _userId = userIdSalvo;
        _cursos = cursos;
        _tarefas = tarefas;
        _matriculas = matriculas;
        _progresso = progresso;
        _submissoes = submissoes;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar dashboard.';
        _carregando = false;
      });
    }
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  int _parseId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _texto(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  List<dynamic> _submissoesDaTarefa(dynamic tarefa) {
    final submissoes = tarefa['submissoes'];

    if (submissoes is List) {
      return submissoes;
    }

    return [];
  }

  bool _foiEnviadaPeloAluno(dynamic tarefa) {
    final submissoes = _submissoesDaTarefa(tarefa);

    return submissoes.any((item) {
      final submissao = _asMap(item);
      return _parseId(submissao?['alunoId']) == _userId;
    });
  }

  List<dynamic> get _tarefasPendentesAluno {
    return _tarefas.where((tarefa) => !_foiEnviadaPeloAluno(tarefa)).toList();
  }

  List<dynamic> get _tarefasEnviadasAluno {
    return _tarefas.where((tarefa) => _foiEnviadaPeloAluno(tarefa)).toList();
  }

  bool _cursoDoProfessor(dynamic curso) {
    final item = _asMap(curso);
    final criadorId = _parseId(
      item?['criadorId'] ?? item?['professorId'] ?? item?['usuarioId'],
    );

    return criadorId > 0 && criadorId == _userId;
  }

  List<dynamic> get _cursosProfessor {
    final filtrados = _cursos.where(_cursoDoProfessor).toList();

    if (filtrados.isNotEmpty) {
      return filtrados;
    }

    return _cursos;
  }

  bool _tarefaDoProfessor(dynamic tarefa) {
    final item = _asMap(tarefa);
    final materia = _asMap(item?['materia']);

    final professorId = _parseId(
      item?['professorId'] ??
          item?['criadorId'] ??
          materia?['professorId'] ??
          materia?['criadorId'],
    );

    return professorId > 0 && professorId == _userId;
  }

  List<dynamic> get _tarefasProfessor {
    if (_isAdmin) {
      return _tarefas;
    }

    final filtradas = _tarefas.where(_tarefaDoProfessor).toList();

    if (filtradas.isNotEmpty) {
      return filtradas;
    }

    return _tarefas;
  }

  Set<int> get _idsTarefasProfessor {
    return _tarefasProfessor
        .map((tarefa) => _parseId(tarefa['id']))
        .where((id) => id > 0)
        .toSet();
  }

  List<dynamic> get _submissoesProfessor {
    if (_isAdmin) {
      return _submissoes;
    }

    final ids = _idsTarefasProfessor;

    if (ids.isEmpty) {
      return _submissoes;
    }

    return _submissoes.where((submissao) {
      final item = _asMap(submissao);
      final tarefa = _asMap(item?['tarefa']);
      final tarefaId = _parseId(item?['tarefaId'] ?? tarefa?['id']);

      return ids.contains(tarefaId);
    }).toList();
  }

  bool _tarefaTemSubmissao(dynamic tarefa) {
    final tarefaId = _parseId(tarefa['id']);

    if (_submissoesDaTarefa(tarefa).isNotEmpty) {
      return true;
    }

    if (tarefaId <= 0) {
      return false;
    }

    return _submissoesProfessor.any((submissao) {
      final item = _asMap(submissao);
      final tarefa = _asMap(item?['tarefa']);
      final id = _parseId(item?['tarefaId'] ?? tarefa?['id']);

      return id == tarefaId;
    });
  }

  List<dynamic> get _tarefasSemRespostaProfessor {
    return _tarefasProfessor
        .where((tarefa) => !_tarefaTemSubmissao(tarefa))
        .toList();
  }

  String _nomeCurso(dynamic value) {
    final item = _asMap(value);
    final curso = _asMap(item?['curso']);
    final materia = _asMap(item?['materia']);
    final cursoDaMateria = _asMap(materia?['curso']);

    final candidatos = [
      item?['cursoNome'],
      item?['nome'],
      item?['titulo'],
      curso?['nome'],
      curso?['titulo'],
      cursoDaMateria?['nome'],
      cursoDaMateria?['titulo'],
    ];

    for (final candidato in candidatos) {
      final texto = candidato?.toString().trim() ?? '';
      if (texto.isNotEmpty) return texto;
    }

    final id = _parseId(
      item?['cursoId'] ?? curso?['id'] ?? cursoDaMateria?['id'],
    );

    if (id > 0) return 'Curso $id';

    return 'Curso não informado';
  }

  String _nomeMateria(dynamic tarefa) {
    final item = _asMap(tarefa);
    final materia = _asMap(item?['materia']);

    final candidatos = [
      item?['materiaNome'],
      materia?['nome'],
      materia?['titulo'],
    ];

    for (final candidato in candidatos) {
      final texto = candidato?.toString().trim() ?? '';
      if (texto.isNotEmpty) return texto;
    }

    final id = _parseId(item?['materiaId'] ?? materia?['id']);
    if (id > 0) return 'Matéria $id';

    return 'Sem matéria';
  }

  String _tituloTarefa(dynamic tarefa) {
    return _texto(tarefa['titulo'], fallback: 'Tarefa sem título');
  }

  String _descricaoTarefa(dynamic tarefa) {
    return _texto(tarefa['descricao'], fallback: 'Sem descrição informada');
  }

  String _formatarData(dynamic value) {
    if (value == null) return 'Sem prazo';

    try {
      final data = DateTime.parse(value.toString());
      final dia = data.day.toString().padLeft(2, '0');
      final mes = data.month.toString().padLeft(2, '0');
      final ano = data.year.toString();

      return '$dia/$mes/$ano';
    } catch (_) {
      return value.toString();
    }
  }

  Color _corPorIndice(int index) {
    return _cores[index % _cores.length];
  }

  void _irPara(String rota) {
    Navigator.pushReplacementNamed(context, rota);
  }

  Widget _avatarInicial() {
    return Center(
      child: Text(
        _inicial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _avatarCabecalho() {
    final foto = _fotoUrlCompleta;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B5FFF), Color(0xFFB245FF)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: foto == null
          ? _avatarInicial()
          : Image.network(
              foto,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _avatarInicial(),
            ),
    );
  }

  Widget _cabecalho({required String titulo, required String subtitulo}) {
    return Container(
      padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13203F), Color(0xFF1B1042)],
        ),
      ),
      child: Row(
        children: [
          _avatarCabecalho(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(_DashboardMetric metric) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: metric.color.withOpacity(0.18),
            child: Icon(metric.icon, color: metric.color, size: 17),
          ),
          const Spacer(),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsGrid(List<_DashboardMetric> metrics) {
    final rows = <Widget>[];

    for (var i = 0; i < metrics.length; i += 2) {
      final first = metrics[i];
      final second = i + 1 < metrics.length ? metrics[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(child: _metricCard(first)),
              const SizedBox(width: 12),
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : _metricCard(second),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _sectionHeader({required String titulo, String? acao, String? rota}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (acao != null && rota != null)
          TextButton(
            onPressed: () => _irPara(rota),
            child: Text(
              acao,
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyCard({
    required IconData icon,
    required String titulo,
    required String descricao,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white30, size: 42),
          const SizedBox(height: 12),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cursoCard(dynamic item, int index, {String? etiqueta}) {
    final curso = _asMap(item);
    final cursoDentro = _asMap(curso?['curso']);
    final dadosCurso = cursoDentro ?? curso;

    final titulo = _nomeCurso(dadosCurso);
    final descricao = _texto(
      dadosCurso?['descricao'],
      fallback: 'Curso disponível na plataforma',
    );

    final cor = _corPorIndice(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: cor, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.menu_book, color: cor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  descricao,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (etiqueta != null) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                etiqueta,
                style: TextStyle(
                  color: cor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tarefaCard(
    dynamic tarefa,
    int index, {
    bool mostrarRespostas = false,
  }) {
    final cor = _corPorIndice(index);
    final enviada = _foiEnviadaPeloAluno(tarefa);
    final respostas = _submissoesDaTarefa(tarefa).length;

    final status = _isAluno
        ? enviada
              ? 'Enviada'
              : 'A Fazer'
        : '$respostas resposta${respostas == 1 ? '' : 's'}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: cor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _tituloTarefa(tarefa),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: cor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            _descricaoTarefa(tarefa),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                size: 15,
                color: Colors.white38,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _nomeCurso(tarefa),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.calendar_today, size: 14, color: Colors.white38),
              const SizedBox(width: 5),
              Text(
                _formatarData(tarefa['prazo']),
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          if (mostrarRespostas) ...[
            const SizedBox(height: 10),
            Text(
              'Matéria: ${_nomeMateria(tarefa)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _submissaoCard(dynamic submissao, int index) {
    final item = _asMap(submissao);
    final tarefa = _asMap(item?['tarefa']);

    final tituloTarefa = _texto(
      tarefa?['titulo'],
      fallback: 'Tarefa ${_parseId(item?['tarefaId'])}',
    );

    final cor = _corPorIndice(index);

    final nota = item?['nota'];
    final feedback = _texto(item?['feedback']);
    final status = nota != null || feedback.isNotEmpty
        ? 'Corrigida'
        : 'Pendente';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _irPara('/tasks'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: cor, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: cor.withOpacity(0.18),
                  child: Icon(Icons.assignment_turned_in, color: cor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tituloTarefa,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
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
                    color: cor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: cor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Correção pendente • toque para abrir em Tarefas',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              'Resposta recebida',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.white38, size: 14),
                const SizedBox(width: 5),
                Text(
                  _formatarData(item?['entregueEm'] ?? item?['createdAt']),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                if (nota != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.grade, color: Colors.white38, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Nota: $nota',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _atalhosProfessorAdmin() {
    return Row(
      children: [
        Expanded(
          child: _atalhoCard(
            icon: Icons.menu_book,
            titulo: 'Ver cursos',
            subtitulo: 'Gerenciar cursos',
            rota: '/courses',
            color: AppColors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _atalhoCard(
            icon: Icons.task_alt,
            titulo: 'Ver tarefas',
            subtitulo: 'Acompanhar atividades',
            rota: '/tasks',
            color: AppColors.purple,
          ),
        ),
      ],
    );
  }

  Widget _atalhoCard({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required String rota,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _irPara(rota),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.18),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardAluno() {
    final metrics = [
      _DashboardMetric(
        icon: Icons.menu_book,
        value: _matriculas.length.toString(),
        label: 'Matriculados',
        color: AppColors.blue,
      ),
      _DashboardMetric(
        icon: Icons.pending_actions,
        value: _tarefasPendentesAluno.length.toString(),
        label: 'Pendentes',
        color: AppColors.orange,
      ),
      _DashboardMetric(
        icon: Icons.outbox,
        value: _tarefasEnviadasAluno.length.toString(),
        label: 'Enviadas',
        color: AppColors.green,
      ),
      _DashboardMetric(
        icon: Icons.check_circle,
        value: _progresso.length.toString(),
        label: 'Concluídas',
        color: AppColors.purple,
      ),
    ];

    final cursosRecentes = _matriculas.take(3).toList();
    final tarefasRecentes = _tarefasPendentesAluno.take(3).toList();

    return _conteudoDashboard(
      header: _cabecalho(
        titulo: 'Olá, $_primeiroNome! 👋',
        subtitulo: 'Continue seus estudos',
      ),
      children: [
        _metricsGrid(metrics),
        const SizedBox(height: 10),
        _sectionHeader(
          titulo: 'Meus cursos',
          acao: 'Ver cursos',
          rota: '/courses',
        ),
        const SizedBox(height: 14),
        if (cursosRecentes.isEmpty)
          _emptyCard(
            icon: Icons.menu_book_outlined,
            titulo: 'Nenhum curso matriculado',
            descricao: 'Acesse a aba Cursos para se matricular.',
          )
        else
          ...cursosRecentes.asMap().entries.map(
            (entry) =>
                _cursoCard(entry.value, entry.key, etiqueta: 'Matriculado'),
          ),
        const SizedBox(height: 18),
        _sectionHeader(
          titulo: 'Próximas tarefas',
          acao: 'Ver tarefas',
          rota: '/tasks',
        ),
        const SizedBox(height: 14),
        if (tarefasRecentes.isEmpty)
          _emptyCard(
            icon: Icons.task_alt_outlined,
            titulo: 'Nenhuma tarefa pendente',
            descricao: 'Quando houver tarefas novas, elas aparecerão aqui.',
          )
        else
          ...tarefasRecentes.asMap().entries.map(
            (entry) => _tarefaCard(entry.value, entry.key),
          ),
      ],
    );
  }

  Widget _dashboardProfessor() {
    final tarefas = _tarefasProfessor;
    final submissoes = _submissoesProfessor;

    final metrics = [
      _DashboardMetric(
        icon: Icons.menu_book,
        value: _cursos.length.toString(),
        label: 'Cursos',
        color: AppColors.blue,
      ),
      _DashboardMetric(
        icon: Icons.assignment,
        value: tarefas.length.toString(),
        label: 'Tarefas',
        color: AppColors.purple,
      ),
      _DashboardMetric(
        icon: Icons.inbox,
        value: submissoes.length.toString(),
        label: 'Respostas',
        color: AppColors.green,
      ),
      _DashboardMetric(
        icon: Icons.pending_actions,
        value: _tarefasSemRespostaProfessor.length.toString(),
        label: 'Pendentes',
        color: AppColors.orange,
      ),
    ];

    final respostasRecentes = submissoes.take(3).toList();
    final tarefasRecentes = tarefas.take(3).toList();

    return _conteudoDashboard(
      header: _cabecalho(
        titulo: 'Olá, Prof. $_primeiroNome! 👋',
        subtitulo: 'Painel do professor',
      ),
      children: [
        _metricsGrid(metrics),
        const SizedBox(height: 10),
        _atalhosProfessorAdmin(),
        const SizedBox(height: 24),
        _sectionHeader(
          titulo: 'Correções pendentes',
          acao: 'Ver tarefas',
          rota: '/tasks',
        ),
        const SizedBox(height: 14),
        if (respostasRecentes.isEmpty)
          _emptyCard(
            icon: Icons.inbox_outlined,
            titulo: 'Nenhuma correção pendente',
            descricao: 'Quando alunos responderem tarefas, aparecerão aqui.',
          )
        else
          ...respostasRecentes.asMap().entries.map(
            (entry) => _submissaoCard(entry.value, entry.key),
          ),
        const SizedBox(height: 18),
        _sectionHeader(
          titulo: 'Tarefas recentes',
          acao: 'Ver todas',
          rota: '/tasks',
        ),
        const SizedBox(height: 14),
        if (tarefasRecentes.isEmpty)
          _emptyCard(
            icon: Icons.assignment_outlined,
            titulo: 'Nenhuma tarefa criada',
            descricao: 'Crie tarefas pela tela de matérias.',
          )
        else
          ...tarefasRecentes.asMap().entries.map(
            (entry) =>
                _tarefaCard(entry.value, entry.key, mostrarRespostas: true),
          ),
      ],
    );
  }

  Widget _dashboardAdmin() {
    final metrics = [
      _DashboardMetric(
        icon: Icons.menu_book,
        value: _cursos.length.toString(),
        label: 'Cursos',
        color: AppColors.blue,
      ),
      _DashboardMetric(
        icon: Icons.assignment,
        value: _tarefas.length.toString(),
        label: 'Tarefas',
        color: AppColors.purple,
      ),
      _DashboardMetric(
        icon: Icons.inbox,
        value: _submissoes.length.toString(),
        label: 'Respostas',
        color: AppColors.green,
      ),
      _DashboardMetric(
        icon: Icons.pending_actions,
        value: _tarefas
            .where((tarefa) => !_tarefaTemSubmissao(tarefa))
            .length
            .toString(),
        label: 'Pendentes',
        color: AppColors.orange,
      ),
    ];

    final cursosRecentes = _cursos.take(3).toList();
    final tarefasRecentes = _tarefas.take(3).toList();

    return _conteudoDashboard(
      header: _cabecalho(
        titulo: 'Olá, $_primeiroNome! 👋',
        subtitulo: 'Painel administrativo',
      ),
      children: [
        _metricsGrid(metrics),
        const SizedBox(height: 10),
        _atalhosProfessorAdmin(),
        const SizedBox(height: 24),
        _sectionHeader(
          titulo: 'Cursos recentes',
          acao: 'Ver cursos',
          rota: '/courses',
        ),
        const SizedBox(height: 14),
        if (cursosRecentes.isEmpty)
          _emptyCard(
            icon: Icons.menu_book_outlined,
            titulo: 'Nenhum curso cadastrado',
            descricao: 'Os cursos cadastrados aparecerão aqui.',
          )
        else
          ...cursosRecentes.asMap().entries.map(
            (entry) => _cursoCard(entry.value, entry.key),
          ),
        const SizedBox(height: 18),
        _sectionHeader(
          titulo: 'Tarefas recentes',
          acao: 'Ver tarefas',
          rota: '/tasks',
        ),
        const SizedBox(height: 14),
        if (tarefasRecentes.isEmpty)
          _emptyCard(
            icon: Icons.assignment_outlined,
            titulo: 'Nenhuma tarefa cadastrada',
            descricao: 'As tarefas cadastradas aparecerão aqui.',
          )
        else
          ...tarefasRecentes.asMap().entries.map(
            (entry) =>
                _tarefaCard(entry.value, entry.key, mostrarRespostas: true),
          ),
      ],
    );
  }

  Widget _conteudoDashboard({
    required Widget header,
    required List<Widget> children,
  }) {
    return RefreshIndicator(
      onRefresh: _carregarDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            header,
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...children, const SizedBox(height: 24)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoCarregando() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.blue),
    );
  }

  Widget _estadoErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 62),
            const SizedBox(height: 16),
            Text(
              _erro ?? 'Erro ao carregar dashboard.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _carregarDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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

    if (_isProfessor) {
      return _dashboardProfessor();
    }

    if (_isAdmin) {
      return _dashboardAdmin();
    }

    return _dashboardAluno();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: SafeArea(child: _conteudo()),
    );
  }
}
