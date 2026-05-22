import 'package:equatable/equatable.dart';
import '../../../domain/entities/baby.dart';

sealed class BabyState extends Equatable {
  const BabyState();
  @override
  List<Object?> get props => [];
}

final class BabyInitial extends BabyState {
  const BabyInitial();
}

final class BabyLoading extends BabyState {
  const BabyLoading();
}

final class BabyEmpty extends BabyState {
  const BabyEmpty();
}

final class BabyLoaded extends BabyState {
  final Baby baby;
  const BabyLoaded(this.baby);
  @override
  List<Object?> get props => [baby];
}

final class BabyError extends BabyState {
  final String message;
  const BabyError(this.message);
  @override
  List<Object?> get props => [message];
}
