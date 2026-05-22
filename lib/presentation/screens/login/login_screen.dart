import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/auth/auth_cubit.dart';
import '../../../application/blocs/auth/auth_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: _onStateChanged,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 80),
                      const SizedBox(height: AppSpacing.md),
                      _welcomeText(context),
                      const SizedBox(height: AppSpacing.xl),
                      _emailField(state),
                      const SizedBox(height: AppSpacing.md),
                      _passwordField(state),
                      const SizedBox(height: AppSpacing.sm),
                      _errorMessage(state),
                      const SizedBox(height: AppSpacing.lg),
                      _loginButton(state),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _welcomeText(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Mi Primera Comida',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Inicia sesión para continuar',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _emailField(AuthState state) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      enabled: state is! AuthLoading,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
        if (!v.contains('@')) return 'Correo no válido';
        return null;
      },
    );
  }

  Widget _passwordField(AuthState state) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      enabled: state is! AuthLoading,
      onFieldSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
        return null;
      },
    );
  }

  Widget _errorMessage(AuthState state) {
    if (state is! AuthError) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        state.message,
        style: const TextStyle(color: AppColors.error, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _loginButton(AuthState state) {
    final loading = state is AuthLoading;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : _submit,
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text('Iniciar Sesión'),
      ),
    );
  }
}
