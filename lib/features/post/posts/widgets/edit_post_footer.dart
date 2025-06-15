import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/show_YN_dialog.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class EditPostFooter extends StatelessWidget {
  const EditPostFooter({
    super.key,
    required this.isRented,
    required this.postId,
    required this.unitId,
  });

  final int postId;
  final int unitId;
  final bool isRented;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final postCubit = PostCubit.of(context);

    void deletePost() async {
      final bool? res = await showDialog(
        context: context,
        builder: (context) => ShowYNDialog(
          title: lang.deletePostTitle,
          action: lang.deletePostAction,
          actionColor: Colors.red,
        ),
      );
      if (res != null && res == true) {
        postCubit.deletePost(postId: postId, unitId: unitId);
      }
    }

    void rentUnit() {
      postCubit.toggleRent(postId: postId, unitId: unitId, nextIsRented: true);
    }

    void unRentUnit() {
      postCubit.toggleRent(postId: postId, unitId: unitId, nextIsRented: false);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Button(
            idx: 0,
            title: lang.postDelete,
            backgroundColor: Colors.red,
            onTap: deletePost,
          ),
          isRented
              ? _Button(
                  idx: 1,
                  title: lang.postUnRent,
                  backgroundColor: Colors.grey,
                  onTap: unRentUnit,
                )
              : _Button(
                  idx: 1,
                  title: lang.postRent,
                  backgroundColor: Colors.green,
                  onTap: rentUnit,
                ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.idx,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  final int idx;
  final String title;
  final Color backgroundColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: idx == 0 ? const Radius.circular(32) : Radius.zero,
              bottomRight: idx == 1 ? const Radius.circular(32) : Radius.zero,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
