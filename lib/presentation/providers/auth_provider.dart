import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;

  const AuthResult({
    required this.isSuccess,
    this.errorMessage,
    this.user,
  });

  factory AuthResult.success(User user) =>
      AuthResult(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult(isSuccess: false, errorMessage: message);
}

class AuthState {
  final User? user;
  final bool isLoading;

  const AuthState({this.user, this.isLoading = false});
}

class AuthNotifier extends Notifier<AuthState> {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  AuthState build() {
    _client.auth.onAuthStateChange.listen((event) {
      state = AuthState(user: event.session?.user);
    });
    return AuthState(user: _client.auth.currentUser);
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = AuthState(user: state.user, isLoading: true);
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = AuthState(user: response.user);
      return AuthResult.success(response.user!);
    } on AuthException catch (e) {
      state = AuthState(user: null);
      return AuthResult.failure(_mapAuthError(e.message));
    } catch (e) {
      state = AuthState(user: null);
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      state = AuthState(user: state.user, isLoading: true);

      // 1. Pre-check if username is already taken (case-insensitive)
      try {
        final existing = await _client
            .from('profiles')
            .select('id')
            .ilike('username', username)
            .maybeSingle();
        if (existing != null) {
          state = const AuthState(user: null);
          return AuthResult.failure(
            'Username "$username" is already taken. Please choose another username.',
          );
        }
      } catch (_) {
        // If offline or query fails, proceed with Supabase auth signUp
      }

      // 2. Perform Supabase Auth sign-up
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      state = AuthState(user: response.user);

      if (response.user != null) {
        // 3. Create or upsert profile row
        String profileUsername = username;
        try {
          await _client.from('profiles').upsert({
            'id': response.user!.id,
            'username': profileUsername,
            'character_id': 'cyber_ninja',
            'level': 1,
            'xp': 0,
            'coins': 100,
            'streak': 0,
            'lives': 5,
            'rank_title': 'Script Kiddie',
            'favorite_language': 'python',
            'subscription_tier': 'free',
            'total_lessons_completed': 0,
            'total_challenges_completed': 0,
            'created_at': DateTime.now().toIso8601String(),
          });
        } on PostgrestException catch (pe) {
          if (pe.message.contains('profiles_username_key') || pe.code == '23505') {
            profileUsername = '${username}_${DateTime.now().millisecondsSinceEpoch % 1000}';
            try {
              await _client.from('profiles').upsert({
                'id': response.user!.id,
                'username': profileUsername,
                'character_id': 'cyber_ninja',
                'level': 1,
                'xp': 0,
                'coins': 100,
                'streak': 0,
                'lives': 5,
                'rank_title': 'Script Kiddie',
                'favorite_language': 'python',
                'subscription_tier': 'free',
                'total_lessons_completed': 0,
                'total_challenges_completed': 0,
                'created_at': DateTime.now().toIso8601String(),
              });
            } catch (_) {}
          }
        } catch (_) {
          // Trigger on_auth_user_created may have already created the profile
        }
        return AuthResult.success(response.user!);
      }
      return AuthResult.failure('Registration failed. Please try again.');
    } on AuthException catch (e) {
      state = const AuthState(user: null);
      return AuthResult.failure(_mapAuthError(e.message));
    } on PostgrestException catch (e) {
      state = const AuthState(user: null);
      if (e.message.contains('profiles_username_key') || e.code == '23505') {
        return AuthResult.failure(
          'Username "$username" is already taken. Please choose another username.',
        );
      }
      return AuthResult.failure(e.message);
    } catch (e) {
      state = const AuthState(user: null);
      final msg = e.toString();
      if (msg.contains('profiles_username_key') || msg.contains('23505')) {
        return AuthResult.failure(
          'Username "$username" is already taken. Please choose another username.',
        );
      }
      if (msg.contains('User already registered') || msg.contains('user_already_exists')) {
        return AuthResult.failure(
          'This email is already registered. Please go to Login to sign in.',
        );
      }
      return AuthResult.failure(_mapAuthError(msg));
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.codequest://login-callback',
      );
      return const AuthResult(isSuccess: true);
    } catch (e) {
      return AuthResult.failure('Google sign-in failed');
    }
  }

  Future<AuthResult> signInWithGitHub() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'io.supabase.codequest://login-callback',
      );
      return const AuthResult(isSuccess: true);
    } catch (e) {
      return AuthResult.failure('GitHub sign-in failed');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AuthState();
  }

  Future<AuthResult> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.codequest://reset-callback',
      );
      return const AuthResult(isSuccess: true);
    } catch (e) {
      return AuthResult.failure('Failed to send reset email');
    }
  }

  String _mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (message.contains('Email not confirmed')) {
      return 'Please verify your email first';
    } else if (message.contains('User already registered') ||
        message.contains('user_already_exists')) {
      return 'This email is already registered. Please tap "Sign In" to log in.';
    } else if (message.contains('Rate limit')) {
      return 'Too many attempts. Please wait a moment.';
    } else if (message.contains('Password should be at least')) {
      return 'Password must be at least 6 characters.';
    }
    return message;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).user != null;
});
