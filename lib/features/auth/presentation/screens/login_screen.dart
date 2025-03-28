import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The login screen of the application
class LoginScreen extends HookConsumerWidget {
  /// Creates a new [LoginScreen] widget
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final formField = ref.watch(loginFormProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
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

    // Handle focus changes based on form field state
    useEffect(
      () {
        switch (formField) {
          case LoginFormField.email:
            emailFocusNode.requestFocus();
          case LoginFormField.password:
            passwordFocusNode.requestFocus();
          case LoginFormField.none:
            // No focus needed when form is submitted
            break;
        }
        return null;
      },
      [formField],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).loginTitle),
        actions: const [
          LanguageSelectorWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(
          context,
          loginState,
          ref,
          emailController,
          passwordController,
          emailFocusNode,
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
    FocusNode emailFocusNode,
    FocusNode passwordFocusNode,
    GlobalKey<FormState> formKey,
  ) {
    // Show loading indicator when in loading state
    if (state is LoginLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // For all other states, show the login form
    // Pass error message only if in error state
    final errorMessage = state is LoginError ? state.message : null;

    return _buildLoginForm(
      context,
      ref,
      emailController,
      passwordController,
      emailFocusNode,
      passwordFocusNode,
      formKey,
      errorMessage: errorMessage,
    );
  }

  /// Attempts to sign in with the provided credentials
  void _submitForm(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      // Set form field to none to indicate submission
      ref.read(loginFormProvider.notifier).submitForm();

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
    FocusNode emailFocusNode,
    FocusNode passwordFocusNode,
    GlobalKey<FormState> formKey, {
    String? errorMessage,
  }) {
    final emailValidator = useEmailValidator(
      requiredFieldMessage: AppLocalization.of(context).emptyEmail,
      invalidEmailMessage: AppLocalization.of(context).invalidEmail,
    );

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
          if (errorMessage != null)
            ErrorDisplayWidget(
              errorMessage: errorMessage,
            )
          else
            const Spacer(flex: 4),
          TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).email,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              // Move focus to password field when Enter is pressed
              passwordFocusNode.requestFocus();
            },
            validator: emailValidator,
          ),
          const Spacer(),
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).password,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
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
                return AppLocalization.of(context).passwordTooShort;
              }
              if (value.length < 6) {
                return AppLocalization.of(context).passwordTooShort;
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
            child: Text(AppLocalization.of(context).loginButton),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.pushRoute(AppRoute.register);
            },
            child: Text(AppLocalization.of(context).dontHaveAccount),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
