import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/features/chat/all_chats/controllers/all_chats_cubit.dart';
import 'package:sakeny/features/chat/all_chats/models/chat_tile_model.dart';
import 'package:sakeny/features/chat/all_chats/screens/widgets/chat_tile.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class AllChatsScreens extends StatelessWidget {
  const AllChatsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final AllChatsCubit allChatsCubit = context.read<AllChatsCubit>();
    final S lang = S.of(context);

    return CustomScaffold(
      scaffoldKey: allChatsCubit.scaffoldKey,
      screenTitle: lang.drawerChat,
      openDrawer: () => allChatsCubit.scaffoldKey.currentState?.openEndDrawer(),
      onBack: () => Navigator.pop(context),
      body: const _AllChatsBody(),
    );
  }
}

class _AllChatsBody extends StatelessWidget {
  const _AllChatsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllChatsCubit, AllChatsState>(
      builder: (context, state) {
        switch (state) {
          case AllChatsLoading():
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const ChatTileShimmer(),
            );

          case AllChatsLoaded():
            return state.chatTiles.isEmpty
                ? const _EmptyChatsBody()
                : _AllChatsLoadedBody(chatTiles: state.chatTiles);

          case AllChatsError():
            return Center(child: Text(state.error));
        }
      },
    );
  }
}

class _EmptyChatsBody extends StatelessWidget {
  const _EmptyChatsBody();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Padding(
      padding: ConstConfig.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ConstImages.emptyChat,
            width: 120,
            height: 120,
            colorFilter: ColorFilter.mode(
              colors.text,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 8),
          Text(lang.emptyChatTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            lang.emptyChatMessage,
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.text.withOpacity(0.5)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _AllChatsLoadedBody extends StatelessWidget {
  const _AllChatsLoadedBody({required this.chatTiles});

  final List<ChatTileModel> chatTiles;

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final UserAuthState userState = (homeCubit.state as HomeLoaded).user;
    final String myId = (userState as AuthenticatedUser).userModel!.userId;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: chatTiles.length,
      itemBuilder: (context, index) => ChatTile(
        chatTileModel: chatTiles[index],
        onTap: () {
          Navigator.pushNamed(
            context,
            PageRouteNames.chat,
            arguments: ChatArgs(
              chatId: chatTiles[index].chatId,
              myId: myId,
              otherId: chatTiles[index].senderId,
              receiverName: chatTiles[index].name,
              receiverImageUrl: chatTiles[index].profilePicture,
              profilePictureHeroTag: "${chatTiles[index].senderId}_${chatTiles[index].name}",
            ),
          );
        },
      ),
    );
  }
}
