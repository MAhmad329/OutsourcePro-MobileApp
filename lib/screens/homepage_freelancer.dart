import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/project.dart';

class HomepageFreelancer extends StatefulWidget {
  const HomepageFreelancer({Key? key}) : super(key: key);

  @override
  State<HomepageFreelancer> createState() => _HomepageFreelancerState();
}

class _HomepageFreelancerState extends State<HomepageFreelancer> {
  String ipaddress = '';

  List<Project> projects = []; // List to hold project data

  Future<void> _fetchProjects() async {
    try {
      ipaddress =
          Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
      var request = http.Request('GET',
          Uri.parse('http://$ipaddress:3000/api/v1/project/getProjects'));
      request.body = '''''';

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the JSON response and update the projects list
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());

        if (responseData['success'] == true) {
          List<dynamic> projectsData = responseData['projects'];
          projects =
              projectsData.map((data) => Project.fromJson(data)).toList();
        } else {
          print('API request was not successful');
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching projects: $error');
    }
  }

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Projects',
            style: TextStyle(fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            size: 30.0.r,
            color: primaryColor,
          ),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'profile_screen');
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profilepic.png'),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                _logout();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.r),
                child: const Text('Logout'),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Column(
            children: [
              Container(
                // Add padding around the search bar
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                // Use a Material design search bar
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: kTextFieldDecoration.copyWith(
                    hintStyle: kText3.copyWith(
                        fontSize: 15.sp,
                        color: const Color(0xffbdbdbd),
                        fontWeight: FontWeight.w400),
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search_sharp,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchProjects,
                  child: FutureBuilder(
                    future: _fetchProjects(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        ); // Loading indicator while fetching data
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              color: const Color(0XFFECE7F6),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      projects[index].title,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      projects[index].description,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text('Type: ${projects[index].type}'),
                                    Text(
                                        'Tech Stack: ${projects[index].technologyStack}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
