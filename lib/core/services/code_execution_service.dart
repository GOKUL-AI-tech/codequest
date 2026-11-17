import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── Models ───────────────────────────────────────────────────────────────────

class ExecutionResult {
  final String stdout;
  final String stderr;
  final String output; // stdout + stderr combined
  final int exitCode;
  final bool success;
  final String? errorMessage;

  const ExecutionResult({
    required this.stdout,
    required this.stderr,
    required this.output,
    required this.exitCode,
    required this.success,
    this.errorMessage,
  });

  factory ExecutionResult.error(String message) => ExecutionResult(
        stdout: '',
        stderr: message,
        output: message,
        exitCode: 1,
        success: false,
        errorMessage: message,
      );
}

// ─── Language → Piston runtime mapping ───────────────────────────────────────

class _Runtime {
  final String language;
  final String version;
  const _Runtime(this.language, this.version);
}

const _runtimes = <String, _Runtime>{
  'python':     _Runtime('python',     '3.10.0'),
  'javascript': _Runtime('javascript', '18.15.0'),
  'java':       _Runtime('java',       '15.0.2'),
  'cpp':        _Runtime('c++',        '10.2.0'),
  'c':          _Runtime('c',          '10.2.0'),
  'dart':       _Runtime('dart',       '2.19.6'),
  'typescript': _Runtime('typescript', '5.0.3'),
  'sql':        _Runtime('sqlite3',    '3.36.0'),
  'html':       _Runtime('javascript', '18.15.0'), // render via JS
};

// ─── Service ──────────────────────────────────────────────────────────────────

class CodeExecutionService {
  CodeExecutionService._();
  static final CodeExecutionService instance = CodeExecutionService._();

  static const _baseUrl = 'https://emkc.org/api/v2/piston';
  static const _timeout = Duration(seconds: 15);

  /// Execute [code] in the given [languageId].
  /// [stdin] is optional input for the program.
  Future<ExecutionResult> execute({
    required String languageId,
    required String code,
    String stdin = '',
  }) async {
    final runtime = _runtimes[languageId];
    if (runtime == null) {
      return ExecutionResult.error(
          'Language "$languageId" is not supported for live execution.');
    }

    try {
      final body = jsonEncode({
        'language': runtime.language,
        'version': runtime.version,
        'files': [
          {'content': code}
        ],
        if (stdin.isNotEmpty) 'stdin': stdin,
      });

      final response = await http
          .post(
            Uri.parse('$_baseUrl/execute'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        return ExecutionResult.error(
            'Server error ${response.statusCode}. Try again.');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final run = json['run'] as Map<String, dynamic>;

      final stdout = (run['stdout'] as String?) ?? '';
      final stderr = (run['stderr'] as String?) ?? '';
      final exitCode = (run['code'] as int?) ?? 0;

      return ExecutionResult(
        stdout: stdout,
        stderr: stderr,
        output: stdout.isNotEmpty ? stdout : stderr,
        exitCode: exitCode,
        success: exitCode == 0 && stderr.isEmpty,
      );
    } on http.ClientException {
      return ExecutionResult.error('No internet connection.');
    } catch (e) {
      return ExecutionResult.error('Execution failed: $e');
    }
  }

  /// Returns true if [languageId] supports live execution.
  bool supportsExecution(String languageId) =>
      _runtimes.containsKey(languageId);
}
