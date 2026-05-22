import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../application/blocs/baby/baby_cubit.dart';
import '../application/blocs/ingredients/ingredients_cubit.dart';
import '../application/blocs/meals/meals_cubit.dart';
import '../core/di/injection.dart';
import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BabyCubit>()),
        BlocProvider(create: (_) => getIt<IngredientsCubit>()),
        BlocProvider(create: (_) => getIt<MealsCubit>()),
      ],
      child: MaterialApp(
        title: 'Mi Primera Comida',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
