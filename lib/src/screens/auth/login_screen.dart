import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth/auth.service.dart';
import '../../utils/scaffold_messenger.dart';
import '../../utils/validators.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/styled_form_field.dart';

class LoginFormData {
  String email = '';
  String password = '';

  Map<String, String> toJson() => {'email': email, 'password': password};
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService});

  static const routeName = '/auth/login';
  final AuthService authService;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = LoginFormData();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await widget.authService.login(_formData);

      context.go('/');
    } catch (e) {
      showMessage('Error en el inicio de sesion. $e', context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Inicia Sesion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              StyledFormField(
                labelText: 'Email',
                validators: const [Validators.required, Validators.email],
                onSaved: (value) => _formData.email = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Password',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validators: const [Validators.required],
                onSaved: (value) => _formData.password = value ?? '',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Olvidaste tu contraseña?',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/auth/register'),
                  child: Text(
                    'Todavia no tenes cuenta?',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Inicia Sesion'),
              ),
              const SizedBox(height: 16),
              // const Text('O', textAlign: TextAlign.center),
              // const SizedBox(height: 16),
              // OutlinedButton.icon(
              //   onPressed: () {},
              //   icon: const Icon(Icons.apple),
              //   label: const Text('Continue with Apple'),
              //   style: OutlinedButton.styleFrom(
              //     side: const BorderSide(color: Colors.white),
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // OutlinedButton.icon(
              //   onPressed: () {},
              //   icon: const Icon(Icons.abc),
              //   label: const Text('Continue with Google'),
              //   style: OutlinedButton.styleFrom(
              //     side: const BorderSide(color: Colors.white),
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
