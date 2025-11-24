import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'atsign_manager_cubit.mapper.dart';

@MappableClass()
class AtSignManagerState with AtSignManagerStateMappable {
  const AtSignManagerState({
    required this.currentAtsign,
    this.isLoading = false,
    this.error,
  });

  final String currentAtsign;
  final bool isLoading;
  final String? error;
}

class AtSignManagerCubit extends Cubit<AtSignManagerState> {
  AtSignManagerCubit(this._atClientPreference)
    : super(
        AtSignManagerState(
          currentAtsign: AtClientManager.getInstance().atClient.getCurrentAtSign()!,
          isLoading: false,
        ),
      );

  final AtClientPreference _atClientPreference;

  Future<void> switchAtSign(String newAtSign) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final _ = await AtClientManager.getInstance().setCurrentAtSign(
        newAtSign,
        _atClientPreference.namespace,
        _atClientPreference,
      );
      final result = await AtOnboarding.changePrimaryAtsign(atsign: newAtSign);
      if (result) {
        emit(state.copyWith(currentAtsign: newAtSign, isLoading: false));
      } else {
        emit(state.copyWith(error: 'Failed to switch atsign', isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
