import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/ticket_repository.dart';
import './ticket_event.dart';
import './ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc({required this.ticketRepository}) : super(TicketInitial()) {
    on<LoadTickets>(_onLoadTickets);
    on<RefreshTickets>(_onRefreshTickets);
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());

    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: 'Failed to fetch tikets: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTickets(
    RefreshTickets event,
    Emitter<TicketState> emit,
  ) async {
    try {
      final tickets = await ticketRepository.getTickets();

      emit(TicketLoaded(tickets: tickets));
    } catch (e){
      emit(TicketError(message: 'Failed to refresh: ${e.toString()}'));
    }
  }
}
