// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class SelectTime extends StatelessWidget {
  final String? Time;
  VoidCallback onTap;
  var selected;
  SelectTime({
    required this.selected,
    required this.Time,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                  color: greyColor.withAlpha(60),
                  offset: Offset.fromDirection(
                    1,
                  ),
                  blurRadius: 0.4,
                  spreadRadius: 1)
            ],
            color: selected ? appColor : whiteColor),
        child: Center(
          child: Text(
            Time!,
            textAlign: TextAlign.center,
            style:
                selected ? selectedTime_text_style : unselectedTime_text_style,
          ),
        ),
      ),
    );
  }
}


class TabletSelectTime extends StatelessWidget {
  final String? Time;
  VoidCallback onTap;
  var selected;
  TabletSelectTime({
    required this.selected,
    required this.Time,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                  color: greyColor.withAlpha(60),
                  offset: Offset.fromDirection(
                    1,
                  ),
                  blurRadius: 0.4,
                  spreadRadius: 1)
            ],
            color: selected ? appColor : whiteColor),
        child: Center(
          child: Text(
            Time!,
            textAlign: TextAlign.center,
            style:
                selected ? TabletAppstyle.selectedTime_text_style : TabletAppstyle.unselectedTime_text_style,
          ),
        ),
      ),
    );
  }
}
