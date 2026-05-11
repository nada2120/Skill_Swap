import 'dart:async';
import 'dart:convert';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static const String _appKey = 'e3ac92c762aaed1a23ae';
  static const String _cluster = 'mt1';

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final Map<String, bool> _subscribedChannels = {};
  String? _currentUserId;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool _isConnecting = false;

  final List<String> _pendingSubscriptions = [];
  Completer<void>? _connectionCompleter;

  // ================= INIT =================

  Future<void> init({required String userId}) async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _currentUserId = userId;
    _connectionCompleter = Completer<void>();

    try {
      await _pusher.init(
        apiKey: _appKey,
        cluster: _cluster,
        onConnectionStateChange: (current, previous) {
          print("🔌 Connection: $current");
        },
        onError: (message, code, error) {
          print("❌ Pusher error: $message");
        },
        onEvent: (event) {
          _handleEvent(event);
        },
      );

      await _pusher.connect();

      _isConnected = true;
      _isConnecting = false;

      _subscribeToUserChannel(userId);

      await _processPendingSubscriptions();

      if (!_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }

      print("✅ Pusher connected");
    } catch (e) {
      _isConnecting = false;
      print("❌ Pusher init failed $e");
    }
  }

  Future<void> get whenConnected async {
    if (_isConnected) return;
    await _connectionCompleter?.future;
  }

  // ================= USER CHANNEL =================

  void _subscribeToUserChannel(String userId) async {
    final channelName = "user-$userId";

    if (_subscribedChannels.containsKey(channelName)) return;

    await _pusher.subscribe(channelName: channelName);

    _subscribedChannels[channelName] = true;

    print("📡 Subscribed to $channelName");
  }

  // ================= CHAT CHANNEL =================

  Future<void> subscribeToChat({
    required String chatId,
  }) async {
    final channelName = chatId;

    if (_subscribedChannels.containsKey(channelName)) return;

    if (!_isConnected) {
      if (!_pendingSubscriptions.contains(channelName)) {
        _pendingSubscriptions.add(channelName);
      }
      return;
    }

    await _pusher.subscribe(channelName: channelName);

    _subscribedChannels[channelName] = true;

    print("📡 Subscribed to chat $channelName");
  }

  Future<void> unsubscribeFromChat(String chatId) async {
    final channelName = chatId;

    _pendingSubscriptions.remove(channelName);

    if (_subscribedChannels.containsKey(channelName)) {
      await _pusher.unsubscribe(channelName: channelName);

      _subscribedChannels.remove(channelName);

      print("📡 Unsubscribed from $channelName");
    }
  }

  Future<void> _processPendingSubscriptions() async {
    final pending = List<String>.from(_pendingSubscriptions);

    _pendingSubscriptions.clear();

    for (final channelName in pending) {
      if (_subscribedChannels.containsKey(channelName)) continue;

      await _pusher.subscribe(channelName: channelName);

      _subscribedChannels[channelName] = true;

      print("📡 Subscribed (queued) $channelName");
    }
  }

  // ================= EVENTS =================

  void _handleEvent(PusherEvent event) {
    if (event.data == null) return;

    // Forward receive_message, message_edited, and message_deleted events
    final supportedEvents = [
      'receive_message',
      'message_edited',
      'message_deleted',
      'messages_read'
    ];
    if (!supportedEvents.contains(event.eventName)) return;

    try {
      final data = jsonDecode(event.data!);

      data["_pusherChannel"] = event.channelName;
      data["_eventType"] = event.eventName;

      _messageController.add(data);

      print("📨 ${event.eventName} from ${event.channelName}");
    } catch (e) {
      print("❌ parse error $e");
    }
  }

  // ================= DISCONNECT =================

  Future<void> disconnect() async {
    for (final channel in _subscribedChannels.keys) {
      await _pusher.unsubscribe(channelName: channel);
    }

    _subscribedChannels.clear();

    await _pusher.disconnect();

    _isConnected = false;
    _isConnecting = false;

    print("🔌 Pusher disconnected");
  }

  void dispose() {
    _messageController.close();
  }
}

final pusherService = PusherService();
