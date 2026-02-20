import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_eticket/blocs/auth_bloc.dart';
import 'package:frontend_eticket/blocs/auth_event.dart';
import 'package:frontend_eticket/blocs/auth_state.dart';
import 'package:frontend_eticket/models/ticket.dart';
import '../blocs/ticket/ticket_bloc.dart';
import '../blocs/ticket/ticket_event.dart';
import '../blocs/ticket/ticket_state.dart';
import '../screens/dashboard/widgets/event_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void InitState() {
    super.initState();
    context.read<TicketBloc>().add(const LoadTickets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketError) {
              return Center(child: Text(state.message));
            } else if (state is TicketLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  return EventCard(ticket: state.tickets[index]);
                },
              );
            }
            return const Center(child: Text('No tickets available'));
          },
        ),
      ),
    );
  }
}
