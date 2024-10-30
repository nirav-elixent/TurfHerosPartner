// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class CustomRadioButton extends StatelessWidget {
  String title;
  var selected;
  VoidCallback onChanged;
  CustomRadioButton(
      {required this.title,
      required this.onChanged,
      required this.selected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.h,
      child: GestureDetector(
        onTap: onChanged,
        child: Row(
          children: [
            Container(
              height: 16.h,
              width: 16.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: selected ? appColor : whiteColor,
                  border: Border.all(
                      color: selected ? appColor : greyColor, width: 1.7.w)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: whiteColor,
                  size: 11.h,
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              title,
              style: TextStyle(
                  fontFamily: fontFamily,
                  color: selected ? appColor : greyColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class TabletCustomRadioButton extends StatelessWidget {
  String title;
  var selected;
  VoidCallback onChanged;
  TabletCustomRadioButton(
      {required this.title,
      required this.onChanged,
      required this.selected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: GestureDetector(
        onTap: onChanged,
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 16.h,
              width: 12.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: selected ? appColor : whiteColor,
                  border: Border.all(
                      color: selected ? appColor : greyColor, width: 1.7.w)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: whiteColor,
                  size: 11.h,
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              title,
              style: TextStyle(
                  fontFamily: fontFamily,
                  color: selected ? appColor : greyColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
