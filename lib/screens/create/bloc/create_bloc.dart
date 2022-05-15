import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial()) {
    on<CreateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
