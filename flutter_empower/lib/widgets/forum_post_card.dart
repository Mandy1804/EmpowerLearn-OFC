import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';
import '../theme/app_colors.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostModel post;

  const ForumPostCard({super.key, required this.post});

  static const List<List<Color>> _avatarGradients = [
    [Color(0xFF5B5FFF), Color(0xFF9B59FF)],
    [Color(0xFF00BFA5), Color(0xFF1DE9B6)],
    [Color(0xFF00C853), Color(0xFF69F0AE)],
    [Color(0xFFFF6D00), Color(0xFFFFAB40)],
    [Color(0xFFD500F9), Color(0xFFEA80FC)],
  ];

  Color get _roleColor =>
      post.authorRole == 'Instrutor' ? AppColors.blue : AppColors.purple;

  @override
  Widget build(BuildContext context) {
    final gradient = _avatarGradients[post.avatarColorIndex % _avatarGradients.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.isPinned) ...[
            Row(
              children: const [
                Text('📌 ', style: TextStyle(fontSize: 13)),
                Text(
                  'Fixado',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    post.authorInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _roleColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.authorRole,
                            style: TextStyle(
                              color: _roleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${post.course} • ${post.timeAgo}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            post.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _ActionButton(
                icon: Icons.favorite_border,
                count: post.likes,
                activeColor: Colors.pinkAccent,
              ),
              const SizedBox(width: 20),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                count: post.comments,
                activeColor: AppColors.blue,
              ),
              const Spacer(),
              const Icon(
                Icons.share_outlined,
                color: Colors.white38,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color activeColor;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 19),
        const SizedBox(width: 5),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}