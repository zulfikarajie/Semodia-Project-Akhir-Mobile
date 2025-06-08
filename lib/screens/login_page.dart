import 'package:flutter/material.dart';
import '../db/hive_db.dart';
import '../models/user_model.dart';
import '../utils/bcrypt_helper.dart';
import '../utils/session_manager.dart';
import 'register_page.dart';
import '../widgets/bottom_navbar.dart'; // Pastikan path ini sesuai dengan lokasi BottomNavbar kamu

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() async {
    setState(() => _isLoading = true);

    final input = _usernameController.text.trim();
    final password = _passwordController.text;

    final usersBox = HiveDB.usersBox;
    final user = usersBox.values.firstWhere(
      (u) => u.username == input || u.email == input,
      orElse: () => UserModel(username: '', email: '', hashedPassword: ''),
    );

    if (user.username.isNotEmpty &&
        BcryptHelper.verifyPassword(password, user.hashedPassword)) {
      await SessionManager.saveSession(user.username);
      if (!mounted) return;
      // Navigasi ke BottomNavbar, bukan HomePage
      Navigator.pushReplacementNamed(context, '/home');
      // Atau jika tidak pakai named route:
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => BottomNavbar()),
      //   (route) => false,
      // );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black87.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Login Gagal",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Username/email atau password salah!",
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
    setState(() => _isLoading = false);
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
                    
                    SizedBox(height: 60),
                    
                    // Login Form Container
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
                          // Username/Email Field
                          Text(
                            'Username or Email Address',
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
                                hintText: 'Username or Email Address',
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
                          
                          SizedBox(height: 24),
                          
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
                          
                          SizedBox(height: 32),
                          
                          // Login Button
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
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
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Register Link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RegisterPage()),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have account? ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
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