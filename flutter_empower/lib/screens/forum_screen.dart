import 'package:flutter/material.dart';

import '../dialogs/comment_dialog.dart';
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

  final List<ForumPostModel> _posts = [
    ForumPostModel(
      authorName: 'Sarah Johnson',
      authorInitials: 'SJ',
      authorRole: 'Instrutor',
      course: 'React Avançado',
      timeAgo: 'há 2h',
      content: 'Revisem Redux Toolkit.',
      likes: 24,
      comments: 8,
      isPinned: true,
    ),
    ForumPostModel(
      authorName: 'Michael Chen',
      authorInitials: 'MC',
      authorRole: 'Estudante',
      course: 'React Avançado',
      timeAgo: 'há 5h',
      content: 'Dúvidas sobre useCallback.',
      likes: 12,
      comments: 15,
    ),
  ];

  List<ForumPostModel> get _filteredPosts {
    if (_selectedFilter == 0) {
      return _posts;
    }

    return _posts.where((post) {
      return post.course == _filters[_selectedFilter];
    }).toList();
  }

  void _createPost() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  24,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Criar Nova Discussão",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Compartilhe dúvidas, experiências e conhecimentos com outros alunos.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 10,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          "O que você gostaria de compartilhar hoje?",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.all(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.blue,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Seja respeitoso e contribua para uma comunidade colaborativa.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text(
                      "Publicar Discussão",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.blue,
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),
                    ),
                    onPressed: () {
                      if (controller.text
                          .trim()
                          .isNotEmpty) {
                        setState(() {
                          _posts.insert(
                            0,
                            ForumPostModel(
                              authorName: "Amanda",
                              authorInitials: "AM",
                              authorRole: "Estudante",
                              course:
                                  "React Avançado",
                              timeAgo: "agora",
                              content:
                                  controller.text,
                              likes: 0,
                              comments: 0,
                            ),
                          );
                        });

                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: const BottomNav(
        currentIndex: 3,
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _createPost,
        backgroundColor: AppColors.blue,
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: const Text(
          "Nova Discussão",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Discussões",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _filteredPosts.length,
                itemBuilder: (_, index) {
                  final post =
                      _filteredPosts[index];

                  return ForumPostCard(
                    post: post,
                    onLike: () {
                      setState(() {
                        if (post.liked) {
                          post.likes--;
                        } else {
                          post.likes++;
                        }

                        post.liked =
                            !post.liked;
                      });
                    },
                    onComment: () {
                      CommentDialog.open(
                        context,
                        post,
                        () {
                          setState(() {});
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}