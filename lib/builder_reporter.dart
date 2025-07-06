import 'package:build/build.dart';

import 'generators/technical_debt_report_generator.dart';

Builder technicalDebtReporter(BuilderOptions options) {
  return TechnicalDebtReportBuilder();
}
