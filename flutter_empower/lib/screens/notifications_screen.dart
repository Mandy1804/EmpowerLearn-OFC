import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen
    extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationModel(
        title:
            "Novo comentário na sua publicação",
        subtitle:
            "Sarah respondeu sua dúvida.",
        time: "5 min",
      ),
      NotificationModel(
        title:
            "Curtiram sua publicação",
        subtitle:
            "Michael curtiu seu post.",
        time: "20 min",
      ),
      NotificationModel(
        title: "Novo curso disponível",
        subtitle:
            "React Avançado foi liberado.",
        time: "1h",
      ),
      NotificationModel(
        title: "Meta concluída",
        subtitle:
            "Você concluiu sua meta semanal.",
        time: "3h",
      ),
    ];

    return Scaffold(
      backgroundColor:
          const Color(0xFF081225),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF081225),
        title: const Text(
          "Notificações",
        ),
      ),

      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          return NotificationCard(
            notification:
                notifications[index],
          );
        },
      ),
    );
  }
}