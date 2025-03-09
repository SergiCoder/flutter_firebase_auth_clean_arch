import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/routing.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The register screen of the application
class RegisterScreen extends HookConsumerWidget {
  /// Creates a new [RegisterScreen] widget
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // Handle navigation when state changes to RegisterSuccess
    useEffect(
      () {
        if (registerState is RegisterSuccess) {
          // Navigate to home screen on successful registration
          Future<void>.microtask(() {
            if (!context.mounted) return;
            context.goRoute(AppRoute.home);
          });
        }
        return null;
      },
      [registerState],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).registerTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(
          context,
          registerState,
          ref,
          emailController,
          passwordController,
          confirmPasswordController,
          passwordFocusNode,
          confirmPasswordFocusNode,
          formKey,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    RegisterState state,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    FocusNode passwordFocusNode,
    FocusNode confirmPasswordFocusNode,
    GlobalKey<FormState> formKey,
  ) {
    if (state is RegisterLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is RegisterError) {
      return _buildRegisterForm(
        context,
        ref,
        emailController,
        passwordController,
        confirmPasswordController,
        passwordFocusNode,
        confirmPasswordFocusNode,
        formKey,
        errorMessage: state.message,
      );
    } else {
      // Initial state or Success state (before navigation completes)
      return _buildRegisterForm(
        context,
        ref,
        emailController,
        passwordController,
        confirmPasswordController,
        passwordFocusNode,
        confirmPasswordFocusNode,
        formKey,
      );
    }
  }

  /// Attempts to register with the provided credentials
  void _submitForm(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      ref.read(registerProvider.notifier).createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
    }
  }

  Widget _buildRegisterForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    FocusNode passwordFocusNode,
    FocusNode confirmPasswordFocusNode,
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
            Icons.person_add_outlined,
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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              // Move focus to confirm password field when Enter is pressed
              confirmPasswordFocusNode.requestFocus();
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
          TextFormField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              // Submit form when Enter is pressed in confirm password field
              _submitForm(
                ref,
                formKey,
                emailController.text,
                passwordController.text,
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
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
            child: const Text('Register'),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.goRoute(AppRoute.login);
            },
            child: const Text('Already have an account? Login'),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
