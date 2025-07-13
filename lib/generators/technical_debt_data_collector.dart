import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class TechnicalDebtCollectorBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': [
      '.technical_debt.json',
    ],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    if (!await buildStep.resolver.isLibrary(inputId)) {
      return;
    }

    final library = await buildStep.resolver.libraryFor(inputId);
    final reader = LibraryReader(library);

    final debts = <Map<String, dynamic>>[];

    for (final element in reader.allElements) {
      for (final annotation in element.metadata) {
        final annotationData = annotation.computeConstantValue();

        if (annotationData != null && annotationData.type?.element3?.name3 == 'TechnicalDebt') {
          debts.add(
            {
              'file': inputId.path,
              'author': annotationData.getField('author')?.toStringValue(),
              'description': annotationData.getField('description')?.toStringValue(),
              'severity': annotationData.getField('severity')?.getField('_name')?.toStringValue(),
              'deadline': annotationData.getField('deadline')?.toStringValue(),
            },
          );
        }
      }
    }

    if (debts.isNotEmpty) {
      final outId = inputId.changeExtension(
        '.technical_debt.json',
      );

      await buildStep.writeAsString(
        outId,
        jsonEncode(debts),
      );
    }
  }
}
