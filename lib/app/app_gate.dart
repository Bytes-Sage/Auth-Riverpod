import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_authentication/features/auth/application/auth_controller.dart';
import 'package:riverpod_authentication/features/auth/presentation/home_screen.dart';
import 'package:riverpod_authentication/features/auth/presentation/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final user = ref.watch(authControllerProvider);

    if (user != null && user.emailVerified) {
      return HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
