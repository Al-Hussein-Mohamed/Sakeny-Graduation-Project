part of '../unit_screen.dart';

class _OwnerCard extends StatelessWidget {
  const _OwnerCard();

  @override
  Widget build(BuildContext context) {
    final UnitCubit unitCubit = context.read<UnitCubit>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final UnitModel unit = InheritedUnit.of(context);
    final S lang = S.of(context);
    final bool isOwner = (homeCubit.user is GuestUser)
        ? false
        : (homeCubit.user as AuthenticatedUser).userModel?.userId == unit.ownerId;

    void chatButtonOnTap() {
      switch (homeCubit.user) {
        case GuestUser():
          ToastificationService.showGlobalGuestLoginToast();
          break;

        case AuthenticatedUser(userModel: final user):
          Navigator.pushNamed(
            context,
            PageRouteNames.chat,
            arguments: ChatArgs(
              myId: user!.userId,
              otherId: unit.ownerId,
              receiverName: unit.ownerName,
              receiverImageUrl: unit.ownerProfilePictureUrl,
              profilePictureHeroTag:
                  unit.ownerProfilePictureUrl ?? "null hero tag profile picture ${unit.ownerId}",
            ),
          );
          break;
      }
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: () => unitCubit.goToProfile(context: context),
          child: Stack(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF66909D), Color(0xFF26353A)]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: "${unit.ownerProfilePictureUrl}fromUnitScreen",
                        child: ViewProfilePicture(
                          profilePictureURL: unit.ownerProfilePictureUrl,
                          profilePictureSize: 60,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(unit.ownerName, style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow[800], size: 16),
                              const SizedBox(width: 4),
                              Text(
                                unit.ownerRate.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (!isOwner)
                Positioned(
                  bottom: 20,
                  right: 40,
                  child: InkWell(
                    onTap: chatButtonOnTap,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          Text(
                            lang.chat,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1),
      ],
    );
  }
}
