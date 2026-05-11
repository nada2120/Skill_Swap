import 'package:flutter_bloc/flutter_bloc.dart';

import 'call_services.dart';

class CallCubit extends Cubit<String> {
  final CallService service;

  CallCubit(this.service) : super("idle");

  Future<void> createCall({
    required String roomId,
    required String callerId,
    required String receiverId,
  }) async {
    emit("loading");

    await service.createCall(
      roomId: roomId,
      callerId: callerId,
      receiverId: receiverId,
    );

    emit("ringing");
  }

  Future<void> acceptCall(String roomId) async {
    await service.acceptCall(roomId);
    emit("accepted");
  }

  Future<void> endCall(String roomId) async {
    await service.endCall(roomId);
    emit("ended");
  }
}