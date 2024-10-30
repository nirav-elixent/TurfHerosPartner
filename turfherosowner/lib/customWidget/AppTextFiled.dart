// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class AppTextFiled extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?) validator;
  EdgeInsets contentPadding;
  FocusNode focusNode;
  bool selected;
  Function(String) onSubmitt;
  TextInputType keyboardType;
  String lebel;
  bool enable;
  int maxline;
  VoidCallback? onTap;
  List<TextInputFormatter>? inputFormatters;

  AppTextFiled({
    required this.focusNode,
    this.enable = true,
    required this.selected,
    required this.onSubmitt,
    this.keyboardType = TextInputType.name,
    this.lebel = "",
    this.maxline = 1,
    this.inputFormatters,
    this.onTap,
    required this.validator,
    required this.controller,
    EdgeInsets? contentPadding,
    super.key,
  }) : contentPadding = contentPadding ??
            EdgeInsets.only(
              left: 16.w,
              top: maxline == 1 ? 20.h : 24.h,
              right: 16.w,
            );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.zero,
            controller: controller,
            onFieldSubmitted: onSubmitt,
            enabled: enable,
            onTap: onTap,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: appColor,
              fontFamily: fontFamily,
            ),
            keyboardType: keyboardType,
            focusNode: focusNode,
            validator: validator,
            maxLines: maxline,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              filled: true,
              fillColor: textFiledColor,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              constraints: BoxConstraints(
                maxHeight: selected == true
                    ? maxline == 1
                        ? 45.h
                        : 55.h
                    : maxline == 1
                        ? 65.h
                        : 75.h,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        Positioned(
          left: 32.w,
          top: 2.h,
          child: Text(
            lebel,
            style: label_text_style,
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
class TabletAppTextFiled extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?) validator;
  EdgeInsets contentPadding;
  FocusNode focusNode;
  bool selected;
  Function(String) onSubmitt;
  TextInputType keyboardType;
  String lebel;
  bool enable;
  int maxline;
  VoidCallback? onTap;
  List<TextInputFormatter>? inputFormatters;

  TabletAppTextFiled({
    required this.focusNode,
    this.enable = true,
    required this.selected,
    required this.onSubmitt,
    this.keyboardType = TextInputType.name,
    this.lebel = "",
    this.maxline = 1,
    this.inputFormatters,
    this.onTap,
    required this.validator,
    required this.controller,
    EdgeInsets? contentPadding,
    super.key,
  }) : contentPadding = contentPadding ??
            EdgeInsets.only(
              left: 16.w,
              top: maxline == 1 ? 20.h : 24.h,
              right: 16.w,
              bottom: 16.w
            );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.zero,
            controller: controller,
            onFieldSubmitted: onSubmitt,
            enabled: enable,
            onTap: onTap,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: appColor,
              fontFamily: fontFamily,
            ),
            keyboardType: keyboardType,
            focusNode: focusNode,
            validator: validator,
            maxLines: maxline,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              filled: true,
              fillColor: textFiledColor,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              constraints: BoxConstraints(
                maxHeight: selected == true
                    ? maxline == 1
                        ? 45.h
                        : 55.h
                    : maxline == 1
                        ? 65.h
                        : 75.h,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        Positioned(
          left: 32.w,
          top: 2.h,
          child: Text(
            lebel,
            style: label_text_style,
          ),
        ),
      ],
    );
  }
}