import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

class TechnicalDebtReportBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$package$': [
      'technical_debt_report.html',
    ],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputs = await buildStep
        .findAssets(
          Glob(
            '**/*.technical_debt.json',
          ),
        )
        .toList();

    final allEntries = <Map<String, dynamic>>[];

    for (final input in inputs) {
      final content = await buildStep.readAsString(input);
      final entries = jsonDecode(content) as List<dynamic>;

      allEntries.addAll(entries.cast<Map<String, dynamic>>());
    }

    final html = _generateHtml(allEntries);
    final outputId = AssetId(
      buildStep.inputId.package,
      'technical_debt_report.html',
    );
    await buildStep.writeAsString(outputId, html);
  }

  String _generateHtml(List<Map<String, dynamic>> entries) {
    final rows = entries.map((e) => '''
      <tr>
        <td><a href="./${e['file']}">./${e['file']}</a></td>
        <td>${e['author']}</td>
        <td>${e['description']}</td>
        <td>${e['severity']}</td>
        <td>${e['deadline']}</td>
      </tr>
    ''').join();

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Technical Debt Report</title>
  <style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ccc; padding: 8px; }
    th { cursor: pointer; }
  </style>
</head>
<body>
  <h1>Technical Debt Report</h1>
  <table id="debtTable">
    <thead>
      <tr>
        <th>File Path</th>
        <th>Author</th>
        <th>Description</th>
        <th>Severity</th>
        <th>Deadline</th>
      </tr>
    </thead>
    <tbody>
      $rows
    </tbody>
  </table>
</body>
</html>
''';
  }
}
