import 'package:fluttagram/screens/profile/profile_screen.dart';
import 'package:fluttagram/screens/search/cubit/search_cubit.dart';
import 'package:fluttagram/widgets/centered_text.dart';
import 'package:fluttagram/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              hintText: 'Search Users',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              case SearchStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 22.0,
                              avatarUrl: user.profileImageUrl,
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(userId: user.id),
                            ),
                          );
                        },
                      )
                    : const CenteredText(text: 'No users found');
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
