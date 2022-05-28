import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/notify_model.dart';
import 'package:fluttagram/repositories/notify/notify_repository.dart';

part 'notify_event.dart';
part 'notify_state.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  final AuthBloc authBloc;
  final NotifyRepository notifyRepository;

  NotifyBloc({
    required this.authBloc,
    required this.notifyRepository
  }) : super(NotifyState.initial()) {
    _setup();
    on<NotifyEventUpdate>(_notificationsEventUpdate);
  }

  StreamSubscription<List<Future<Notify?>>>? _notificationsSubscription;

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }

  void _notificationsEventUpdate(
    NotifyEventUpdate event,
    Emitter<NotifyState> emit,
  ) {
    emit(state.copyWith(
      notifications: event.notifications,
      status: NotifyStatus.loaded,
    ));
  }

  void _setup() async {
    try {
      _notificationsSubscription?.cancel();

      _notificationsSubscription = notifyRepository
          .getUserNotifications(userId: authBloc.state.user.id)
          .listen(
        (notifs) async {
          final allNotifs = await Future.wait(notifs);
          add(NotifyEventUpdate(
            notifications: allNotifs.whereType<Notify>().toList(),
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        failure: const Failure(message: 'unable update notification'),
        status: NotifyStatus.error,
      ));
    }
  }
}
