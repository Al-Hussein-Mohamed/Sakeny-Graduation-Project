import 'dart:async';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:sakeny/core/APIs/api_service.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/chat/chat_screen/models/message_model.dart';
import 'package:sakeny/features/chat/chat_screen/models/seen_model.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ChatHub {
  factory ChatHub() => _instance;

  ChatHub._internal();

  static final ChatHub _instance = ChatHub._internal();
  final Logger _hubLogger = Logger("SignalR - hub");
  final Logger _transportLogger = Logger("SignalR - transport");

  final String _hubUrl = ConstApi.chatHubUrl;

  HubConnection? _hubConnection;
  bool _isConnected = false;

  final StreamController<MessageModel> _messagesController =
      StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messagesStream => _messagesController.stream;

  final _seenController = StreamController<SeenModel>.broadcast();

  Stream<SeenModel> get seenStream => _seenController.stream;

  bool get isConnected => _isConnected;

  final SettingsProvider _settings = sl<SettingsProvider>();

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            options: HttpConnectionOptions(
              logger: _transportLogger,

              // Todo: refresh Hub stream token
              accessTokenFactory: () async {
                await ApiService.getUserData();
                return _settings.accessToken!;
              },
            ),
          )
          .configureLogging(_hubLogger)
          .withAutomaticReconnect()
          .build();

      _hubConnection!.on('NewMessage', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          log('New message received from SignalR: $arguments');
          try {
            final messageJson = Map<String, dynamic>.from(arguments[0] as Map);
            final message = MessageModel.fromJson((messageJson));

            _messagesController.add(message);
            log('Message received: ${message.content}');
            _hubLogger.fine('Message received: ${message.content}');
          } catch (e) {
            log('Error parsing message: $e');
            _hubLogger.severe('Error parsing message: $e');
          }
        }
      });

      _hubConnection!.on('Seen', (arguments) {
        if (arguments == null || arguments.isEmpty) return;
        log("new seen message received from SignalR: $arguments");
        try {
          final json = Map<String, dynamic>.from(arguments[0] as Map);
          final seenModel = SeenModel.fromJson(json);
          _seenController.add(seenModel);
          log('Seen message received: ${seenModel.messageId}');
          _hubLogger.fine('Seen message received: ${seenModel.messageId}');
        } catch (e) {
          log('Error parsing seen model: $e');
          _hubLogger.severe('Error parsing seen model: $e');
        }
      });

      await _hubConnection!.start();
      _isConnected = true;
      log('Connected to SignalR');
      _hubLogger.info('SignalR connected successfully');
    } catch (e) {
      _isConnected = false;
      log('Failed to connect to SignalR: $e');
      _hubLogger.severe('SignalR connection error: $e');
      throw Exception('Failed to connect to chat: $e');
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      log('SignalR disconnected');
      _hubLogger.info('Disconnecting from SignalR');
      await _hubConnection!.stop();
      _isConnected = false;
    }
  }

  void dispose() {
    disconnect();
    _messagesController.close();
    _hubLogger.info('SignalR service disposed');
  }
}
