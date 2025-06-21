import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TypeVideoFilter extends StatelessWidget {
  const TypeVideoFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Row(
          children: [
            ChoiceChip(
              label: Text(
                LocaleKeys.both.tr(),
                style: TextStyle(
                  color: context.watch<VideoCubit>().hasCode == null
                      ? Colors.white // White when selected
                      : Colors.black87, // Black when not selected
                ),
              ),
              selected: context.watch<VideoCubit>().hasCode == null,
              onSelected: (selected) {
                if (selected) {
                  context
                      .read<VideoCubit>()
                      .setFilteredEncrypted(null); // Show all videos
                }
              },
              selectedColor: Colors.teal,
              backgroundColor: Colors.transparent,
              checkmarkColor: Colors.white,
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text(
                LocaleKeys.open.tr(),
                style: TextStyle(
                  color: context.watch<VideoCubit>().hasCode == false
                      ? Colors.white // White when selected
                      : Colors.black87, // Black when not selected
                ),
              ),
              selected: context.watch<VideoCubit>().hasCode == false,
              onSelected: (selected) {
                if (selected) {
                  context
                      .read<VideoCubit>()
                      .setFilteredEncrypted(false); // Show open videos
                }
              },
              selectedColor: Colors.teal, // Background color when selected
              backgroundColor:
                  Colors.transparent, // Background color when not selected
              checkmarkColor: Colors.white,
            ),
            SizedBox(width: 8),
            ChoiceChip(
              label: Text(
                LocaleKeys.encrypted.tr(),
                style: TextStyle(
                  color: context.watch<VideoCubit>().hasCode == true
                      ? Colors.white // White when selected
                      : Colors.black87, // Black when not selected
                ),
              ),
              selected: context.watch<VideoCubit>().hasCode == true,
              onSelected: (selected) {
                if (selected) {
                  context
                      .read<VideoCubit>()
                      .setFilteredEncrypted(true); // Show encrypted videos
                }
              },
              selectedColor: Colors.teal, // Background color when selected
              backgroundColor:
                  Colors.transparent, // Background color when not selected
              checkmarkColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
