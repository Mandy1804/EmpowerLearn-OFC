import 'package:flutter/material.dart';

import '../screens/forum_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/courses_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    this.currentIndex = 0,
  });

  void _onTap(
    BuildContext context,
    int index,
  ) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const HomeScreen(),
          ),
          (route) => false,
        );
        break;


        case 1:
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => CoursesScreen(),
    ),
    (route) => false,
  );
  break;

      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const ForumScreen(),
          ),
          (route) => false,
        );
        break;

      case 4:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const ProfileScreen(),
          ),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BottomNavigationBar(
      backgroundColor:
          const Color(0xFF08111F),

      selectedItemColor:
          Colors.white,

      unselectedItemColor:
          Colors.white54,

      type:
          BottomNavigationBarType.fixed,

      currentIndex: currentIndex,

      onTap: (index) =>
          _onTap(context, index),

      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Início',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_outlined,
          ),
          label: 'Cursos',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.task_alt_outlined,
          ),
          label: 'Tarefas',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.forum_outlined,
          ),
          label: 'Fórum',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}