part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final File profileImage;
  final String username;
  final String bio;
  final EditProfileStatus status;
  final Failure failure;

  const EditProfileState({
    required this.profileImage,
    required this.username,
    required this.bio,
    required this.status,
    required this.failure,
  });

  factory EditProfileState.initial() {
    return EditProfileState(
      profileImage: File(''), // checked: path.isNotEmpty
      username: '',
      bio: '',
      failure: const Failure(),
      status: EditProfileStatus.initial,
    );
  }

  @override
  List<Object> get props => [profileImage, username, bio, status, failure];

  EditProfileState copyWith({
    File? profileImage,
    String? username,
    String? bio,
    EditProfileStatus? status,
    Failure? failure,
  }) {
    return EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
