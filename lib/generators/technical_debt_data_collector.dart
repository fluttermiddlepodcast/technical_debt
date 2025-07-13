import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
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
      final annotation = _getAnnotation(element);
      if (annotation != null) {
        debts.add(
          {
            'file': inputId.path,
            'author': annotation.getField('author')?.toStringValue(),
            'description': annotation.getField('description')?.toStringValue(),
            'severity': annotation.getField('severity')?.getField('_name')?.toStringValue(),
            'deadline': annotation.getField('deadline')?.toStringValue(),
          },
        );
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

  DartObject? _getAnnotation(Element element) {
    for (final meta in element.metadata) {
      final value = meta.computeConstantValue();
      final type = value?.type;
      if (type != null && type.element?.name == 'TechnicalDebt') {
        return value;
      }
    }
    return null;
  }
}
