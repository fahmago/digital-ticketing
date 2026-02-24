import 'package:flutter/material.dart';
import '../../../models/ticket.dart';

class EventCard extends StatelessWidget {
  final Ticket ticket;

  const EventCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Hero(
              tag: 'ticket-image-${ticket.id}',
              child: Image.network(
                ticket.imageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(ticket.date.toString()),
                Text('Rp ${ticket.price}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
