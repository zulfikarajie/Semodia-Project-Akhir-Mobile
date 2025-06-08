import 'package:flutter/material.dart';
import '../db/hive_db.dart';
import '../models/user_model.dart';
import '../utils/bcrypt_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _register() async {
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Semua field wajib diisi.");
      setState(() => _isLoading = false);
      return;
    }

    if (password != confirmPassword) {
      _showError("Password dan konfirmasi password tidak cocok.");
      setState(() => _isLoading = false);
      return;
    }

    if (password.length < 6) {
      _showError("Password minimal 6 karakter.");
      setState(() => _isLoading = false);
      return;
    }

    final usersBox = HiveDB.usersBox;
    final usernameExists = usersBox.values.any((u) => u.username == username);
    final emailExists = usersBox.values.any((u) => u.email == email);

    if (usernameExists) {
      _showError("Username sudah digunakan.");
      setState(() => _isLoading = false);
      return;
    }
    if (emailExists) {
      _showError("Email sudah digunakan.");
      setState(() => _isLoading = false);
      return;
    }

    final hashed = BcryptHelper.hashPassword(password);
    usersBox.add(UserModel(username: username, email: email, hashedPassword: hashed));
    
    if (!mounted) return;
    
    // Show success message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Registrasi Berhasil",
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Akun Anda berhasil dibuat. Silakan login dengan akun baru Anda.",
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to login
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text("OK"),
            ),
          ),
        ],
      ),
    );
    
    setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Error",
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG-login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Column(
                      children: [
                        Text(
                          'SEMODIA',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Services & Motorcycle Encyclopedia',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Register Form Container
                    Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Username Field
                          Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Email Field
                          Text(
                            'Email Address',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Password Field
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Confirm Password Field
                          Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Confirm your password',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 32),
                          
                          // Register Button
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Back to Login Link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Log In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
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
        ),
      ),
    );
  }
}