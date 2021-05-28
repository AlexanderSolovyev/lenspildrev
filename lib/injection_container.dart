import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:s3/features/app/data/data_source/order_remote_data_source.dart';
import 'package:s3/features/app/data/data_source/user_remote_data_source.dart';
import 'package:s3/features/app/data/repositories/order_repository_impl.dart';
import 'package:s3/features/app/data/repositories/user_repository_impl.dart';
import 'package:s3/features/app/domain/repositories/order_repository.dart';
import 'package:s3/features/app/domain/usecases/auth_state_changes.dart';
import 'package:s3/features/app/domain/usecases/create_order.dart';
import 'package:s3/features/app/domain/usecases/get_order_by_id.dart';
import 'package:s3/features/app/domain/usecases/get_orders.dart';
import 'package:s3/features/app/domain/usecases/user_sign_in.dart';
import 'package:s3/features/app/domain/usecases/user_sign_out.dart';
import 'package:s3/main.dart';

import 'features/app/domain/repositories/user_repository.dart';
import 'features/app/domain/usecases/get_user_details.dart';
import 'features/app/domain/usecases/update_order.dart';
import 'features/app/presentation/bloc/sign_in_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => SignInBloc(
      sl(),
    ),
  );
  sl.registerFactory(
    () => MyApp(
      authStateChanges: sl(),
      getOrders: sl(),
    ),
  );

  //Use cases
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => GetOrderById(sl()));
  sl.registerLazySingleton(() => GetUserDetails(sl()));
  sl.registerLazySingleton(() => CreateOrder(sl()));
  sl.registerLazySingleton(() => UpdateOrder(sl()));
  sl.registerLazySingleton(() => UserSignIn(sl()));
  sl.registerLazySingleton(() => AuthStateChanges(sl()));
  sl.registerLazySingleton(() => UserSignOut(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
// DataSources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(sl()));

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
