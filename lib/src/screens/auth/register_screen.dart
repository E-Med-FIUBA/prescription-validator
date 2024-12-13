import 'package:emed/src/services/auth/auth.service.dart';
import 'package:emed/src/utils/scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../utils/validators.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/styled_form_field.dart';

class RegisterFormData {
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String license = '';
  int dni = 0;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': firstName,
        'lastName': lastName,
        'license': license,
        'dni': dni
      };
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.authService});

  static const routeName = '/auth/register';

  final AuthService authService;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = RegisterFormData();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await widget.authService.register(_formData);

      context.go('/');
    } catch (e) {
      showMessage('Error en el registro. $e', context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset('assets/images/logo.svg'),
              const SizedBox(height: 32),
              const Text('Crea tu cuenta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              StyledFormField(
                labelText: 'Correo Electrónico',
                validators: const [Validators.required, Validators.email],
                onSaved: (value) => _formData.email = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Contraseña',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validators: const [
                  Validators.required,
                  Validators.strongPassword
                ],
                onSaved: (value) => _formData.password = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Nombre',
                validators: const [Validators.required],
                onSaved: (value) => _formData.firstName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Apellido',
                validators: const [Validators.required],
                onSaved: (value) => _formData.lastName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Licencia',
                validators: const [Validators.required],
                onSaved: (value) => _formData.license = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'DNI',
                validators: const [Validators.required, Validators.number],
                onSaved: (value) =>
                    _formData.dni = value != null ? int.parse(value) : 0,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push('/auth/login'),
                  child: Row(
                    children: [
                      Text(
                        'Ya tienes una cuenta?',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(' '),
                      Text(
                        'Inicia Sesion',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
