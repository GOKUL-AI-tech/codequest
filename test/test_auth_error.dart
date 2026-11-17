import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:codequest/core/constants/app_constants.dart';

void main() async {
  test('Test Supabase signup exception type', () async {
    final client = SupabaseClient(
      AppConstants.supabaseUrl,
      AppConstants.supabaseAnonKey,
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );

    try {
      final res = await client.auth.signUp(
        email: 'admin@example.com',
        password: 'Password@123',
        data: {'username': 'GOKUL'},
      );
      print('Response user: ${res.user?.id}');
      print('Response session: ${res.session?.accessToken}');
    } catch (e, s) {
      print('Caught exception runtimeType: ${e.runtimeType}');
      print('Caught exception toString: $e');
      if (e is AuthException) {
        print('e is AuthException: message="${e.message}", statusCode="${e.statusCode}", code="${e.code}"');
      }
    }
  });
}
