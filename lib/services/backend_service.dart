import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple model representing one "todo" item from the test API.
class BackendTodo {
  final int id;
  final String title;
  final bool completed;

  BackendTodo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory BackendTodo.fromJson(Map<String, dynamic> json) {
    return BackendTodo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}

/// Service that knows how to talk to the web backend.
class BackendService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetch a sample todo from the backend to prove networking works.
  Future<BackendTodo> fetchSampleTodo() async {
    final uri = Uri.parse('$_baseUrl/todos/1');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load todo: ${response.statusCode}');
    }

    final Map<String, dynamic> data =
    jsonDecode(response.body) as Map<String, dynamic>;
    return BackendTodo.fromJson(data);
  }
}
