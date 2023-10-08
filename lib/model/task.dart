import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String text;
  final bool isDone;

  Task({
    required this.text,
    this.isDone = false,
  });

  @override
  List<Object?> get props => [text, isDone];

  @override
  String toString() => 'Task(text: $text, isDone: $isDone)';

  Task copyWith({
    String? text,
    bool? isDone,
  }) {
    return Task(
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }
}