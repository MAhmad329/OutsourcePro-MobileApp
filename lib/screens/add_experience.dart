import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/freelance_profile_provider.dart';
import '../constants.dart';
import '../models/freelancer.dart';
import '../models/experience_entry.dart';
import '../widgets/button.dart';
import '../widgets/custom_snackbar.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  DateTime? startDate;
  DateTime? endDate;
  bool currentlyWorking = false;
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyController = TextEditingController();

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
        firstDate: currentlyWorking
            ? startDate ?? DateTime(2000)
            : startDate ?? currentDate,
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              // Change the highlight color// Change the selection color
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

  List<String> getExperienceDetails() {
    String jobtitle = jobTitleController.text;
    String company = companyController.text;
    String startDateString =
        startDate != null ? "${startDate!.toLocal()}".split(' ')[0] : 'N/A';
    String endDateString = endDate != null
        ? "${endDate!.toLocal()}".split(' ')[0]
        : currentlyWorking
            ? 'Currently Working'
            : 'N/A';

    List<String> educationDetails = [
      'JobTitle: $jobtitle',
      'Company: $company',
      'Start Date: $startDateString',
      'End Date: $endDateString',
    ];

    return educationDetails;
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
          'Add Experience',
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
                          "Add Job Title",
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
                          controller: jobTitleController,
                          cursorColor: primaryColor,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Add Job Title here',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Add Company Name",
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
                          controller: companyController,
                          cursorColor: primaryColor,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Add Company Name here',
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
                          style: TextStyle(fontSize: 16.sp),
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
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(startDate!)
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
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: currentlyWorking
                              ? null
                              : () {
                                  if (startDate != null) {
                                    _selectDate(context, false);
                                  } else {
                                    customSnackBar(
                                      'Select Start Date First',
                                    );
                                  }
                                },
                          child: Container(
                            padding: EdgeInsets.all(
                              15.r,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: currentlyWorking
                                    ? Colors
                                        .grey // Change the color for disabled state
                                    : primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                              color: currentlyWorking
                                  ? Colors.grey.withOpacity(
                                      0.3) // Change the color for disabled state
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
                              scale: 1.r,
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: currentlyWorking,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      currentlyWorking = value ?? false;
                                      if (currentlyWorking) {
                                        endDate = null;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Text(
                              "Currently Working",
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
                          buttonText: 'Add Experience',
                          buttonColor: primaryColor,
                          buttonWidth: double.infinity,
                          buttonHeight: 45.h,
                          onTap: () {
                            if (jobTitleController.text.isEmpty ||
                                companyController.text.isEmpty ||
                                startDate == null ||
                                (!currentlyWorking && endDate == null)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar('Please fill in all the fields'),
                              );
                            } else {
                              // All fields are filled, proceed with confirmation
                              FreelancerProfileProvider provider =
                                  Provider.of<FreelancerProfileProvider>(
                                      context,
                                      listen: false);

                              getExperienceDetails();
                              ExperienceEntry newExp = ExperienceEntry(
                                jobtitle: jobTitleController.text,
                                company: companyController.text,
                                startDate: startDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(startDate!)
                                    : 'N/A',
                                endDate: endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                                    : currentlyWorking
                                        ? 'Currently Working'
                                        : 'N/A',
                              );

                              provider.addExperienceEntry(newExp);

                              // Do something with the experienceDetails list, such as print or save to a database
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
