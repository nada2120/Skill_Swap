import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:skill_swap/shared/data/models/change_password/change_password_request.dart';
import 'package:skill_swap/shared/data/models/change_password/change_password_response.dart';
import 'package:skill_swap/shared/data/models/my_profile/my_profile.dart';

import '../../domain/repositories/user_repository.dart';
import '../../helper/local_storage.dart';
import '../models/change_password/change_password_error_response.dart';
import '../models/delete_account/delete_account_response.dart';
import '../models/update_profile/update_profile_request.dart';
import '../models/update_profile/update_profile_response.dart';
import '../models/user/user_model.dart';
import '../web_services/user/user_api.dart';

class UserRepositoryImpl extends UserRepository {
  final Dio dio;
  final UserApi api;

  UserRepositoryImpl({required this.dio, required this.api});

  Future<List<UserModel>> _excludeMyAccountAndAdmin(
      List<UserModel> users) async {
    String? myId = await LocalStorage.getUserId();

    return users.where((user) {
      final isMe = user.id.toString().trim() == myId.toString().trim();

      final isAdmin = user.role.toString().trim() == "Admin";

      return !isMe && !isAdmin;
    }).toList();
  }

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

  @override
  Future<List<UserModel>> getAllUsers(
      {required int page, int limit = 10}) async {
    final response = await api.getAllUsers(page, limit);
    return _excludeMyAccountAndAdmin(response.data.users);
  }

  Future<List<UserModel>> getUsersWithoutAdminOnly({
    required int page,
    int limit = 10,
  }) async {
    final response = await api.getAllUsers(page, limit);

    final users = response.data.users;

    return users.where((user) {
      return user.role?.toLowerCase() != "admin";
    }).toList();
  }

  @override
  Future<MyProfile> getMyProfile() async {
    final response = await api.getMyProfile();

    // if (response.message.toLowerCase().contains('blocked')) {
    //   throw Exception(response.message);
    // }
    //
    // if (response.user == null) {
    //   throw Exception("Invalid profile response");
    // }

    return response.user!;
  }

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<List<UserModel>> searchUsers(
      {String? query, required int page, int limit = 10}) async {
    List<UserModel> users;
    if (query == null || query.isEmpty) {
      users = await api.getAllUsers(page, limit).then((res) => res.data.users);
    } else {
      users = await api
          .searchUsers(query: query, page: page, limit: limit)
          .then((res) => res.data.users);
    }
    return _excludeMyAccountAndAdmin(users);
  }

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest request) async {
    try {
      final response = await api.changePassword(request);
      if (response.message == 'Password changed successfully') {
        return ChangePasswordSuccess(response);
      }
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: response.message),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = ChangePasswordErrorResponse.fromJson(e.response!.data);
        return ChangePasswordFailure(error);
      }
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return ChangePasswordFailure(
        ChangePasswordErrorResponse(message: e.toString()),
      );
    }
  }

  @override
  Future<UpdateProfileResponse> updateProfile(
      UpdateProfileRequest request) async {
    try {
      final response = await api.updateProfile(request.toJson());
      return UpdateProfileData.fromJson(response);
    } on DioException catch (e) {
      String serverMessage = "Network Error";
      if (e.response?.data != null) {
        try {
          final data = e.response!.data;
          if (data is Map && data['message'] != null) {
            serverMessage = data['message'].toString();
          } else if (data is String) {
            serverMessage = data;
          }
        } catch (_) {}
      }
      return UpdateProfileFailure(error: serverMessage);
    } catch (e) {
      return UpdateProfileFailure(error: e.toString());
    }
  }

  @override
  Future<DeleteAccountResponse> deleteAccount() async {
    try {
      await api.deleteAccount();
      await LocalStorage.clearAllTokens();
      return DeleteAccountSuccess();
    } on DioException catch (e) {
      return DeleteAccountFailure(_getServerErrorMessage(e));
    } catch (e) {
      return DeleteAccountFailure(e.toString());
    }
  }

  @override
  Future<List<UserModel>> filterUsers(
      {String? role,
      String? track,
      int? minRating,
      int? minPrice,
      int? maxPrice,
      required page,
      int limit = 10}) async {
    final response = await api.filterUsers(
        role: role,
        track: track,
        minRating: minRating,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: page,
        limit: limit);
    return _excludeMyAccountAndAdmin(response.data.users);
  }

  @override
  Future<List<UserModel>> sortUsers(
      {String? query, required int page, int limit = 10}) async {
    List<UserModel> users;
    if (query == null || query.isEmpty) {
      users = await api.getAllUsers(page, limit).then((res) => res.data.users);
    } else {
      users = await api
          .sortUsers(query: query, page: page, limit: limit)
          .then((res) => res.data.users);
    }
    return _excludeMyAccountAndAdmin(users);
  }

  @override
  Future<UpdateProfileResponse> updateProfileImage(String imagePath) async {
    try {
      final file = await MultipartFile.fromFile(
        imagePath,
        filename: p.basename(imagePath),
      );

      final response = await api.updateProfileImage(file);
      return UpdateProfileData.fromJson(response);
    } on DioException catch (e) {
      String serverMessage = _getServerErrorMessage(e);
      return UpdateProfileFailure(error: serverMessage);
    } catch (e) {
      return UpdateProfileFailure(error: e.toString());
    }
  }

  @override
  Future<String> requestMentor(num hourlyPrice) async {
    try {
      final response = await api.requestMentor({
        "hourlyPrice": hourlyPrice,
      });
      return response['message'];
    } on DioException catch (e) {
      return _getServerErrorMessage(e);
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> setActiveTheme(String? themeId) async {
    await api.setActiveTheme({"themeId": themeId});
  }
}
