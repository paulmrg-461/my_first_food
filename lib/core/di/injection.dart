import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../application/blocs/auth/auth_cubit.dart';
import '../../application/blocs/baby/baby_cubit.dart';
import '../../application/blocs/chat/chat_cubit.dart';
import '../../application/blocs/ingredients/ingredients_cubit.dart';
import '../../application/blocs/meals/meals_cubit.dart';
import '../../domain/repositories/i_ai_repository.dart';
import '../../domain/repositories/i_local_repository.dart';
import '../../domain/usecases/get_health_insight_usecase.dart';
import '../../domain/usecases/get_shopping_list_usecase.dart';
import '../../domain/usecases/suggest_meals_usecase.dart';
import '../../infrastructure/datasources/local/hive_local_datasource.dart';
import '../../infrastructure/datasources/remote/firestore_sync_datasource.dart';
import '../../infrastructure/datasources/remote/gemini_service.dart';
import '../../infrastructure/repositories/gemini_repository.dart';
import '../../infrastructure/repositories/local_repository.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Datasources
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
  getIt.registerLazySingleton<GeminiService>(GeminiService.new);
  getIt.registerLazySingleton<HiveLocalDatasource>(HiveLocalDatasource.new);
  getIt.registerLazySingleton<FirestoreSyncDatasource>(
    () => FirestoreSyncDatasource(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ILocalRepository>(
    () => LocalRepository(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton<IAiRepository>(
    () => GeminiRepository(getIt(), getIt()),
  );

  // Use cases
  getIt.registerFactory(() => SuggestMealsUseCase(getIt()));
  getIt.registerFactory(() => GetShoppingListUseCase(getIt()));
  getIt.registerFactory(() => GetHealthInsightUseCase(getIt()));

  // Cubits (factory = new instance per creation)
  getIt.registerFactory(() => AuthCubit(firebaseAuth: getIt(), secureStorage: getIt()));
  getIt.registerFactory(() => BabyCubit(getIt()));
  getIt.registerFactory(() => IngredientsCubit(getIt()));
  getIt.registerFactory(() => MealsCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ChatCubit(getIt(), getIt()));
}
