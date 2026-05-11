import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../helper/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  static bool _logoutInProgress = false;

  AuthInterceptor(this.dio);

  // ───────────────────── REQUEST ─────────────────────
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'skill-swap $token';
    }

    handler.next(options);
  }

  // ───────────────────── RESPONSE ─────────────────────
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final message = _extractMessage(response.data);
    final statusCode = response.statusCode ?? 0;

    await _handleAllCases(
      statusCode: statusCode,
      message: message,
      isError: false,
    );

    handler.next(response);
  }

  // ───────────────────── ERROR ─────────────────────
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final message = _extractMessage(err.response?.data);
    final statusCode = err.response?.statusCode ?? 0;

    print('❌ STATUS: $statusCode');
    print('❌ MESSAGE: $message');
    print('❌ TYPE: ${err.type}');

    await _handleAllCases(
      statusCode: statusCode,
      message: message,
      isError: true,
      dioErrorType: err.type,
    );

    handler.next(err);
  }

  // ───────────────────── MAIN HANDLER ─────────────────────
  Future<void> _handleAllCases({
    required int statusCode,
    required String message,
    required bool isError,
    DioExceptionType? dioErrorType,
  }) async {
    // =========================
    // FORCE LOGOUT CASES (SECURITY)
    // =========================

    if (_isTokenExpired(message)) {
      await _logout(
        title: 'Session Expired',
        message: 'Please login again.',
      );
      return;
    }

    if (_isAnotherLogin(message)) {
      await _logout(
        title: 'Logged Out',
        message: 'Your account was used on another device.',
      );
      return;
    }

    if (_isBlocked(message)) {
      await _logout(
        title: 'Account Blocked',
        message: message,
      );
      return;
    }

    // =========================
    // INTERNET / NETWORK ISSUES
    // =========================

    if (dioErrorType != null) {
      if (dioErrorType == DioExceptionType.connectionError) {
        await _logout(
          title: 'Connection Lost',
          message: 'No internet connection. Please login again.',
        );
        return;
      }
    }

    // // =========================
    // // SERVER ERROR
    // // =========================
    //
    // if (statusCode >= 500) {
    //   await _logout(
    //     title: 'Server Error',
    //     message: 'Server is down. Please try again later.',
    //   );
    //   return;
    // }
  }

  // ───────────────────── HELPERS ─────────────────────

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? '';
    }
    return data?.toString() ?? '';
  }

  bool _isTokenExpired(String msg) {
    return msg.contains('jwt expired') || msg.contains('TokenExpiredError');
  }

  bool _isAnotherLogin(String msg) {
    return msg.contains('Another login detected') ||
        msg.contains('Session expired');
  }

  bool _isBlocked(String msg) {
    return msg.contains('blocked');
  }

  // ───────────────────── LOGOUT ─────────────────────

  Future<void> _logout({
    required String title,
    required String message,
  }) async {
    await LocalStorage.clearAllTokens();
    await LocalStorage.clearUserId();

    if (_logoutInProgress) return;
    _logoutInProgress = true;

    _showLogoutDialogWhenReady(title: title, message: message);
  }

  void _showLogoutDialogWhenReady({
    required String title,
    required String message,
    int attempt = 0,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasNavigator = Get.key.currentState != null;
      final hasContext = Get.context != null;

      if (!hasNavigator || !hasContext) {
        if (attempt < 10) {
          Timer(const Duration(milliseconds: 200), () {
            _showLogoutDialogWhenReady(
              title: title,
              message: message,
              attempt: attempt + 1,
            );
          });
          return;
        }

        _goToSignInWhenReady();
        return;
      }

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.dialog(
        AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _goToSignInWhenReady();
              },
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (Get.isDialogOpen ?? false) {
          _goToSignInWhenReady();
        }
      });
    });
  }

  void _goToSignInWhenReady({int attempt = 0}) {
    final hasNavigator = Get.key.currentState != null;

    if (!hasNavigator) {
      if (attempt < 10) {
        Timer(const Duration(milliseconds: 200), () {
          _goToSignInWhenReady(attempt: attempt + 1);
        });
      }
      return;
    }

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    Get.offAll(() => const SignInScreen());
    _logoutInProgress = false;
  }
}
