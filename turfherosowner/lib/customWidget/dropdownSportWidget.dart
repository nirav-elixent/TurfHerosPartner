// ignore_for_file: must_be_immutable, file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';

class SportListFormField extends StatelessWidget {
  List<String> selectedValues = <String>[].obs; // List of selected sport IDs
  List<String> extraSelectedValues =
      <String>[].obs; // List of extra selected sport IDs
  final Function(List<String> values, List<String> extraValues)
      onChanged; // Modified callback
  final List<SportList> sportList;

  SportListFormField({
    required this.sportList,
    required this.selectedValues,
    required this.extraSelectedValues,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) {
            return MultiSelectDialog(
              sportList: sportList,
              selectedValues: selectedValues,
              extraSelectedValues:
                  extraSelectedValues, // Pass extra selected values
            );
          },
        );
        if (result != null) {
          // Call onChanged with both lists
          onChanged(result['selected'], result['extraSelected']);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: textFiledColor,
          constraints: BoxConstraints(maxHeight: 45.h),
          disabledBorder: OutlineInputBorder(
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
        ),
        isEmpty: selectedValues.isEmpty && extraSelectedValues.isEmpty,
        child: Obx(
          () => Text(
            (selectedValues.isEmpty && extraSelectedValues.isEmpty)
                ? 'No sports selected'
                : selectedValues.join(', '),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: appColor,
              letterSpacing: 0,
              wordSpacing: 0,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<SportList> sportList;
  final List<String> selectedValues; // List of selected sport IDs
  final List<String> extraSelectedValues; // List of extra selected sport IDs

  const MultiSelectDialog({super.key, 
    required this.sportList,
    required this.selectedValues,
    required this.extraSelectedValues,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selectedItems;
  late List<String> extraSelectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.selectedValues);
    extraSelectedItems = List.from(widget.extraSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Sports'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.sportList.map((sport) {
            return CheckboxListTile(
              title: Text(sport.name ?? ''),
              value: selectedItems.contains(sport.name),
              onChanged: (bool? isChecked) {
                setState(() {
                  if (isChecked == true) {
                    selectedItems.add(sport.name!);
                    extraSelectedItems.add(sport.sId!);
                  } else {
                    selectedItems.remove(sport.name);
                    extraSelectedItems.remove(sport.sId);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Prepare the result to return
            Navigator.of(context).pop({
              'selected': selectedItems,
              'extraSelected': extraSelectedItems,
            });
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
