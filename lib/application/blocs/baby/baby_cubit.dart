import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/baby.dart';
import '../../../domain/repositories/i_local_repository.dart';
import 'baby_state.dart';

class BabyCubit extends Cubit<BabyState> {
  final ILocalRepository _repo;

  BabyCubit(this._repo) : super(const BabyInitial());

  Future<void> load() async {
    emit(const BabyLoading());
    final result = await _repo.getBaby();
    result.fold(
      (f) => emit(BabyError(f.message)),
      (baby) => emit(baby != null ? BabyLoaded(baby) : const BabyEmpty()),
    );
  }

  Future<bool> save(Baby baby) async {
    final result = await _repo.saveBaby(baby);
    return result.fold(
      (f) {
        emit(BabyError(f.message));
        return false;
      },
      (_) {
        emit(BabyLoaded(baby));
        return true;
      },
    );
  }
}
