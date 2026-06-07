import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/profile_setting_tile.dart';
import '../widgets/profile_stat_card.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),

      bottomNavigationBar: const BottomNav(
        currentIndex: 4,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF102448),
                      Color(0xFF1C2463),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Perfil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5B5FFF),
                            Color(0xFFB245FF),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "A",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Amanda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "amanda@empowerlearn.class",
                      style: TextStyle(
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
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Membro Ativo",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          ProfileStatCard(
                            icon: Icons.menu_book,
                            value: "6",
                            label: "Cursos",
                            color: Colors.blue,
                          ),
                          ProfileStatCard(
                            icon: Icons.workspace_premium,
                            value: "3.8",
                            label: "GPA",
                            color: Colors.purple,
                          ),
                          ProfileStatCard(
                            icon: Icons.trending_up,
                            value: "14d",
                            label: "Sequência",
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Metas de Estudo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111C3D),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: const [
                              Text(
                                "Horas Semanais",
                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                              Text(
                                "20 / 25h",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                            child:
                                const LinearProgressIndicator(
                              value: 0.80,
                              minHeight: 8,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: const [
                              Text(
                                "Atividades do Mês",
                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                              Text(
                                "12 / 15",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                            child:
                                const LinearProgressIndicator(
                              value: 0.75,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Configurações",
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
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ProfileSettingTile(
                            icon:
                                Icons.person_outline,
                            color: Colors.blue,
                            title:
                                "Editar Perfil",
                            onTap: () {},
                          ),

                          ProfileSettingTile(
                            icon:
                                Icons.notifications_none,
                            color: Colors.purple,
                            title: "Notificações",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),

                          ProfileSettingTile(
                            icon: Icons.security,
                            color: Colors.green,
                            title: "Segurança",
                            onTap: () {},
                          ),

                          ProfileSettingTile(
                            icon:
                                Icons.help_outline,
                            color: Colors.orange,
                            title:
                                "Ajuda & Suporte",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Sair da Conta",
                          style: TextStyle(
                            color: Colors.red,
                          ),
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