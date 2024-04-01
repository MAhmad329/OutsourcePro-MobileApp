import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/freelancer.dart';
import '../../providers/team_provider.dart';

class SeeAllResults extends StatefulWidget {
  final List<FreelancerProfile> results;
  const SeeAllResults({super.key, required this.results});

  @override
  State<SeeAllResults> createState() => _SeeAllResultsState();
}

class _SeeAllResultsState extends State<SeeAllResults> {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !teamProvider.isLoading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Results',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.0.h),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.results.length,
                itemBuilder: (context, index) {
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
                                  'Are you sure you want to add ${widget.results[index].username} to the team?',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                        if (shouldAdd ?? false) {
                          teamProvider.addToTeam(
                              widget.results[index].id, context, true);
                          teamProvider.fetchTeam();
                        }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          radius: 25.r,
                          backgroundImage:
                              NetworkImage(widget.results[index].pfp),
                        ),
                        title: Text(
                          widget.results[index].username,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (teamProvider
              .isLoading) // Display the modal progress indicator when loading
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }
}
