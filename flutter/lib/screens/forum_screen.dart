import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _carregarPosts();
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

  Map<String, dynamic>? _autorDoPost(dynamic post) {
    if (post is! Map) return null;

    final autor = post['autor'] ?? post['usuario'] ?? post['user'];

    if (autor is Map<String, dynamic>) return autor;
    if (autor is Map) return Map<String, dynamic>.from(autor);

    return null;
  }

  String _nomeAutor(dynamic post) {
    if (post is Map) {
      final nomeDireto =
          post['autorNome'] ?? post['usuarioNome'] ?? post['nomeAutor'];

      final textoDireto = nomeDireto?.toString().trim() ?? '';

      if (textoDireto.isNotEmpty && textoDireto != 'null') {
        return textoDireto;
      }
    }

    final autor = _autorDoPost(post);

    final nome =
        autor?['nome'] ??
        autor?['name'] ??
        autor?['nomeCompleto'] ??
        autor?['email'];

    final texto = nome?.toString().trim() ?? '';

    if (texto.isEmpty || texto == 'null') {
      return 'Usuário';
    }

    return texto;
  }

  String _tipoAutor(dynamic post) {
    if (post is Map) {
      final tipoDireto = post['autorTipo'] ?? post['usuarioTipo'];
      final textoDireto = tipoDireto?.toString().trim() ?? '';

      if (textoDireto.isNotEmpty && textoDireto != 'null') {
        return textoDireto;
      }
    }

    final autor = _autorDoPost(post);
    final tipo = autor?['tipo']?.toString().trim() ?? '';

    return tipo;
  }

  String _inicialAutor(dynamic post) {
    final nome = _nomeAutor(post).trim();

    if (nome.isEmpty) return 'U';

    return nome[0].toUpperCase();
  }

  String? _fotoAutor(dynamic post) {
    if (post is Map) {
      final fotoDireta =
          post['autorFoto'] ?? post['usuarioFoto'] ?? post['fotoAutor'];

      final textoDireto = fotoDireta?.toString().trim() ?? '';

      if (textoDireto.startsWith('http://') ||
          textoDireto.startsWith('https://') ||
          textoDireto.startsWith('data:image')) {
        return textoDireto;
      }
    }

    final autor = _autorDoPost(post);

    final foto =
        autor?['fotoUrl'] ??
        autor?['foto'] ??
        autor?['fotoPerfil'] ??
        autor?['avatar'] ??
        autor?['avatarUrl'] ??
        autor?['imagem'] ??
        autor?['imagemPerfil'] ??
        autor?['profileImage'] ??
        autor?['profileImageUrl'];

    final texto = foto?.toString().trim() ?? '';

    if (texto.startsWith('http://') ||
        texto.startsWith('https://') ||
        texto.startsWith('data:image')) {
      return texto;
    }

    return null;
  }

  Widget _avatarAutor(dynamic post) {
    final foto = _fotoAutor(post);

    if (foto != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.blue,
        backgroundImage: NetworkImage(foto),
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.blue,
      child: Text(
        _inicialAutor(post),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

          final conteudo = post['conteudo']?.toString().trim() ?? '';
          final nomeAutor = _nomeAutor(post);
          final tipoAutor = _tipoAutor(post);

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _avatarAutor(post),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeAutor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          if (tipoAutor.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              tipoAutor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (conteudo.isNotEmpty) ...[
                  const SizedBox(height: 12),
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
