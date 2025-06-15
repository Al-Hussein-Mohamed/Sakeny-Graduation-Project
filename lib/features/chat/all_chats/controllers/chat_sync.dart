import 'dart:async';

import 'package:sakeny/features/chat/chat_screen/models/seen_model.dart';

class ChatSync {
  ChatSync._();

  static final StreamController<SeenModel> _seenController =
      StreamController<SeenModel>.broadcast();

  static Stream<SeenModel> get seenStream => _seenController.stream;

  static void add(SeenModel seenModel) {
    _seenController.add(seenModel);
  }

  static void dispose() {
    _seenController.close();
  }
}
