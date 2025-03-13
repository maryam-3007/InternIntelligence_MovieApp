import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/View/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    user.bindStream(auth.authStateChanges());
  }

  Future<void> register(String username, String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(username);

      
      await userCredential.user?.reload();
      user.value = auth.currentUser;

      Get.snackbar("Success", "Account Created", backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAll(() => HomeScreen()); 
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged In", backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAll(() => HomeScreen()); 
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null && userCredential.user!.displayName != null) {
        user.value = userCredential.user;
      }

      Get.snackbar("Success", "Signed in with Google", backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAll(() => HomeScreen()); 
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed('/login'); 
  }
}