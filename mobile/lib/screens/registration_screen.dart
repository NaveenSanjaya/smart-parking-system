import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/add-vehicle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Logo section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color.fromARGB(255, 112, 112, 112),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register to get started',
                  style: TextStyle(color: Color.fromARGB(255, 112, 112, 112)),
                ),

                const SizedBox(height: 24),

                // Full Name
                _buildLabel('Full Name'),
                _buildTextField(
                  hint: 'Enter full name',
                  icon: Icons.person,
                  controller: _nameController,
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Name is required'
                              : null,
                ),

                const SizedBox(height: 17),

                // Email
                _buildLabel('Email'),
                _buildTextField(
                  hint: 'Enter email address',
                  icon: Icons.email,
                  controller: _emailController,
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Email is required'
                              : null,
                ),

                const SizedBox(height: 17),

                // Phone Number
                _buildLabel('Phone Number'),
                _buildTextField(
                  hint: '+94 77 123 4567',
                  icon: Icons.phone,
                  controller: _phoneController,
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Phone number is required'
                              : null,
                ),

                const SizedBox(height: 17),

                // Password
                _buildLabel('Password'),
                _buildTextField(
                  hint: 'Password',
                  icon: Icons.lock,
                  obscure: true,
                  controller: _passwordController,
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Password is required'
                              : null,
                ),

                const SizedBox(height: 24),

                // Register button
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('OR')),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.network(
                    'https://developers.google.com/identity/images/g-logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 112, 112, 112),
                    ),
                    foregroundColor: AppColors.primaryColor,
                  ),
                ),

                const SizedBox(height: 20),

                // Already have account
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/signIn'),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Label widget
  static Widget _buildLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 9),
      ],
    );
  }

  // TextField widget
  static Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBackground,
        prefixIcon: Icon(icon, color: const Color(0xFF6E6D74)),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6E6D74)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }
}
