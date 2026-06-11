// Tracks RSVP status per event for the current user.
import 'package:flutter/foundation.dart';

enum RsvpStatus { going, interested, none }

class RsvpProvider extends ChangeNotifier {
  final Map<String, RsvpStatus> _rsvps = {
    'e1': RsvpStatus.going,
    'e2': RsvpStatus.going,
    'e3': RsvpStatus.interested,
    'e4': RsvpStatus.going,
  };

  RsvpStatus getStatus(String eventId) =>
      _rsvps[eventId] ?? RsvpStatus.none;

  void setRsvp(String eventId, RsvpStatus status) {
    _rsvps[eventId] = status;
    notifyListeners();
  }

  void clearRsvp(String eventId) {
    _rsvps[eventId] = RsvpStatus.none;
    notifyListeners();
  }

  List<String> getEventIdsByStatus(RsvpStatus status) =>
      _rsvps.entries
          .where((e) => e.value == status)
          .map((e) => e.key)
          .toList();
}
