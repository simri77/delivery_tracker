Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Cleanly call your centralized ApiService method
      final data = await ApiService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _phoneController.text.trim(),
      );

      // Check if user ID was successfully returned by the backend
      if (data['userId'] != null) {
        setState(() {
          _successMessage = 'Registration successful! Redirecting to login...';
        });

        // Wait 1.5 seconds then push back to LoginScreen
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        setState(() {
          _errorMessage = data['error'] ?? 'Registration failed. Email might already exist.';
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