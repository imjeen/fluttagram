part of 'auth_bloc.dart';

// 枚举情形
enum AuthStatus { unknown, authenticated, unauthenticated }

// 认证状态类
class AuthState extends Equatable {
  final User user;
  final AuthStatus status;

  const AuthState({
    this.user = User.empty,
    this.status = AuthStatus.unknown,
  });

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unknown);
  }

  @override
  List<Object> get props => [user, status];
}
