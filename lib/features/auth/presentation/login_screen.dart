import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/routing.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/login_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The login screen of the application
class LoginScreen extends HookConsumerWidget {
  /// Creates a new [LoginScreen] widget
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // Handle navigation when state changes to LoginSuccess
    useEffect(
      () {
        if (loginState is LoginSuccess) {
          // Navigate to home screen on successful login
          Future<void>.microtask(() {
            if (!context.mounted) return;
            context.goRoute(AppRoute.home);
          });
        }
        return null;
      },
      [loginState],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(
          context,
          loginState,
          ref,
          emailController,
          passwordController,
          passwordFocusNode,
          formKey,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    LoginState state,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    FocusNode passwordFocusNode,
    GlobalKey<FormState> formKey,
  ) {
    if (state is LoginLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is LoginError) {
      return _buildLoginForm(
        context,
        ref,
        emailController,
        passwordController,
        passwordFocusNode,
        formKey,
        errorMessage: state.message,
      );
    } else {
      // Initial state or Success state (before navigation completes)
      return _buildLoginForm(
        context,
        ref,
        emailController,
        passwordController,
        passwordFocusNode,
        formKey,
      );
    }
  }

  /// Attempts to sign in with the provided credentials
  void _submitForm(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      ref.read(loginProvider.notifier).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
    }
  }

  Widget _buildLoginForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    FocusNode passwordFocusNode,
    GlobalKey<FormState> formKey, {
    String? errorMessage,
  }) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 4),
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Spacer(flex: 4),
          if (errorMessage != null) ...[
            Text(
              errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              // Move focus to password field when Enter is pressed
              passwordFocusNode.requestFocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const Spacer(),
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              // Submit form when Enter is pressed in password field
              _submitForm(
                ref,
                formKey,
                emailController.text,
                passwordController.text,
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              _submitForm(
                ref,
                formKey,
                emailController.text,
                passwordController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Login'),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.pushRoute(AppRoute.register);
            },
            child: const Text("Don't have an account? Register"),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
