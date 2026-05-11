import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';
import 'package:skill_swap/shared/data/models/user/user_model.dart';

import '../../data/models/change_password/change_password_request.dart';
import '../../data/models/change_password/change_password_response.dart';
import '../../data/models/delete_account/delete_account_response.dart';
import '../../data/models/update_profile/update_profile_request.dart';
import '../../data/models/update_profile/update_profile_response.dart';

abstract class UserRepository {
  Future<List<UserModel>> getAllUsers({required int page, int limit = 10});

  Future<List<UserModel>> getUsersWithoutAdminOnly({
    required int page,
    int limit = 10,
  });

  @override
  Future<List<UserModel>> getUsers({
    required int page,
    int limit = 10,
    String? query,
    String? role,
    String? track,
    double? minPrice,
    double? maxPrice,
    double? minRate,
    String? sort,
  }) {
    if (query != null && query.isNotEmpty) {
      return searchUsers(query: query, page: page, limit: limit);
    }

    if (role != null ||
        track != null ||
        minPrice != null ||
        maxPrice != null ||
        minRate != null) {
      return filterUsers(
        role: role,
        track: track,
        minPrice: minPrice?.toInt(),
        maxPrice: maxPrice?.toInt(),
        minRating: minRate?.toInt(),
        page: page,
        limit: limit,
      );
    }

    if (sort != null) {
      return sortUsers(query: sort, page: page, limit: limit);
    }

    return getAllUsers(page: page, limit: limit);
  }

  Future<MyProfile> getMyProfile();

  Future<List<UserModel>> searchUsers(
      {String? query, required int page, int limit = 10});

  Future<List<UserModel>> sortUsers(
      {String? query, required int page, int limit = 10});

  Future<List<UserModel>> filterUsers(
      {String? role,
      String? track,
      int? minRating,
      int? minPrice,
      int? maxPrice,
      required int page,
      int limit = 10});

  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);

  Future<UpdateProfileResponse> updateProfileImage(String imagePath);

  Future<DeleteAccountResponse> deleteAccount();

  Future<String> requestMentor(num hourlyPrice);

  Future<void> setActiveTheme(String? themeId);
}
