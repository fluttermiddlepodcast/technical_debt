import 'package:build/build.dart';
import 'package:technical_debt/generators/technical_debt_data_collector.dart';

Builder technicalDebtCollector(BuilderOptions options) {
  return TechnicalDebtCollectorBuilder();
}

