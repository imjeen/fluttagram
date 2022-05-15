part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  final BottomNavItem selectedItem;

  const BottomNavBarState(this.selectedItem);

  factory BottomNavBarState.initial() {
    return const BottomNavBarState(BottomNavItem.feed);
  }

  @override
  List<Object> get props => [selectedItem];
}
