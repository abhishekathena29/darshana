import 'package:flutter/material.dart';

/// The two kinds of accounts a person can create at sign up.
///
/// [devotee] is the regular explorer/worshipper account, while [temple]
/// represents an institution that hosts events and manages a sacred space.
enum UserRole {
  devotee,
  temple;

  String get title => switch (this) {
        UserRole.devotee => 'Devotee',
        UserRole.temple => 'Temple',
      };

  String get tagline => switch (this) {
        UserRole.devotee =>
          'Discover temples, follow sacred paths and join events.',
        UserRole.temple =>
          'Host events, manage your sanctuary and reach devotees.',
      };

  IconData get icon => switch (this) {
        UserRole.devotee => Icons.self_improvement,
        UserRole.temple => Icons.temple_hindu,
      };
}
