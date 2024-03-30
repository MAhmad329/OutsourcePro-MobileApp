import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/team_provider.dart';
import 'package:outsourcepro/screens/freelancer/see_all_results.dart';
import 'package:provider/provider.dart';

import '../../Providers/freelance_profile_provider.dart';
import '../../constants.dart';
import '../../models/freelancer.dart';
import '../../providers/search_provider.dart';

class AddTeamMember extends StatefulWidget {
  const AddTeamMember({super.key});

  @override
  State<AddTeamMember> createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  Timer? _debounce;

  @override
  void initState() {
    Provider.of<FreelancerProfileProvider>(context, listen: false)
        .searchResults
        .clear();
    super.initState();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      if (value.isEmpty) {
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .clearSearchResults();
      } else {
        Provider.of<SearchProvider>(context, listen: false)
            .updateFreelancerSearchQuery(value,
                Provider.of<FreelancerProfileProvider>(context, listen: false));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !teamProvider.isLoading;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Add New Member',
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  TextField(
                    onChanged: (value) {
                      _onSearchChanged(value);
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0.h, horizontal: 16.0.w),
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: primaryColor.withOpacity(0.5), width: 2.0.w),
                        borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                      ),
                      hintStyle: kText3.copyWith(
                          fontSize: 15.sp,
                          color: const Color(0xffbdbdbd),
                          fontWeight: FontWeight.w400),
                      hintText: 'Search for freelancers...',
                      prefixIcon: Icon(
                        size: 20.r,
                        Icons.search_sharp,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: Consumer<FreelancerProfileProvider>(
                      builder: (_, provider, child) {
                        List<FreelancerProfile> freelancers =
                            provider.searchResults;
                        bool showSeeAllButton = freelancers.length > 5;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: showSeeAllButton ? 6 : freelancers.length,
                          itemBuilder: (context, index) {
                            if (index == 5) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SeeAllResults(
                                              results: freelancers)));
                                },
                                child: Text(
                                  'See All Results',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: primaryColor),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 7.5.h),
                              child: GestureDetector(
                                onTap: () async {
                                  final shouldAdd = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            textAlign: TextAlign.center,
                                            'Are you sure you want to add ${freelancers[index].username} to the team?',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 14.sp),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        fontSize: 14.sp),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                  if (shouldAdd ?? false) {
                                    teamProvider.addToTeam(
                                        freelancers[index].id, context, false);
                                    teamProvider.fetchTeam();
                                  }
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 25.r,
                                    backgroundImage:
                                        NetworkImage(freelancers[index].pfp),
                                  ),
                                  title: Text(
                                    freelancers[index].username,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            if (teamProvider
                .isLoading) // Display the modal progress indicator when loading
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
