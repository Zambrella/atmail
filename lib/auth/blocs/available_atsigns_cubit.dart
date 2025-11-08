import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'available_atsigns_cubit.mapper.dart';

@MappableClass()
class AvailableAtsignsState with AvailableAtsignsStateMappable {
  const AvailableAtsignsState({
    this.atsigns = const [],
    this.isLoading = false,
    this.error,
  });

  final List<String> atsigns;
  final bool isLoading;
  final String? error;
}

class AvailableAtsignsCubit extends Cubit<AvailableAtsignsState> {
  AvailableAtsignsCubit() : super(const AvailableAtsignsState());

  void fetchAvailableAtsigns() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final atsigns = await KeyChainManager.getInstance().getAtSignListFromKeychain();
      emit(state.copyWith(atsigns: atsigns, isLoading: false, error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString(), isLoading: false));
    }
  }
}
