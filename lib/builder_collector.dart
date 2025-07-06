import 'package:build/build.dart';

import 'generators/technical_debt_data_collector.dart';

Builder technicalDebtCollector(BuilderOptions options) {
  return TechnicalDebtCollectorBuilder();
}

