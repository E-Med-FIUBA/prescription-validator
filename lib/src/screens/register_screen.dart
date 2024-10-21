import 'dart:convert';

import 'package:emed/src/utils/scaffold_messenger.dart';
import 'package:flutter/material.dart';

import '../services/api/api.dart';
import '../services/signature/key_repository.dart';
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

  Map<String, String> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'license': license,
        'dni': dni.toString()
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
          await ApiService.post('auth/register', _formData.toJson());

      if (response.statusCode == 200) {
        showMessage('Registrado correctamente', context);

        // Handle successful submission
      } else {
        throw Exception('Submission failed');
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
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
