import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/course_card.dart';
import 'course_details_screen.dart';

class CoursesScreen extends StatelessWidget {
  CoursesScreen({super.key});

  final List<CourseModel> courses = [
    CourseModel(
      title: "Desenvolvimento React Avançado",
      instructor: "Sarah Johnson",
      progress: 0.75,
      students: "1.2k",
      duration: "12 semanas",
    ),
    CourseModel(
      title: "Fundamentos de IA & Machine Learning",
      instructor: "Dr. Michael Chen",
      progress: 0.60,
      students: "2.1k",
      duration: "16 semanas",
    ),
    CourseModel(
      title: "UX Design Thinking",
      instructor: "Emma Rodriguez",
      progress: 0.85,
      students: "900",
      duration: "8 semanas",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),

      bottomNavigationBar: const BottomNav(
        currentIndex: 1,
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        title: const Text("Meus Cursos"),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (_, index) {
          final course = courses[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CourseDetailsScreen(
                    course: course,
                  ),
                ),
              );
            },
            child: CourseCard(
              title: course.title,
              subtitle: course.instructor,
              progress: course.progress,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}