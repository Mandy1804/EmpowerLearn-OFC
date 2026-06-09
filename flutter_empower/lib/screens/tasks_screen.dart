import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int selectedFilter = 0;

  final List<TaskModel> tasks = [
    TaskModel(
      title: "Projeto de Gerenciamento de Estado",
      course: "React Avançado",
      date: "12 Mar",
      points: 100,
      attachments: 2,
      color: Colors.cyan,
      status: "A Fazer",
    ),
    TaskModel(
      title: "Implementação de Rede Neural",
      course: "Fundamentos de IA",
      date: "10 Mar",
      points: 150,
      attachments: 1,
      color: Colors.pink,
      status: "Fazendo",
    ),
    TaskModel(
      title: "Pesquisa UX",
      course: "UX Design Thinking",
      date: "08 Mar",
      points: 80,
      attachments: 3,
      color: Colors.green,
      status: "Enviados",
    ),
    TaskModel(
      title: "Projeto Final React",
      course: "React Avançado",
      date: "05 Mar",
      points: 100,
      attachments: 2,
      color: Colors.orange,
      status: "Avaliados",
    ),
  ];

  List<String> get filters => [
        "A Fazer (${tasks.where((e) => e.status == "A Fazer").length})",
        "Fazendo (${tasks.where((e) => e.status == "Fazendo").length})",
        "Enviados (${tasks.where((e) => e.status == "Enviados").length})",
        "Avaliados (${tasks.where((e) => e.status == "Avaliados").length})",
      ];

  List<TaskModel> get filteredTasks {
    switch (selectedFilter) {
      case 0:
        return tasks
            .where((e) => e.status == "A Fazer")
            .toList();

      case 1:
        return tasks
            .where((e) => e.status == "Fazendo")
            .toList();

      case 2:
        return tasks
            .where((e) => e.status == "Enviados")
            .toList();

      case 3:
        return tasks
            .where((e) => e.status == "Avaliados")
            .toList();

      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(
        currentIndex: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    "Atividades",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      "Pendentes",
                      tasks
                          .where((e) =>
                              e.status == "A Fazer")
                          .length
                          .toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      "Nota Média",
                      "92%",
                      valueColor:
                          Colors.greenAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (_, index) {
                    final selected =
                        selectedFilter == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(
                          right: 10,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(
                                  0xFF6C63FF)
                              : const Color(
                                  0xFF111C3D),
                          borderRadius:
                              BorderRadius.circular(
                                  16),
                        ),
                        child: Text(
                          filters[index],
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount:
                      filteredTasks.length,
                  itemBuilder: (_, index) {
                    return TaskCard(
                      task:
                          filteredTasks[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 32,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}