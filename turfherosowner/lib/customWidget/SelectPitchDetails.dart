// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class SelectPitchDetails extends StatelessWidget {
  String name;
  final VoidCallback onTap;
  SelectPitchDetails({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r), color: appColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: selectdetailcri_text_style),
          ],
        ),
      ),
    );
  }
}
