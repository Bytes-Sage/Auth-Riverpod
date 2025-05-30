import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_authentication/core/proiders/firebase_providers.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>((
  ref,
) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<User?> {
  final Ref _ref;
  AuthController(this._ref) : super(null) {
    _ref.read(firebaseAuthProvider).authStateChanges().listen((user) {
      state = user;
    });
  }

  Future signUp(String email, String password) async {
    try {
      final credential = await _ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.sendEmailVerification();
    } catch (e) {
      //
      throw Exception("Sign up failed: $e");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await _ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        throw Exception("Please verify your email before loggin in.");
      }
    } catch (e) {
      //
      throw Exception("Login Failed: $e");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Reset failed: $e");
    }
  }

  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
