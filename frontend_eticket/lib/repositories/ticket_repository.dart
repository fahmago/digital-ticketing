import '../models/ticket.dart';

class TicketRepository {
  static final List<Ticket> _mockTickets = [
    Ticket(
      id: '1',
      title: 'Avatar Fire and Ash',
      description: 'Trilogy of avatars',
      price: 45000,
      date: DateTime.now().add(const Duration(days: 30)),
      imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/25AFAA.jpg',
    ),
    Ticket(
      id: '2',
      title: 'Avatar Tulkun',
      description: 'Trilogy of avatars',
      price: 45000,
      date: DateTime.now().add(const Duration(days: 30)),
      imageUrl: 'https://mydirtsheet.com/wp-content/uploads/2022/12/MV5BM2VhYjIwMDQtZjY4OS00Yjk2LWI5YjktNjQxOTE0MjE4NjBkXkEyXkFqcGdeQXVyMDM2NDM2MQ@@._V1_FMjpg_UX1000_.jpg',
    )
  ];

  Future<List<Ticket>> getTickets() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockTickets;
  }

  Future<Ticket?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _mockTickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Ticket>> searchTickets(String query) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockTickets.where((ticket) {
    return ticket.title.toLowerCase().contains(query.toLowerCase());
  }).toList();
}
}

