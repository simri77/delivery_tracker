  import 'package:flutter/material.dart';
  import '../services/api_service.dart';
  import '../services/shared_prefs_helper.dart';
  import '../services/secure_storage_helper.dart';
  import '../main.dart';
  import 'register_screen.dart';

  class LoginScreen extends StatefulWidget {
    const LoginScreen({Key? key}) : super(key: key);

    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController(text: 'alex.rivera@deliverymail.com');
    final _passwordController = TextEditingController(text: 'password123');
    
    bool _isLoading = false;
    String? _errorMessage;

    Future<void> _login() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Cleanly call ApiService.login
        final data = await ApiService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (data['token'] != null) {
    // Save JWT token securely using encrypted storage
    await SecureStorageHelper.saveToken(data['token']);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  } else {
          setState(() {
            _errorMessage = data['error'] ?? 'Invalid email or password';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Could not connect to backend server.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF8FF),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF131B2E))),
                    const SizedBox(height: 4),
                    const Text('Sign in to access your live delivery tracking & profile telemetry.', style: TextStyle(fontSize: 13, color: Color(0xFF6C7A71))),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFFFDAD6).withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                        child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFBA1A1A), fontSize: 12)),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email Address', filled: true, fillColor: const Color(0xFFFAF8FF), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                      validator: (val) => val!.isEmpty ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: const Color(0xFFFAF8FF), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                      validator: (val) => val!.isEmpty ? 'Please enter your password' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                        child: const Text("Don't have an account? Register", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }