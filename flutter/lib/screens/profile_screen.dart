import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login_page.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/profile_setting_tile.dart';
import '../widgets/profile_stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nome = '';
  String email = '';
  String tipo = 'aluno';
  String? fotoUrl;

  bool carregando = true;
  bool carregandoFoto = false;

  List<dynamic> cursos = [];
  List<dynamic> matriculas = [];
  List<dynamic> tarefas = [];
  List<dynamic> submissoes = [];
  List<dynamic> progresso = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  bool get _isAluno => tipo.toLowerCase() == 'aluno';

  bool get _isProfessor => tipo.toLowerCase() == 'professor';

  bool get _isAdmin => tipo.toLowerCase() == 'admin';

  String get _tipoNormalizado => tipo.toLowerCase().trim();

  String get _tipoLabel {
    switch (_tipoNormalizado) {
      case 'professor':
        return 'Professor';
      case 'admin':
        return 'Administrador';
      default:
        return 'Aluno';
    }
  }

  String get _subtituloPerfil {
    if (_isProfessor) {
      return 'Perfil docente';
    }

    if (_isAdmin) {
      return 'Perfil administrativo';
    }

    return 'Perfil do estudante';
  }

  String get _inicial {
    final nomeLimpo = nome.trim();

    if (nomeLimpo.isEmpty) {
      return 'U';
    }

    return nomeLimpo[0].toUpperCase();
  }

  String? get _fotoUrlCompleta {
    final valor = fotoUrl?.trim();

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

  Future<void> _carregarPerfil() async {
    if (mounted) {
      setState(() {
        carregando = true;
      });
    }

    final prefs = await SharedPreferences.getInstance();

    var nomeCarregado = prefs.getString('userNome') ?? 'Usuário';
    var emailCarregado = prefs.getString('userEmail') ?? '';
    var tipoCarregado = prefs.getString('userTipo') ?? 'aluno';
    var fotoCarregada = prefs.getString('userFotoUrl');

    final perfil = await _buscarPerfilSeguro();

    if (perfil != null) {
      final nomePerfil = perfil['nome']?.toString();
      final emailPerfil = perfil['email']?.toString();
      final tipoPerfil = perfil['tipo']?.toString();
      final fotoPerfil = perfil['fotoUrl'] ?? perfil['foto_url'];

      if (nomePerfil != null && nomePerfil.trim().isNotEmpty) {
        nomeCarregado = nomePerfil.trim();
        await prefs.setString('userNome', nomeCarregado);
      }

      if (emailPerfil != null && emailPerfil.trim().isNotEmpty) {
        emailCarregado = emailPerfil.trim();
        await prefs.setString('userEmail', emailCarregado);
      }

      if (tipoPerfil != null && tipoPerfil.trim().isNotEmpty) {
        tipoCarregado = tipoPerfil.trim().toLowerCase();
        await prefs.setString('userTipo', tipoCarregado);
      }

      if (fotoPerfil != null && fotoPerfil.toString().trim().isNotEmpty) {
        fotoCarregada = fotoPerfil.toString().trim();
        await prefs.setString('userFotoUrl', fotoCarregada);
      }
    }

    final cursosCarregados = await _buscarListaSegura(ApiService.getCursos);
    final tarefasCarregadas = await _buscarListaSegura(
      () => ApiService.getTarefas(0),
    );

    var matriculasCarregadas = <dynamic>[];
    var progressoCarregado = <dynamic>[];
    var submissoesCarregadas = <dynamic>[];

    final tipoFinal = tipoCarregado.toLowerCase();

    if (tipoFinal == 'aluno') {
      matriculasCarregadas = await _buscarListaSegura(
        ApiService.getMinhasMatriculas,
      );
      progressoCarregado = await _buscarListaSegura(ApiService.getMeuProgresso);
    }

    if (tipoFinal == 'professor' || tipoFinal == 'admin') {
      submissoesCarregadas = await _buscarListaSegura(
        () => ApiService.getSubmissoes(0),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      nome = nomeCarregado;
      email = emailCarregado;
      tipo = tipoFinal;
      fotoUrl = fotoCarregada;
      cursos = cursosCarregados;
      tarefas = tarefasCarregadas;
      matriculas = matriculasCarregadas;
      progresso = progressoCarregado;
      submissoes = submissoesCarregadas;
      carregando = false;
    });
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  int _parseId(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _foiEnviadaPeloAluno(dynamic tarefa) {
    final lista = tarefa['submissoes'];

    if (lista is! List) {
      return false;
    }

    return lista.any((item) {
      final submissao = _asMap(item);
      final alunoId = _parseId(submissao?['alunoId']);

      return alunoId > 0;
    });
  }

  List<dynamic> get _tarefasPendentesAluno {
    return tarefas.where((tarefa) => !_foiEnviadaPeloAluno(tarefa)).toList();
  }

  List<dynamic> get _tarefasEnviadasAluno {
    return tarefas.where((tarefa) => _foiEnviadaPeloAluno(tarefa)).toList();
  }

  bool _cursoDoProfessor(dynamic curso) {
    final item = _asMap(curso);
    final professorId = _parseId(
      item?['professorId'] ?? item?['criadorId'] ?? item?['usuarioId'],
    );

    return professorId > 0;
  }

  List<dynamic> get _cursosProfessor {
    final filtrados = cursos.where(_cursoDoProfessor).toList();

    if (filtrados.isNotEmpty) {
      return filtrados;
    }

    return cursos;
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

    return professorId > 0;
  }

  List<dynamic> get _tarefasProfessor {
    if (_isAdmin) {
      return tarefas;
    }

    final filtradas = tarefas.where(_tarefaDoProfessor).toList();

    if (filtradas.isNotEmpty) {
      return filtradas;
    }

    return tarefas;
  }

  List<dynamic> get _submissoesProfessor {
    if (_isAdmin) {
      return submissoes;
    }

    final idsTarefas = _tarefasProfessor
        .map((tarefa) => _parseId(tarefa['id']))
        .where((id) => id > 0)
        .toSet();

    if (idsTarefas.isEmpty) {
      return submissoes;
    }

    return submissoes.where((submissao) {
      final item = _asMap(submissao);
      final tarefa = _asMap(item?['tarefa']);
      final tarefaId = _parseId(item?['tarefaId'] ?? tarefa?['id']);

      return idsTarefas.contains(tarefaId);
    }).toList();
  }

  Future<void> _selecionarFoto() async {
    try {
      final picker = ImagePicker();

      final imagem = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imagem == null) {
        return;
      }

      if (mounted) {
        setState(() {
          carregandoFoto = true;
        });
      }

      final bytes = await imagem.readAsBytes();

      final resposta = await ApiService.uploadFotoPerfil(
        fileName: imagem.name,
        bytes: bytes,
      );

      final usuario = resposta['user'] is Map<String, dynamic>
          ? resposta['user'] as Map<String, dynamic>
          : resposta['usuario'] is Map<String, dynamic>
          ? resposta['usuario'] as Map<String, dynamic>
          : <String, dynamic>{};

      final novaFoto =
          resposta['fotoUrl'] ?? usuario['fotoUrl'] ?? usuario['foto_url'];

      if (!mounted) {
        return;
      }

      if (novaFoto == null || novaFoto.toString().trim().isEmpty) {
        throw Exception('Backend não retornou o caminho da foto');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userFotoUrl', novaFoto.toString());

      setState(() {
        fotoUrl = novaFoto.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto atualizada com sucesso')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar foto: $error')));
    } finally {
      if (mounted) {
        setState(() {
          carregandoFoto = false;
        });
      }
    }
  }

  Future<void> _editarPerfil() async {
    final nomeController = TextEditingController(text: nome);

    final salvou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              hintText: 'Digite seu nome',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    final novoNome = nomeController.text.trim();
    nomeController.dispose();

    if (!mounted || salvou != true) {
      return;
    }

    if (novoNome.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um nome válido')));
      return;
    }

    try {
      final resposta = await ApiService.updateMeuPerfil(nome: novoNome);

      final usuario = resposta['user'] is Map<String, dynamic>
          ? resposta['user'] as Map<String, dynamic>
          : resposta['usuario'] is Map<String, dynamic>
          ? resposta['usuario'] as Map<String, dynamic>
          : resposta;

      if (!mounted) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userNome', novoNome);

      setState(() {
        nome = usuario['nome']?.toString() ?? novoNome;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $error')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _mostrarEmDesenvolvimento(String titulo) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$titulo ainda está em desenvolvimento')),
    );
  }

  Widget _avatarInicial() {
    return Center(
      child: Text(
        _inicial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _avatar() {
    final fotoCompleta = _fotoUrlCompleta;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            gradient: fotoCompleta == null
                ? const LinearGradient(
                    colors: [Color(0xFF5B5FFF), Color(0xFFB245FF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: fotoCompleta == null
              ? _avatarInicial()
              : Image.network(
                  fotoCompleta,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _avatarInicial(),
                ),
        ),
        Material(
          color: Colors.blue,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: carregandoFoto ? null : _selecionarFoto,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: carregandoFoto
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsAluno() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ProfileStatCard(
            icon: Icons.menu_book,
            value: matriculas.length.toString(),
            label: 'Cursos',
            color: Colors.blue,
          ),
          ProfileStatCard(
            icon: Icons.pending_actions,
            value: _tarefasPendentesAluno.length.toString(),
            label: 'Pendentes',
            color: Colors.orange,
          ),
          ProfileStatCard(
            icon: Icons.outbox,
            value: _tarefasEnviadasAluno.length.toString(),
            label: 'Enviadas',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _statsProfessor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ProfileStatCard(
            icon: Icons.menu_book,
            value: _cursosProfessor.length.toString(),
            label: 'Cursos',
            color: Colors.blue,
          ),
          ProfileStatCard(
            icon: Icons.assignment,
            value: _tarefasProfessor.length.toString(),
            label: 'Tarefas',
            color: Colors.purple,
          ),
          ProfileStatCard(
            icon: Icons.inbox,
            value: _submissoesProfessor.length.toString(),
            label: 'Respostas',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _statsAdmin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ProfileStatCard(
            icon: Icons.menu_book,
            value: cursos.length.toString(),
            label: 'Cursos',
            color: Colors.blue,
          ),
          ProfileStatCard(
            icon: Icons.assignment,
            value: tarefas.length.toString(),
            label: 'Tarefas',
            color: Colors.purple,
          ),
          ProfileStatCard(
            icon: Icons.inbox,
            value: submissoes.length.toString(),
            label: 'Respostas',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _statsPorTipo() {
    if (_isProfessor) {
      return _statsProfessor();
    }

    if (_isAdmin) {
      return _statsAdmin();
    }

    return _statsAluno();
  }

  Widget _configuracoes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111C3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ProfileSettingTile(
                  icon: Icons.person_outline,
                  color: Colors.blue,
                  title: 'Editar Perfil',
                  onTap: _editarPerfil,
                ),
                ProfileSettingTile(
                  icon: Icons.notifications_none,
                  color: Colors.purple,
                  title: 'Notificações',
                  onTap: () => _mostrarEmDesenvolvimento('Notificações'),
                ),
                ProfileSettingTile(
                  icon: Icons.security,
                  color: Colors.green,
                  title: 'Segurança',
                  onTap: () => _mostrarEmDesenvolvimento('Segurança'),
                ),
                ProfileSettingTile(
                  icon: Icons.help_outline,
                  color: Colors.orange,
                  title: 'Ajuda & Suporte',
                  onTap: () => _mostrarEmDesenvolvimento('Ajuda & Suporte'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _cabecalhoPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF102448), Color(0xFF1C2463)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          _avatar(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              nome,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              email,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _tipoLabel,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _subtituloPerfil,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _statsPorTipo(),
        ],
      ),
    );
  }

  Widget _estadoCarregando() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF4A6CFF)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
      body: SafeArea(
        child: carregando
            ? _estadoCarregando()
            : RefreshIndicator(
                onRefresh: _carregarPerfil,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [_cabecalhoPerfil(), _configuracoes()],
                  ),
                ),
              ),
      ),
    );
  }
}
