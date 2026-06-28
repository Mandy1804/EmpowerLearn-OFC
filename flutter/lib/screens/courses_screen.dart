import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';
import 'materias_screen.dart';

typedef SalvarCursoCallback =
    Future<bool> Function({
      int? id,
      required String titulo,
      required String descricao,
    });

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<dynamic> _cursos = [];
  bool _carregando = true;
  bool _salvando = false;
  String _userTipo = 'aluno';
  String? _erro;

  bool get _isProfessorOuAdmin {
    return _userTipo == 'professor' || _userTipo == 'admin';
  }

  bool get _isAdmin {
    return _userTipo == 'admin';
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final tipo = prefs.getString('userTipo') ?? 'aluno';
      final cursos = await ApiService.getCursos();

      if (!mounted) return;

      setState(() {
        _userTipo = tipo.toLowerCase();
        _cursos = cursos;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar cursos.';
        _cursos = [];
        _carregando = false;
      });
    }
  }

  int _parseId(dynamic valor) {
    if (valor is int) return valor;
    return int.tryParse(valor?.toString() ?? '') ?? 0;
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

  void _abrirMaterias(Map<String, dynamic> curso) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MateriasScreen(curso: curso)),
    );
  }

  void _abrirCriarCurso() {
    _abrirFormularioCurso();
  }

  void _abrirEditarCurso(Map<String, dynamic> curso) {
    _abrirFormularioCurso(curso: curso);
  }

  void _abrirFormularioCurso({Map<String, dynamic>? curso}) {
    final isEdicao = curso != null;
    final cursoId = _parseId(curso?['id']);

    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _CursoFormSheet(
          cursoId: isEdicao ? cursoId : null,
          tituloInicial: curso?['titulo']?.toString() ?? '',
          descricaoInicial: curso?['descricao']?.toString() ?? '',
          isEdicao: isEdicao,
          onSalvar: _salvarCurso,
        );
      },
    ).then((salvou) {
      if (salvou != true || !mounted) {
        return;
      }

      _mostrarMensagem(
        isEdicao ? 'Curso atualizado!' : 'Curso criado!',
        Colors.green,
      );
    });
  }

  Future<bool> _salvarCurso({
    int? id,
    required String titulo,
    required String descricao,
  }) async {
    if (titulo.trim().isEmpty) {
      return false;
    }

    if (mounted) {
      setState(() {
        _salvando = true;
      });
    }

    try {
      final dados = {'titulo': titulo.trim(), 'descricao': descricao.trim()};

      if (id == null || id <= 0) {
        await ApiService.createCurso(dados);
      } else {
        await ApiService.updateCurso(id, dados);
      }

      await _carregar();

      return true;
    } catch (e) {
      if (!mounted) return false;

      _mostrarMensagem(
        id == null || id <= 0
            ? 'Erro ao criar curso: $e'
            : 'Erro ao atualizar curso: $e',
        Colors.red,
      );

      return false;
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  Future<void> _matricular(int cursoId) async {
    if (cursoId <= 0) {
      _mostrarMensagem('Curso inválido.', Colors.redAccent);
      return;
    }

    try {
      await ApiService.matricular(cursoId);

      if (!mounted) return;

      _mostrarMensagem('Matriculado com sucesso!', Colors.green);
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem('Erro ao matricular: $e', Colors.red);
    }
  }

  Future<void> _deletarCurso(int id) async {
    if (!_isAdmin) {
      _mostrarMensagem(
        'Somente administradores podem excluir cursos.',
        Colors.orange,
      );
      return;
    }

    if (id <= 0) {
      _mostrarMensagem('Curso inválido.', Colors.redAccent);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111C3D),
          title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Deseja deletar este curso?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await ApiService.deleteCurso(id);
      await _carregar();

      if (!mounted) return;

      _mostrarMensagem('Curso removido.', Colors.red);
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem('Erro ao deletar curso: $e', Colors.red);
    }
  }

  Widget _cardCurso(Map<String, dynamic> curso) {
    final id = _parseId(curso['id']);
    final titulo = curso['titulo']?.toString() ?? 'Sem título';
    final descricao = curso['descricao']?.toString() ?? '';
    final publicado = curso['publicado'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _abrirMaterias(curso),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A6CFF), Color(0xFF7B3FFF)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (publicado)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Publicado',
                            style: TextStyle(color: Colors.green, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descricao,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirMaterias(curso),
                      icon: const Icon(
                        Icons.menu_book_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Ver matérias',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_userTipo == 'aluno')
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _matricular(id),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4A6CFF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Matricular-se',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (_isProfessorOuAdmin)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _abrirEditarCurso(curso),
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF4A6CFF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        if (_isAdmin) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _deletarCurso(id),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoErro() {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 140),
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _erro ?? 'Erro ao carregar cursos.',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _carregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoVazio() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 160),
        const Icon(Icons.school_outlined, color: Colors.white30, size: 64),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Nenhum curso disponível',
            style: TextStyle(color: Colors.white54),
          ),
        ),
        if (_isProfessorOuAdmin) ...[
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _salvando ? null : _abrirCriarCurso,
              icon: const Icon(Icons.add),
              label: const Text('Criar primeiro curso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6CFF),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _listaCursos() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cursos.length,
      itemBuilder: (_, index) {
        final item = _cursos[index];

        if (item is! Map) {
          return const SizedBox.shrink();
        }

        final curso = Map<String, dynamic>.from(item);
        return _cardCurso(curso);
      },
    );
  }

  Widget _body() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return _estadoErro();
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: _cursos.isEmpty ? _estadoVazio() : _listaCursos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cursos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isProfessorOuAdmin)
            IconButton(
              onPressed: _salvando ? null : _abrirCriarCurso,
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Criar Curso',
            ),
        ],
      ),
      body: _body(),
    );
  }
}

