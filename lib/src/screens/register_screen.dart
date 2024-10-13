import 'dart:convert';

import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import '../widgets/styled_form_field.dart';
import 'package:http/http.dart' as http;

class FormData {
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String license = '';
  String dni = '';
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('https://your-backend-url.com/submit'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({
            'email': _formData.email,
            'password': _formData.password,
            'firstName': _formData.firstName,
            'lastName': _formData.lastName,
            'license': _formData.license,
            'dni': _formData.dni,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
          // Handle successful submission
        } else {
          throw Exception('Submission failed');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submission failed. Please try again.')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email format validation if needed
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add password strength validation if needed
                  return null;
                },
                onSaved: (value) => _formData.password = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) => _formData.firstName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) => _formData.lastName = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'License',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your license';
                  }
                  return null;
                },
                onSaved: (value) => _formData.license = value ?? '',
              ),
              const SizedBox(height: 16),
              StyledFormField(
                labelText: 'DNI',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your DNI';
                  }
                  return null;
                },
                onSaved: (value) => _formData.dni = value ?? '',
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
