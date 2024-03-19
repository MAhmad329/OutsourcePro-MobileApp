import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/project_details_screen.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../providers/search_provider.dart';

class HomepageFreelancer extends StatefulWidget {
  const HomepageFreelancer({Key? key}) : super(key: key);

  @override
  State<HomepageFreelancer> createState() => _HomepageFreelancerState();
}

class _HomepageFreelancerState extends State<HomepageFreelancer> {
  String ipaddress = '';
  Future<void> _logout() async {
    ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    var request = http.Request(
        'GET', Uri.parse('http://$ipaddress:3000/api/v1/Freelancer/logout'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 20.h,
          elevation: 0,
          automaticallyImplyLeading: false,
          // actions: [
          //   InkWell(
          //     onTap: () {
          //       _logout();
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20.0.r),
          //       child: const Text('Logout'),
          //     ),
          //   )
          // ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'profile_screen');
                    },
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: primaryColor.withOpacity(0.75),
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundImage: AssetImage('assets/profilepic.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(fontSize: 25.sp),
                      ),
                      Text(
                        '${Provider.of<FreelancerProfileProvider>(context).profile.firstname}.',
                        style: TextStyle(fontSize: 25.sp),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Find Projects here.',
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                onChanged: (value) {
                  Provider.of<SearchProvider>(context, listen: false)
                      .updateSearchQuery(value);
                },
                style: TextStyle(fontSize: 14.sp),
                cursorColor: Colors.black,
                decoration: kTextFieldDecoration.copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.5), width: 2.0.w),
                    borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                  ),
                  hintStyle: kText3.copyWith(
                      fontSize: 15.sp,
                      color: const Color(0xffbdbdbd),
                      fontWeight: FontWeight.w400),
                  hintText: 'Search',
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
              MyButton(
                  onTap: () {},
                  borderColor: primaryColor,
                  textColor: Colors.black,
                  buttonText: 'Apply Filter',
                  buttonColor: Colors.white,
                  buttonWidth: double.infinity,
                  buttonHeight: 40.h),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () {
                    return Provider.of<ProjectProvider>(context, listen: false)
                        .fetchProjects();
                  },
                  child: Consumer<SearchProvider>(
                      builder: (context, searchProvider, child) {
                    return Consumer<ProjectProvider>(
                      builder: (context, projectProvider, child) {
                        List<Project> projects =
                            searchProvider.searchQuery.isEmpty
                                ? projectProvider.projects
                                : projectProvider
                                    .searchProjects(searchProvider.searchQuery);
                        if (projects.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: 12.0.h,
                                  horizontal: 4.0.w,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.5), // Set the shadow color with some transparency
                                        spreadRadius:
                                            1, // Spread radius to extend the shadow
                                        blurRadius:
                                            10, // Blur radius to soften the shadow
                                        offset: const Offset(
                                            0, 3), // Position of the shadow
                                      ),
                                    ],
                                  ),
                                  //color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.r),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maxLines: 3,
                                          overflow:TextOverflow.ellipsis,
                                          projects[index].title,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          projects[index].timeElapsed(),
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          projects[index].description,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        SizedBox(height: 15.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Budget: ',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              projects[index].budget.toString(),
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        MyButton(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectDetailsScreen(
                                                  project: projects[index],
                                                ),
                                              ),
                                            );
                                          },
                                          buttonText: 'View Details',
                                          buttonColor: Colors.white,
                                          buttonWidth: double.infinity.w,
                                          buttonHeight: 40.h,
                                          textColor: Colors.black,
                                          borderColor: primaryColor,
                                          //borderRadius: .r,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
