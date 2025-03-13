import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/auth_controller.dart';
import 'package:movie_app/View/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.movie, size: 50, color: Colors.white),
              ),
              SizedBox(height: 20),

              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white70),
                ),
              ),
              SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator(color: Colors.red)
                  : ElevatedButton(
                      onPressed: () {
                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          Get.snackbar("Error", "Email and password cannot be empty!",
                              backgroundColor: Colors.red, colorText: Colors.white);
                        } else {
                          authController.login(emailController.text, passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    )),
              SizedBox(height: 15),

             
              GestureDetector(
                onTap: () => Get.to(() => RegisterScreen()),
                child: Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              SizedBox(height: 25),
              Divider(color: Colors.white54),
              SizedBox(height: 15),

              
            ],
          ),
        ),
      ),
    );
  }
}