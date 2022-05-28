part of 'notify_bloc.dart';

enum NotifyStatus { initial, loading, loaded, error }

class NotifyState extends Equatable {
  final List<Notify> notifications;
  final NotifyStatus status;
  final Failure failure;
  const NotifyState({
    required this.notifications,
    required this.status,
    required this.failure,
  });

  factory NotifyState.initial() {
    return const NotifyState(
      notifications: [],
      status: NotifyStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [notifications, status, failure];

  NotifyState copyWith({
    List<Notify>? notifications,
    NotifyStatus? status,
    Failure? failure,
  }) {
    return NotifyState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