class _CursoFormSheet extends StatefulWidget {
  final int? cursoId;
  final String tituloInicial;
  final String descricaoInicial;
  final bool isEdicao;
  final SalvarCursoCallback onSalvar;

  const _CursoFormSheet({
    required this.cursoId,
    required this.tituloInicial,
    required this.descricaoInicial,
    required this.isEdicao,
    required this.onSalvar,
  });

  @override
  State<_CursoFormSheet> createState() => _CursoFormSheetState();
}

class _CursoFormSheetState extends State<_CursoFormSheet> {
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descricaoCtrl;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    _tituloCtrl = TextEditingController(text: widget.tituloInicial);
    _descricaoCtrl = TextEditingController(text: widget.descricaoInicial);
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
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

  Future<void> _salvar() async {
    if (_salvando) return;

    final titulo = _tituloCtrl.text.trim();
    final descricao = _descricaoCtrl.text.trim();

    if (titulo.isEmpty) {
      _mostrarMensagem('Informe o título do curso.', Colors.orange);
      return;
    }

    setState(() {
      _salvando = true;
    });

    final ok = await widget.onSalvar(
      id: widget.cursoId,
      titulo: titulo,
      descricao: descricao,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _salvando = false;
    });
  }

  Widget _campo(
    TextEditingController controller,
    String hint, {
    int linhas = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: linhas,
        enabled: !_salvando,
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

  Widget _botaoSalvar() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _salvando ? null : _salvar,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6CFF),
          disabledBackgroundColor: const Color(0xFF26345F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _salvando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                widget.isEdicao ? 'Salvar Alterações' : 'Criar Curso',
                style: const TextStyle(
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
    final altura = MediaQuery.of(context).size.height * 0.65;
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
              widget.isEdicao ? 'Editar Curso' : 'Criar Novo Curso',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    _campo(_tituloCtrl, 'Título do curso'),
                    const SizedBox(height: 12),
                    _campo(_descricaoCtrl, 'Descrição do curso', linhas: 3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _botaoSalvar(),
          ],
        ),
      ),
    );
  }
}
