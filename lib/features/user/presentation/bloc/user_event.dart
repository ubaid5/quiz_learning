import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class UpdateUserProgressEvent extends UserEvent {
  final int quizzesTaken;
  final int scoreToAdd;

  const UpdateUserProgressEvent({
    required this.quizzesTaken,
    required this.scoreToAdd,
  });

  @override
  List<Object?> get props => [quizzesTaken, scoreToAdd];
}
