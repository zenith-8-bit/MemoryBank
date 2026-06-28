// ────────────────────────────────────────────
//  models/memory_model.dart
// ────────────────────────────────────────────

enum MemoryType { task, event, payment, doc, travel, info, note, health, shopping, bill }

enum MemoryStatus { paid, unpaid, completed, pending }

class MemoryItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final MemoryType type;
  final DateTime capturedAt;
  final String? amount;
  final MemoryStatus? status;
  final bool isStarred;
  final bool isHighlighted;
  final String? imageUrl;
  final String? bankAccount;

  const MemoryItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.type,
    required this.capturedAt,
    this.amount,
    this.status,
    this.isStarred = false,
    this.isHighlighted = false,
    this.imageUrl,
    this.bankAccount,
  });
}

// ────────────────────────────────────────────
//  models/capture_model.dart
// ────────────────────────────────────────────

enum CaptureType { bill, shopping, health, document, screenshot, receipt }

class CaptureItem {
  final String id;
  final String title;
  final String? amount;
  final DateTime capturedAt;
  final CaptureType type;
  final String? imageUrl;
  final String? merchant;

  const CaptureItem({
    required this.id,
    required this.title,
    this.amount,
    required this.capturedAt,
    required this.type,
    this.imageUrl,
    this.merchant,
  });
}

// ────────────────────────────────────────────
//  models/payment_model.dart
// ────────────────────────────────────────────

enum PaymentCategory { all, bills, subscriptions, shopping }

class PaymentItem {
  final String id;
  final String title;
  final String amount;
  final DateTime date;
  final String? accountMasked;
  final PaymentCategory category;
  final bool isPaid;
  final String iconLabel; // initials or icon key

  const PaymentItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.accountMasked,
    required this.category,
    this.isPaid = false,
    required this.iconLabel,
  });
}

// ────────────────────────────────────────────
//  models/onboarding_model.dart
// ────────────────────────────────────────────

class FeatureItem {
  final String icon;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class PersonaOption {
  final String id;
  final String label;

  const PersonaOption({required this.id, required this.label});
}

class PriorityOption {
  final String id;
  final String label;

  const PriorityOption({required this.id, required this.label});
}

// ────────────────────────────────────────────
//  models/ask_suggestion_model.dart
// ────────────────────────────────────────────

class AskSuggestion {
  final String id;
  final String question;
  final String iconKey;

  const AskSuggestion({
    required this.id,
    required this.question,
    required this.iconKey,
  });
}