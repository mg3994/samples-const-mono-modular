import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../core.dart' show NotificationMessagesCompanion;

// there will be watch and this watch will also do is it will compare sentime and ttl and will remove those expired notifications
extension RemoteMessageToNotificationMessageCompanion on RemoteMessage {
  NotificationMessagesCompanion toCompanion() {
    final notification = this.notification;

    return NotificationMessagesCompanion.insert(
      messageId: Value(messageId),
      senderId: Value(senderId),
      from: Value(from),
      messageType: Value(messageType),
      collapseKey: Value(collapseKey),
      category: Value(category),
      actionIdentifier: Value(actionIdentifier),
      contentAvailable: Value(contentAvailable),
      mutableContent: Value(mutableContent),
      ttl: Value(ttl),
      sentTime: Value(sentTime),
      title: Value(notification?.title),
      body: Value(notification?.body),
      imageUrl: Value(
        notification?.android?.imageUrl ??
            notification?.apple?.imageUrl ??
            notification?.web?.image,
      ),
      link: Value(notification?.android?.link ?? notification?.web?.link),
      data: Value(data.isEmpty ? null : jsonEncode(data)),
      isOpened: const Value(false),
      receivedAt: DateTime.now(),
    );
  }
}
