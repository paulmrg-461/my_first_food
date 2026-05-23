import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../application/blocs/auth/auth_cubit.dart';
import '../application/blocs/auth/auth_state.dart';
import '../application/blocs/baby/baby_cubit.dart';
import '../application/blocs/chat/chat_cubit.dart';
import '../application/blocs/ingredients/ingredients_cubit.dart';
import '../application/blocs/meals/meals_cubit.dart';
import '../application/blocs/theme/theme_cubit.dart';
import '../core/di/injection.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<BabyCubit>()),
        BlocProvider(create: (_) => getIt<IngredientsCubit>()),
        BlocProvider(create: (_) => getIt<MealsCubit>()),
        BlocProvider(create: (_) => getIt<ChatCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp(
          title: 'Mi Primera Comida',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is AuthAuthenticated) return const HomeScreen();
              if (authState is AuthInitial || authState is AuthUnauthenticated) {
                return const LoginScreen();
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
