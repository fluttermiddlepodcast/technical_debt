import 'package:build/build.dart';
import 'package:technical_debt/generators/technical_debt_report_generator.dart';

Builder technicalDebtReporter(BuilderOptions options) {
  return TechnicalDebtReportBuilder();
}
