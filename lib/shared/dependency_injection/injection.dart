import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/shared/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/data/web_services/skills/skills_api_services.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../bloc/activation_bloc/activation_bloc.dart';
import '../bloc/add_available_dates_bloc/add_available_dates_bloc.dart';
import '../bloc/book_session/book_session_bloc.dart';
import '../bloc/cancel_book_bloc/cancel_book_bloc.dart';
import '../bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../bloc/delete_account_bloc/delete_account_bloc.dart';
import '../bloc/delete_available_dates/delete_available_dates_bloc.dart';
import '../bloc/delete_book_bloc/delete_book_bloc.dart';
import '../bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../bloc/get_booking_details_bloc/get_booking_details_bloc.dart';
import '../bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../bloc/get_upcoming_sat_bloc/get_upcoming_sat_bloc.dart';
import '../bloc/join_session_bloc/join_session_bloc.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../bloc/pay_booking_bloc/pay_booking_bloc.dart';
import '../bloc/private_chats_bloc/private_chats_bloc.dart';
import '../bloc/public_chat/message_search_cubit.dart';
import '../bloc/public_chat/public_chat_bloc.dart';
import '../bloc/public_chat/public_chat_messages_cubit.dart';
import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/report_bloc/report_bloc.dart';
import '../bloc/reset_password_bloc/reset_password_bloc.dart';
import '../bloc/send_code_bloc/send_code_bloc.dart';
import '../bloc/set_available_dates_bloc/set_available_dates_bloc.dart';
import '../bloc/status_book_bloc/status_book_bloc.dart';
import '../bloc/store_cubit/purchase_cubit.dart';
import '../bloc/store_cubit/store_cubit.dart';
import '../bloc/submit_review_bloc/submit_review_bloc.dart';
import '../bloc/track_cubit/skills_cubit.dart';
import '../bloc/track_cubit/track_cubit.dart';
import '../bloc/tracks_bloc/tracks_bloc.dart';
import '../bloc/update_book_bloc/update_book_bloc.dart';
import '../bloc/update_profile_bloc/update_profile_bloc.dart';
import '../bloc/user_filter_bloc/user_filter_bloc.dart';
import '../bloc/verify_code_bloc/verify_code_bloc.dart';
import '../constants/strings.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/pusher_service.dart';
import '../data/models/user/user_model.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../data/repositories/report_repository_impl.dart';
import '../data/repositories/store_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/web_services/auth/auth_api.dart';
import '../data/web_services/booking/booking_api.dart';
import '../data/web_services/chat/chat_api_service.dart';
import '../data/web_services/notification/notification_api.dart';
import '../data/web_services/report/report_api.dart';
import '../data/web_services/store/store_api_service.dart';
import '../data/web_services/user/user_api.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/repositories/store_repository.dart';
import '../domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  dio.interceptors.add(AuthInterceptor(dio));

  // APIs
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()));
  sl.registerLazySingleton<BookingApi>(() => BookingApi(sl<Dio>()));
  sl.registerLazySingleton<UserApi>(() => UserApi(sl<Dio>()));
  sl.registerLazySingleton<ReportApi>(() => ReportApi(sl<Dio>()));
  sl.registerLazySingleton<SkillsApiService>(() => SkillsApiService(sl<Dio>()));

  sl.registerLazySingleton<StoreApiService>(() => StoreApiService(sl<Dio>()));

  sl.registerLazySingleton<NotificationApi>(
    () => NotificationApi(sl<Dio>()),
  );

  // Chat API & Pusher
  sl.registerLazySingleton<ChatApiService>(() => ChatApiService(sl<Dio>()));
  sl.registerLazySingleton<PusherService>(() => PusherService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(api: sl<AuthApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(api: sl<BookingApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(api: sl<UserApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<ReportRepository>(
      () => ReportRepositoryImpl(api: sl<ReportApi>(), dio: sl<Dio>()));

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl<NotificationApi>()));

  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(api: sl<ChatApiService>()));

  sl.registerLazySingleton<StoreRepository>(
      () => StoreRepositoryImpl(api: sl<StoreApiService>()));

  // Blocs
  sl.registerFactory<SkillsCubit>(() => SkillsCubit(sl<SkillsApiService>()));

  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl<AuthRepository>()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthRepository>()));
  sl.registerFactory<SendCodeBloc>(() => SendCodeBloc(sl<AuthRepository>()));
  sl.registerFactory<VerifyCodeBloc>(
      () => VerifyCodeBloc(sl<AuthRepository>()));
  sl.registerFactory<ResetPasswordBloc>(
      () => ResetPasswordBloc(sl<AuthRepository>()));
  sl.registerFactory<ActiveBookingBloc>(
      () => ActiveBookingBloc(sl<BookingRepository>()));
  sl.registerFactory<StatusBookBloc>(
      () => StatusBookBloc(sl<BookingRepository>()));
  sl.registerFactory<CancelBookBloc>(
      () => CancelBookBloc(sl<BookingRepository>()));
  sl.registerFactory<SubmitReviewBloc>(
      () => SubmitReviewBloc(sl<BookingRepository>()));
  sl.registerFactory<UpdateBookBloc>(
      () => UpdateBookBloc(sl<BookingRepository>()));
  sl.registerFactory<DeleteBookBloc>(
      () => DeleteBookBloc(sl<BookingRepository>()));
  sl.registerFactory<GetBookingDetailsBloc>(
      () => GetBookingDetailsBloc(sl<BookingRepository>()));

  sl.registerFactory<GetBookingsCubit>(
      () => GetBookingsCubit(sl<BookingRepository>()));
  sl.registerFactory<PublicChatBloc>(
      () => PublicChatBloc(sl<ChatRepository>(), sl<PusherService>()));
  sl.registerFactory<UsersCubit>(() => UsersCubit(sl<UserRepository>()));

  sl.registerFactory<ChangePasswordBloc>(
      () => ChangePasswordBloc(sl<UserRepository>()));
  sl.registerFactory<UpdateProfileBloc>(
      () => UpdateProfileBloc(sl<UserRepository>()));
  sl.registerFactory<ReportBloc>(() => ReportBloc(sl<ReportRepository>()));
  sl.registerLazySingleton<MyProfileCubit>(
    () => MyProfileCubit(sl<UserRepository>()),
  );
  sl.registerFactory<LogoutBloc>(() => LogoutBloc(sl<AuthRepository>()));
  sl.registerFactory<DeleteAccountBloc>(
      () => DeleteAccountBloc(sl<UserRepository>()));
  sl.registerFactory<ActivationBloc>(
      () => ActivationBloc(sl<AuthRepository>()));

  sl.registerFactory<CompleteProfileBloc>(
      () => CompleteProfileBloc(sl<AuthRepository>()));

  sl.registerFactory<TracksCubit>(() => TracksCubit(sl<AuthRepository>()));
  sl.registerFactory<PayBookingBloc>(
      () => PayBookingBloc(sl<BookingRepository>()));
  sl.registerFactory<GetUpcomingSatBloc>(
      () => GetUpcomingSatBloc(sl<BookingRepository>()));
  sl.registerFactory<AddAvailableDatesBloc>(
      () => AddAvailableDatesBloc(sl<BookingRepository>()));
  sl.registerFactory<SetAvailableDatesBloc>(
      () => SetAvailableDatesBloc(sl<BookingRepository>()));
  sl.registerFactory<DeleteAvailableDatesBloc>(
      () => DeleteAvailableDatesBloc(sl<BookingRepository>()));
  sl.registerFactory<GetAvailableDatesBloc>(
      () => GetAvailableDatesBloc(sl<BookingRepository>()));

  sl.registerFactory<JoinSessionBloc>(
      () => JoinSessionBloc(sl<BookingRepository>()));

  sl.registerFactory<AcceptedBookingsCubit>(
      () => AcceptedBookingsCubit(sl<BookingRepository>()));

  sl.registerFactory<TracksBloc>(
    () => TracksBloc(sl<ChatRepository>()),
  );

  sl.registerFactory<StoreCubit>(
    () => StoreCubit(sl<StoreRepository>()),
  );

  sl.registerFactory<PurchaseCubit>(
    () => PurchaseCubit(sl<StoreRepository>()),
  );

  // Chat Cubits
  sl.registerFactory<PrivateChatsBloc>(() => PrivateChatsBloc(
        sl<ChatRepository>(),
        sl<PusherService>(),
      ));

  sl.registerFactory<PublicChatMessagesCubit>(() => PublicChatMessagesCubit(
      chatRepository: sl<ChatRepository>(),
      // notificationRepository: sl<NotificationRepository>(),
      pusherService: sl<PusherService>(),
      privateChatsBloc: sl<PrivateChatsBloc>()));

  sl.registerFactory<MessageSearchCubit>(
      () => MessageSearchCubit(chatRepository: sl<ChatRepository>()));

  // Load users safely
  List<UserModel> users = [];
  try {
    users = await sl<UserRepository>().getAllUsers(page: 1, limit: 10);
  } catch (e) {
    print("Failed to fetch users, using empty list: $e");
  }

  sl.registerFactory<UserFilterBloc>(() => UserFilterBloc(
      userRepository: sl<UserRepository>(),
      allUsers: users,
      limit: 10,
      initialPage: 1));
}
