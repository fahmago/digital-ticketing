import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/validators.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../models/user.dart';

/// BLoC for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthBloc() : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);

        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check auth status: ${e.toString()}'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);

      if (emailError != null || passwordError != null) {
        emit(AuthError(message: emailError ?? passwordError!));
        return;
      }

      await Future.delayed(const Duration(seconds: 1));

      final user = User(id: '123', email: event.email, name: 'User Demo');

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Login Gagal: ${e.toString()}'));
    }
  }

  /// Handle registration request with validation
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Set state menjadi Loading
    emit(const AuthLoading());

    try {
      // 2. Validasi Input (termasuk Name)
      final nameError = Validators.validateName(event.name);
      if (nameError != null) {
        emit(AuthError(message: nameError));
        return;
      }

      final emailError = Validators.validateEmail(event.email);
      if (emailError != null) {
        emit(AuthError(message: emailError));
        return;
      }

      final passwordError = Validators.validatePassword(event.password);
      if (passwordError != null) {
        emit(AuthError(message: passwordError));
        return;
      }

      // 3. Simulasi API Call (Delay)
      await Future.delayed(const Duration(seconds: 1));

      // 4. Buat User Object baru
      // (Di real app, ini response dari Backend/Firebase)
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID
        email: event.email,
        name: event.name,
      );

      // 5. Simpan sesi login (Persistence);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      // 6. Emit state Authenticated (Sukses)
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      // 7. Tangani jika ada error (misal koneksi putus)
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in'); // Hapus flag login
      await prefs.remove('user_data'); // Hapus data user
      emit(const AuthUnauthenticated()); // Emit state keluar
    } catch (e) {
      emit(AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }
}
