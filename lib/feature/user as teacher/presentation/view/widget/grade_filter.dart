import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class GradeFilter extends StatelessWidget {
  const GradeFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            // All Grades
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.allGrades.tr(),
                  style: TextStyle(
                    color: context.watch<VideoCubit>().selectedGrade.isEmpty
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                selected: context.watch<VideoCubit>().selectedGrade.isEmpty,
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 3rd Secondary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.twelve.tr(),
                  style: TextStyle(
                    color: context.watch<VideoCubit>().selectedGrade ==
                            "3rd Secondary"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                selected: context.watch<VideoCubit>().selectedGrade ==
                    "3rd Secondary",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("3rd Secondary");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 2nd Secondary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.eleven.tr(),
                  style: TextStyle(
                    color: context.watch<VideoCubit>().selectedGrade ==
                            "2nd Secondary"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                selected: context.watch<VideoCubit>().selectedGrade ==
                    "2nd Secondary",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("2nd Secondary");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 1st Secondary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.ten.tr(),
                  style: TextStyle(
                    color: context.watch<VideoCubit>().selectedGrade ==
                            "1st Secondary"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                selected: context.watch<VideoCubit>().selectedGrade ==
                    "1st Secondary",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("1st Secondary");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 3rd Prep
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.nine.tr(),
                  style: TextStyle(
                    color:
                        context.watch<VideoCubit>().selectedGrade == "3rd Prep"
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                selected:
                    context.watch<VideoCubit>().selectedGrade == "3rd Prep",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("3rd Prep");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 2nd Prep
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.eight.tr(),
                  style: TextStyle(
                    color:
                        context.watch<VideoCubit>().selectedGrade == "2nd Prep"
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                selected:
                    context.watch<VideoCubit>().selectedGrade == "2nd Prep",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("2nd Prep");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
            // 1st Prep
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilterChip(
                label: Text(
                  LocaleKeys.seven.tr(),
                  style: TextStyle(
                    color:
                        context.watch<VideoCubit>().selectedGrade == "1st Prep"
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                selected:
                    context.watch<VideoCubit>().selectedGrade == "1st Prep",
                onSelected: (selected) {
                  context.read<VideoCubit>().setGrade("1st Prep");
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.transparent,
                checkmarkColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
