import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(selectedIndex: 0));

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
