import 'package:emed/src/screens/empty_screen.dart';
import 'package:emed/src/utils/scaffold_messenger.dart';
import 'package:flutter/material.dart';

import '../services/api/api.dart';
import '../utils/navigation.dart';
import '../utils/validators.dart';
import '../widgets/primary_button.dart';
import '../widgets/styled_form_field.dart';

class FormData {
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
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = FormData();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final response =
          await ApiService.post('auth/register/pharmacist', _formData.toJson());

      if (response.statusCode == 201) {
        showMessage('Registrado correctamente', context);
        navigate(const EmptyScreen(), context);
      } else {
        showMessage('Error en el registro. ${response.body}', context);
      }
    } catch (e) {
      showMessage('Error en el registro.', context);
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
              const Text('Crea tu cuenta',
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
                validators: const [
                  Validators.required,
                  Validators.strongPassword
                ],
                onSaved: (value) => _formData.password = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'First Name',
                validators: const [Validators.required],
                onSaved: (value) => _formData.firstName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Last Name',
                validators: const [Validators.required],
                onSaved: (value) => _formData.lastName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'License',
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
