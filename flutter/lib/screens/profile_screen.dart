import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/profile_setting_tile.dart';
import '../widgets/profile_stat_card.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nome = '';
  String email = '';
  String tipo = '';
  String? fotoUrl;
  bool carregandoFoto = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nome = prefs.getString('userNome') ?? 'Usuário';
      email = prefs.getString('userEmail') ?? '';
      tipo = prefs.getString('userTipo') ?? 'aluno';
      fotoUrl = prefs.getString('userFotoUrl');
    });

    try {
      final perfil = await ApiService.getMeuPerfil();

      if (!mounted) {
        return;
      }

      final novaFoto = perfil['fotoUrl'] ?? perfil['foto_url'];

      setState(() {
        nome = perfil['nome']?.toString() ?? nome;
        email = perfil['email']?.toString() ?? email;
        tipo = perfil['tipo']?.toString() ?? tipo;

        if (novaFoto != null && novaFoto.toString().isNotEmpty) {
          fotoUrl = novaFoto.toString();
        }
      });

      await prefs.setString('userNome', nome);
      await prefs.setString('userEmail', email);
      await prefs.setString('userTipo', tipo);

      if (fotoUrl != null && fotoUrl!.isNotEmpty) {
        await prefs.setString('userFotoUrl', fotoUrl!);
      }
    } catch (_) {
      // Mantém dados locais se o perfil remoto falhar.
    }
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

      setState(() {
        carregandoFoto = true;
      });

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

      if (novaFoto == null || novaFoto.toString().isEmpty) {
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

  String get _tipoLabel {
    switch (tipo) {
      case 'professor':
        return 'Professor';
      case 'admin':
        return 'Instituição';
      default:
        return 'Aluno';
    }
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

  Widget _avatar(String inicial) {
    final fotoCompleta = _fotoUrlCompleta;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: fotoCompleta == null
                ? const LinearGradient(
                    colors: [Color(0xFF5B5FFF), Color(0xFFB245FF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(24),
            image: fotoCompleta != null
                ? DecorationImage(
                    image: NetworkImage(fotoCompleta),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: fotoCompleta == null
              ? Center(
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
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

  @override
  Widget build(BuildContext context) {
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                    _avatar(inicial),
                    const SizedBox(height: 16),
                    Text(
                      nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
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
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          ProfileStatCard(
                            icon: Icons.menu_book,
                            value: '0',
                            label: 'Cursos',
                            color: Colors.blue,
                          ),
                          ProfileStatCard(
                            icon: Icons.workspace_premium,
                            value: '0',
                            label: 'GPA',
                            color: Colors.purple,
                          ),
                          ProfileStatCard(
                            icon: Icons.trending_up,
                            value: '0d',
                            label: 'Sequência',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          ProfileSettingTile(
                            icon: Icons.security,
                            color: Colors.green,
                            title: 'Segurança',
                            onTap: () {},
                          ),
                          ProfileSettingTile(
                            icon: Icons.help_outline,
                            color: Colors.orange,
                            title: 'Ajuda & Suporte',
                            onTap: () {},
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
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
