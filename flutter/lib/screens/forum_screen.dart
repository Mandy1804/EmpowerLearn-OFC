import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<dynamic> _posts = [];
  bool _carregando = true;
  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    _carregarPosts();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _nomeUsuario = prefs.getString('userNome') ?? 'Usuário';
    });
  }

  Future<void> _carregarPosts() async {
    if (mounted) {
      setState(() {
        _carregando = true;
      });
    }

    try {
      final posts = await ApiService.getForumPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
      });
    }
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

  void _criarPost() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const _CreateForumPostSheet();
      },
    ).then((criou) async {
      if (criou != true || !mounted) {
        return;
      }

      _mostrarMensagem('Discussão publicada!', Colors.green);
      await _carregarPosts();
    });
  }

  String _inicialUsuario() {
    final nome = _nomeUsuario.trim();

    if (nome.isEmpty) {
      return 'U';
    }

    return nome[0].toUpperCase();
  }

  Widget _estadoVazio() {
    return const Center(
      child: Text(
        'Nenhuma discussão ainda.',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget _listaPosts() {
    return RefreshIndicator(
      onRefresh: _carregarPosts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _posts.length,
        itemBuilder: (_, index) {
          final post = _posts[index];

          final titulo = post['titulo']?.toString() ?? 'Discussão';
          final conteudo = post['conteudo']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.blue,
                      child: Text(
                        _inicialUsuario(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (conteudo.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(conteudo, style: const TextStyle(color: Colors.white70)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _body() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return _estadoVazio();
    }

    return _listaPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _criarPost,
        backgroundColor: AppColors.blue,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'Nova Discussão',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Discussões',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }
}

class _CreateForumPostSheet extends StatefulWidget {
  const _CreateForumPostSheet();

  @override
  State<_CreateForumPostSheet> createState() => _CreateForumPostSheetState();
}

class _CreateForumPostSheetState extends State<_CreateForumPostSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _publicando = false;

  @override
  void dispose() {
    _controller.dispose();
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

  Future<void> _publicar() async {
    if (_publicando) return;

    final conteudo = _controller.text.trim();

    if (conteudo.isEmpty) {
      _mostrarMensagem('Escreva o conteúdo da discussão.', Colors.orange);
      return;
    }

    setState(() {
      _publicando = true;
    });

    try {
      await ApiService.createForumPost(conteudo);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _publicando = false;
      });

      _mostrarMensagem('Erro ao publicar discussão: $e', Colors.redAccent);
    }
  }

  Widget _campoConteudo() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller,
        maxLines: 8,
        enabled: !_publicando,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'O que você gostaria de compartilhar hoje?',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _botaoPublicar() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: _publicando ? null : _publicar,
        icon: _publicando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send),
        label: Text(
          _publicando ? 'Publicando...' : 'Publicar Discussão',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          disabledBackgroundColor: const Color(0xFF26345F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
            const Text(
              'Criar Nova Discussão',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Compartilhe dúvidas, experiências e conhecimentos com outros alunos.',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: _campoConteudo(),
              ),
            ),
            const SizedBox(height: 16),
            _botaoPublicar(),
          ],
        ),
      ),
    );
  }
}
