import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.question,
    required super.type,
    required super.options,
    required super.correctAnswer,
    required super.difficulty,
    required super.category,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] == 'boolean'
        ? QuestionType.boolean
        : QuestionType.multiple;

    List<String> options = [];
    if (type == QuestionType.boolean) {
      options = ['True', 'False'];
    } else {
      // Combine incorrect and correct answers and shuffle
      final incorrectAnswers = (json['incorrect_answers'] as List)
          .map((e) => _decodeHtml(e.toString()))
          .toList();
      final correctAnswer = _decodeHtml(json['correct_answer'].toString());
      options = [...incorrectAnswers, correctAnswer];
      options.shuffle();
    }

    return QuestionModel(
      question: _decodeHtml(json['question']),
      type: type,
      options: options,
      correctAnswer: _decodeHtml(json['correct_answer']),
      difficulty: json['difficulty'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'type': type == QuestionType.boolean ? 'boolean' : 'multiple',
      'correct_answer': correctAnswer,
      'difficulty': difficulty,
      'category': category,
    };
  }

  static String _decodeHtml(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&hellip;', '...')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&uuml;', 'ü')
        .replaceAll('&ouml;', 'ö');
  }
}
