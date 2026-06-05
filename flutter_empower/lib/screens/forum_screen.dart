import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/forum_post_card.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = [
    'Todos',
    'React Avançado',
    'Fundamentos de IA',
    'Design Thinking',
  ];

  final List<ForumPostModel> _posts = const [
    ForumPostModel(
      authorName: 'Sarah Johnson',
      authorInitials: 'SJ',
      authorRole: 'Instrutor',
      course: 'React Avançado',
      timeAgo: 'há 2h',
      content:
          '📢 A aula da próxima semana cobrirá padrões avançados de gerenciamento de estado. Revisem os materiais sobre Redux Toolkit!',
      likes: 24,
      comments: 8,
      isPinned: true,
      avatarColorIndex: 0,
    ),
    ForumPostModel(
      authorName: 'Michael Chen',
      authorInitials: 'MC',
      authorRole: 'Estudante',
      course: 'React Avançado',
      timeAgo: 'há 5h',
      content:
          'Alguém mais teve dificuldade para entender o hook useCallback? Estou tendo problemas para entender quando usá-lo em vez do useMemo.',
      likes: 12,
      comments: 15,
      avatarColorIndex: 1,
    ),
    ForumPostModel(
      authorName: 'Emma Rodriguez',
      authorInitials: 'ER',
      authorRole: 'Instrutor',
      course: 'Design Thinking',
      timeAgo: 'há 1 dia',
      content:
          'Ótimo trabalho nas apresentações de pesquisa com usuários hoje! Enviei feedback para cada equipe. Lembrem-se, empatia é o coração de um ótimo design. 👏',
      likes: 31,
      comments: 6,
      avatarColorIndex: 2,
    ),
    ForumPostModel(
      authorName: 'Alex Thompson',
      authorInitials: 'AT',
      authorRole: 'Estudante',
      course: 'React Avançado',
      timeAgo: 'há 1 dia',
      content:
          'Podemos usar bibliotecas externas como Framer Motion para animações no projeto de meio de semestre?',
      likes: 8,
      comments: 4,
      avatarColorIndex: 3,
    ),
    ForumPostModel(
      authorName: 'Jessica Martinez',
      authorInitials: 'JM',
      authorRole: 'Estudante',
      course: 'Fundamentos de IA',
      timeAgo: 'há 2 dias',
      content:
          'Compartilhando minha implementação da rede neural do exercício de hoje. Consegui uma acurácia de 94% no conjunto de validação usando dropout!',
      likes: 45,
      comments: 22,
      avatarColorIndex: 4,
    ),
  ];

  List<ForumPostModel> get _filteredPosts {
    if (_selectedFilter == 0) return _posts;
    final filter = _filters[_selectedFilter];
    return _posts.where((p) => p.course == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(currentIndex: 3),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  const Text(
                    'Discussões',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filtros
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final selected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.blue : AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          color: selected ? Colors.white : AppColors.textSecondary,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Lista de posts
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPosts.length,
                itemBuilder: (context, index) {
                  return ForumPostCard(post: _filteredPosts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}