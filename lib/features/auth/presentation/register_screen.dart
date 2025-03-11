import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/auth.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/providers/register_form_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The register screen of the application
class RegisterScreen extends HookConsumerWidget {
  /// Creates a new [RegisterScreen] widget
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);
    final formField = ref.watch(registerFormProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final emailFocusNode = useFocusNode();
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

    // Handle focus changes based on form field state
    useEffect(
      () {
        switch (formField) {
          case RegisterFormField.email:
            emailFocusNode.requestFocus();
            break;
          case RegisterFormField.password:
            passwordFocusNode.requestFocus();
            break;
          case RegisterFormField.confirmPassword:
            confirmPasswordFocusNode.requestFocus();
            break;
          case RegisterFormField.none:
            // Don't do anything here - form submission is handled by the submit button
            break;
        }
        return null;
      },
      [formField],
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
          emailFocusNode,
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
    FocusNode emailFocusNode,
    FocusNode passwordFocusNode,
    FocusNode confirmPasswordFocusNode,
    GlobalKey<FormState> formKey,
  ) {
    // Show loading indicator when in loading state
    if (state is RegisterLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // For all other states, show the register form
    // Pass error message only if in error state
    final errorMessage = state is RegisterError ? state.message : null;

    return _buildRegisterForm(
      context,
      ref,
      emailController,
      passwordController,
      confirmPasswordController,
      emailFocusNode,
      passwordFocusNode,
      confirmPasswordFocusNode,
      formKey,
      errorMessage: errorMessage,
    );
  }

  /// Attempts to register with the provided credentials
  void _submitForm(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      // Use a microtask to avoid modifying providers during build
      Future<void>.microtask(() {
        ref.read(registerProvider.notifier).createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
      });
    }
  }

  Widget _buildRegisterForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    FocusNode emailFocusNode,
    FocusNode passwordFocusNode,
    FocusNode confirmPasswordFocusNode,
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
            Icons.person_add_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          if (errorMessage != null)
            Flexible(
              flex: 4,
              child: ErrorDisplayWidget(
                errorMessage: errorMessage,
              ),
            )
          else
            const Spacer(flex: 4),
          TextFormField(
            key: const Key('register_email_field'),
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
              ref.read(registerFormProvider.notifier).focusPassword();
            },
            validator: emailValidator,
          ),
          const Spacer(),
          TextFormField(
            key: const Key('register_password_field'),
            controller: passwordController,
            focusNode: passwordFocusNode,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).password,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              // Move focus to confirm password field when Enter is pressed
              ref.read(registerFormProvider.notifier).focusConfirmPassword();
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
          TextFormField(
            key: const Key('register_confirm_password_field'),
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            decoration: InputDecoration(
              labelText: AppLocalization.of(context).confirmPassword,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
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
                return AppLocalization.of(context).passwordTooShort;
              }
              if (value != passwordController.text) {
                return AppLocalization.of(context).passwordsDontMatch;
              }
              return null;
            },
          ),
          const Spacer(),
          ElevatedButton(
            key: const Key('register_submit_button'),
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
            child: Text(AppLocalization.of(context).registerButton),
          ),
          const Spacer(),
          TextButton(
            key: const Key('register_login_button'),
            onPressed: () {
              context.goRoute(AppRoute.login);
            },
            child: Text(AppLocalization.of(context).alreadyHaveAccount),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
