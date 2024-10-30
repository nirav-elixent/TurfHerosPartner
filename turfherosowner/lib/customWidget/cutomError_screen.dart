// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset("assets/images/error_image.svg"),
        SizedBox(
          height: 8.h,
        ),
        Text(
          "Ups!... no results found",
          style: error_text_style,
        )
      ],
    );
  }
}
