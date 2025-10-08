import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/update_user_progress.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;
  final UpdateUserProgress updateUserProgress;

  UserBloc({
    required this.getUser,
    required this.updateUserProgress,
  }) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserProgressEvent>(_onUpdateUserProgress);
  }

  Future<void> _onLoadUser(
    LoadUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    final result = await getUser(NoParams());
    
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(UserError(message: failure.message)),
        (user) => emit(UserLoaded(user: user)),
      );
    }
  }

  Future<void> _onUpdateUserProgress(
    UpdateUserProgressEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final result = await updateUserProgress(
        UpdateUserProgressParams(
          quizzesTaken: event.quizzesTaken,
          scoreToAdd: event.scoreToAdd,
        ),
      );
      
      await result.fold(
        (failure) async {
          if (!emit.isDone) {
            emit(UserError(message: failure.message));
          }
        },
        (_) async {
          // Reload user after update
          final userResult = await getUser(NoParams());
          if (!emit.isDone) {
            userResult.fold(
              (failure) => emit(UserError(message: failure.message)),
              (user) => emit(UserLoaded(user: user)),
            );
          }
        },
      );
    }
  }
}
