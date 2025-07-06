import 'package:technical_debt/technical_debt/severity.dart';

class TechnicalDebt {
  const TechnicalDebt({
    required this.author,
    required this.description,
    required this.severity,
    this.deadline = '',
  });

  final String author;
  final String description;
  final Severity severity;
  final String? deadline;
}
