// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class SelectPitch extends StatelessWidget {
  final int variable;
  String name;
  final int index;
  final VoidCallback onTap;

  SelectPitch(
      {super.key,
      required this.name,
      required this.onTap,
      required this.index,
      required this.variable,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: variable == index ? appColor : whiteColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: variable == index
                  ? selectdetailcri_text_style
                  : unDetailcri_text_style,
            ),
          ],
        ),
      ),
    );
  }
}

