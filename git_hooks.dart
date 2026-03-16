import 'package:ansicolor/ansicolor.dart';
import 'package:dart_pre_commit/dart_pre_commit.dart';
import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  final params = <Git, UserBackFun>{
    Git.commitMsg: _conventionalCommitMsg,
    Git.preCommit: _preCommit,
  };
  GitHooks.call(arguments, params);
}

class CommitColors {
  static final error = AnsiPen()..red(bold: true);
  static final warning = AnsiPen()..yellow();
  static final info = AnsiPen()..cyan();
}

class CommitMessages {
  static const emptyCommitMsg = '❌ El mensaje de commit está vacío.';
  static const invalidCommitMsgPattern =
      '❌ El mensaje debe seguir el patrón de commit convencional: '
      'https://www.conventionalcommits.org/en/v1.0.0/';
  static const validCommitTypes = '⚠️  Tipos válidos:\n';
  static const shortCommitMsg =
      '❌ El mensaje de commit es demasiado corto. Longitud actual: ';
}

const int minCommitMsgLength = 15;

// Mapa de tipos de commit y sus descripciones
const Map<String, String> commitTypes = {
  'feat': 'Añade una nueva funcionalidad.',
  'fix': 'Corrige un error.',
  'refactor': 'Cambios que no corrigen errores ni añaden funcionalidad.',
  'build': 'Cambios que afectan el sistema de build o dependencias.',
  'chore': 'Actualizaciones menores que no afectan la lógica de la aplicación.',
  'perf': 'Cambios que mejoran el rendimiento.',
  'ci': 'Cambios en archivos de configuración de CI.',
  'docs': 'Cambios en la documentación.',
  'revert': 'Reversión de commits anteriores.',
  'style':
      'Cambios que no afectan el significado del código (espacios en blanco, formato, etc.).',
  'test': 'Añadir tests que fallan o corrigen tests existentes.',
  'merge': 'Cambios que se producen al fusionar ramas.',
};

Future<bool> _preCommit() async {
  try {
    final result = await DartPreCommit.run();
    return result.isSuccess;
  } on Exception catch (e) {
    _printMessage('❌ Error en pre-commit: $e', CommitColors.error);
    return false;
  }
}

Future<bool> _conventionalCommitMsg() async {
  try {
    final commitMsg = Utils.getCommitEditMsg();
    if (commitMsg.isEmpty) {
      _printMessage(CommitMessages.emptyCommitMsg, CommitColors.error);
      return false;
    }

    if (CommitValidator.isValidCommitType(commitMsg)) {
      if (CommitValidator.isConventionalCommit(commitMsg)) {
        return true;
      } else {
        CommitValidator.printInvalidCommitMessage(commitMsg);
      }
    } else {
      CommitValidator.printInvalidCommitTypeMessage(commitMsg);
    }
  } on Exception catch (e) {
    _printMessage(
      '❌ Error al obtener el mensaje de commit: $e',
      CommitColors.error,
    );
    return false;
  }
  return false;
}

class CommitValidator {
  static final String typePattern = '^(${commitTypes.keys.join('|')})';
  static const String scopePattern = r'(\([\w\-\.]+\))?';
  static const String breakingChangePattern = '(!)?';
  static const String delimiterPattern = ': ';
  static const String descriptionPattern = '(.+)';
  static const String bodyPattern = r'([\s\S]*)';

  static final RegExp conventionCommitPattern = RegExp(
    '$typePattern$scopePattern$breakingChangePattern$delimiterPattern$descriptionPattern$bodyPattern',
  );

  static bool isValidCommitType(String commitMsg) {
    return commitTypes.keys.any(
      (type) =>
          commitMsg.startsWith('$type:') || commitMsg.startsWith('$type('),
    );
  }

  static bool isConventionalCommit(String commitMsg) {
    return conventionCommitPattern.hasMatch(commitMsg) &&
        commitMsg.length > minCommitMsgLength;
  }

  static void printInvalidCommitMessage(String commitMsg) {
    final commitType = commitMsg.split(':').first;
    if (commitMsg.length <= minCommitMsgLength) {
      _printMessage(
        '${CommitMessages.shortCommitMsg}${commitMsg.length}\n   Mensaje de commit: $commitMsg',
        CommitColors.warning,
      );
    }
    _printMessage(
      '⚠️  Tipo de commit: $commitType - ${commitTypes[commitType]}',
      CommitColors.info,
    );
  }

  static void printInvalidCommitTypeMessage(String commitMsg) {
    _printMessage(
      '${CommitMessages.invalidCommitMsgPattern}\n   Mensaje de commit: $commitMsg',
      CommitColors.error,
    );
    _printMessage(
      '${CommitMessages.validCommitTypes}${_formatCommitTypes()}',
      CommitColors.info,
    );
  }

  static String _formatCommitTypes() {
    return commitTypes.entries
        .map((entry) => '    - ${entry.key}: ${entry.value}')
        .join('\n');
  }
}

void _printMessage(String message, AnsiPen pen) {
  // ignore: avoid_print, this is a CLI tool that needs stdout output
  print(pen(message));
}
