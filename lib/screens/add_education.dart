import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../Providers/freelance_profile_provider.dart';
import '../models/education_entry.dart';
import '../widgets/button.dart';

class AddEducation extends StatefulWidget {
  final EducationEntry? educationEntry;

  const AddEducation({super.key, this.educationEntry});

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  DateTime? startDate;
  DateTime? endDate;
  bool currentlyEnrolled = false;
  TextEditingController institutionController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked;

    if (isStartDate) {
      picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primaryColor, // Change the highlight color
              // Change the selection color
              colorScheme: ColorScheme.light(primary: primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? currentDate,
        firstDate: currentlyEnrolled
            ? startDate ?? DateTime(2000)
            : startDate ?? currentDate,
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor:
                  primaryColor, // Change the highlight color// Change the selection color
              colorScheme: ColorScheme.light(primary: primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );
    }

    if (picked != null && (isStartDate || picked.isAfter(startDate!))) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.educationEntry != null) {
      institutionController.text = widget.educationEntry!.institution;
      courseController.text = widget.educationEntry!.course;
      startDate =
          DateFormat('yyyy-MM-dd').parse(widget.educationEntry!.startDate);
      endDate = widget.educationEntry!.endDate != 'Currently Enrolled'
          ? DateFormat('yyyy-MM-dd').parse(widget.educationEntry!.endDate)
          : null;
      currentlyEnrolled =
          widget.educationEntry!.endDate == 'Currently Enrolled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24.r,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Education',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Institution",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          controller: institutionController,
                          cursorColor: primaryColor,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Add Institution here',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Add Course",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          controller: courseController,
                          cursorColor: primaryColor,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Add course here',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Start Date",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(
                              context,
                              true,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              15.r,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startDate != null
                                      ? DateFormat('dd-MM-yyyy').format(
                                          startDate!,
                                        )
                                      : 'Select Date',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: primaryColor,
                                  size: 20.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "End Date",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: currentlyEnrolled
                              ? null
                              : () {
                                  if (startDate != null) {
                                    _selectDate(
                                      context,
                                      false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(
                                          'Please Select Start Date First',
                                          Colors.red),
                                    );
                                  }
                                },
                          child: Container(
                            padding: EdgeInsets.all(
                              15.r,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: currentlyEnrolled
                                    ? Colors
                                        .grey // Change the color for disabled state
                                    : primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                              color: currentlyEnrolled
                                  ? Colors.grey.withOpacity(
                                      0.3,
                                    ) // Change the color for disabled state
                                  : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  endDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(endDate!)
                                      : 'Select Date',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: primaryColor,
                                  size: 20.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              alignment: Alignment.center,
                              scale: 1.r,
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: currentlyEnrolled,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      currentlyEnrolled = value ?? false;
                                      if (currentlyEnrolled) {
                                        endDate =
                                            null; // Reset end date when currently enrolled is selected
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Text(
                              "Currently Enrolled",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        MyButton(
                          buttonText: 'Add Education',
                          buttonColor: primaryColor,
                          buttonWidth: double.infinity,
                          buttonHeight: 45.h,
                          onTap: () {
                            if (institutionController.text.isEmpty ||
                                courseController.text.isEmpty ||
                                startDate == null ||
                                (!currentlyEnrolled && endDate == null)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar('Please fill in all the fields',
                                    Colors.red),
                              );
                            } else {
                              FreelancerProfileProvider provider =
                                  Provider.of<FreelancerProfileProvider>(
                                      context,
                                      listen: false);

                              EducationEntry newEducation = EducationEntry(
                                institution: institutionController.text,
                                course: courseController.text,
                                startDate: startDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(startDate!)
                                    : 'N/A',
                                endDate: endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                                    : currentlyEnrolled
                                        ? 'Currently Enrolled'
                                        : 'N/A',
                              );

                              if (widget.educationEntry != null) {
                                // Update the existing entry
                                int index = provider.profile.educationEntries
                                    .indexOf(widget.educationEntry!);
                                provider.updateEducationEntry(
                                    index, newEducation);
                              } else {
                                // Add a new entry
                                provider.addEducationEntry(newEducation);
                              }

                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
