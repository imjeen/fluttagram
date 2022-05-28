part of 'notify_bloc.dart';

abstract class NotifyEvent extends Equatable {
  const NotifyEvent();

  @override
  List<Object> get props => [];
}

class NotifyEventUpdate extends NotifyEvent {
  final List<Notify> notifications;
  const NotifyEventUpdate({required this.notifications});

  @override
  List<Object> get props => [notifications];
}
