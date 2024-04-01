import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/freelancer/chat_screen.dart';
import 'package:provider/provider.dart';

import '../../models/freelancer.dart';
import '../../providers/team_provider.dart';

class SeeAllResultsChat extends StatefulWidget {
  final List<FreelancerProfile> results;
  const SeeAllResultsChat({super.key, required this.results});

  @override
  State<SeeAllResultsChat> createState() => _SeeAllResultsChatState();
}

class _SeeAllResultsChatState extends State<SeeAllResultsChat> {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    receiverId: widget.results[index].id,
                                    username: widget.results[index].username)));
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
        ]),
      ),
    );
  }
}
