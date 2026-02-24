import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_eticket/blocs/auth_bloc.dart';
import 'package:frontend_eticket/blocs/auth_event.dart';
import 'package:frontend_eticket/blocs/auth_state.dart';
import 'package:frontend_eticket/screens/auth/login_screen.dart';
import 'package:frontend_eticket/screens/auth/register_screen.dart';
import 'package:frontend_eticket/screens/dashboard/ticket_detail.screen.dart';
import 'package:frontend_eticket/screens/dashboard_screen.dart';
// import 'bloc/auth_bloc.dart';
// import 'bloc/auth_event.dart';
// import 'bloc/auth_state.dart';

void main() {
  runApp(const ETicketingApp());
}

class ETicketingApp extends StatelessWidget {
  const ETicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(const CheckAuthStatus()),
      child: MaterialApp(
        title: 'E-Ticketing App',
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/ticket-detail': (context) => const TicketDetailScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const DashboardScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        }  
        return const Scaffold(
          body: Center(child: CircularProgressIndicator())
        );
      },
    );
  }
}
