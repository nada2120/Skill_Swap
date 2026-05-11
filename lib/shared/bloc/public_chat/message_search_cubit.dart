import 'package:bloc/bloc.dart';

import '../../domain/repositories/chat_repository.dart';
import 'message_search_state.dart';

class MessageSearchCubit extends Cubit<MessageSearchState> {
  final ChatRepository chatRepository;

  MessageSearchCubit({required this.chatRepository})
      : super(MessageSearchInitial());

  int _requestId = 0; // ✅ بدل _lastQuery

  Future<void> searchMessages(String chatId, String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      emit(MessageSearchInitial());
      return;
    }

    final currentRequestId = ++_requestId; // ✅ كل call ليها ID فريد

    emit(MessageSearchLoading());

    try {
      final results = await chatRepository.searchMessages(chatId, cleanQuery);

      if (_requestId != currentRequestId)
        return; // ✅ لو في request أحدث، ignore

      emit(MessageSearchLoaded(results: results, query: cleanQuery));
    } catch (e) {
      if (_requestId != currentRequestId) return;

      emit(MessageSearchError(e.toString()));
    }
  }

  void clearSearch() {
    _requestId = 0;
    emit(MessageSearchInitial());
  }
}
