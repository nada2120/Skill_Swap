import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_state.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository repository;

  UsersCubit(this.repository) : super(UsersInitial());

  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  final List<UserModel> _users = [];
  final Set<String> _userIds = {};

  Future<void> fetchUsers(
      {bool reset = false, bool topUsers = false, String? track}) async {
    if (_isLoadingMore) return;

    if (reset) {
      _currentPage = 1;
      _users.clear();
      _userIds.clear();
      _isLastPage = false;
      emit(UsersLoading());
    }

    if (_isLastPage) return;

    _isLoadingMore = true;

    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(isLoadingMore: true));
    }

    try {
      final newUsers = await repository.getAllUsers(
        page: _currentPage,
        limit: 10,
      );

      final uniqueNewUsers = newUsers.where((u) => _userIds.add(u.id)).toList();
      _users.addAll(uniqueNewUsers);

      List<UserModel> processedUsers = List.from(_users);
      if (topUsers) {
        processedUsers
            .sort((a, b) => b.helpTotalHours.compareTo(a.helpTotalHours));
      } else if (track != null) {
        processedUsers =
            processedUsers.where((u) => u.track.name == track).toList();
      }

      _isLastPage = newUsers.isEmpty;
      _isLoadingMore = false;

      emit(UsersLoaded(
        processedUsers,
        isLastPage: _isLastPage,
        isLoadingMore: false,
      ));

      _currentPage++;
    } catch (e) {
      _isLoadingMore = false;
      emit(UsersError(e.toString()));
    }
  }

  Future<List<UserModel>> getLeaderboardUsers({
    required int page,
    int limit = 100,
  }) async {
    final users = await repository.getUsersWithoutAdminOnly(
      page: page,
      limit: limit,
    );

    final uniqueUsers = <String, UserModel>{};

    for (var user in users) {
      uniqueUsers[user.id] = user;
    }

    final result = uniqueUsers.values.toList()
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return result;
  }

  Future<void> fetchNextPage() async {
    await fetchUsers();
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final user = _users.cast<UserModel?>().firstWhere(
            (u) => u?.id == id,
            orElse: () => null,
          );
      return user;
    } catch (_) {
      return null;
    }
  }
}
