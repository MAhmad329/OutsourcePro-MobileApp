import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:outsourcepro/models/task.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../company/company_profile_screen.dart';

class OngoingProjectScreen extends StatefulWidget {
  final Project project;
  const OngoingProjectScreen({super.key, required this.project});

  @override
  State<OngoingProjectScreen> createState() => _OngoingProjectScreenState();
}

class _OngoingProjectScreenState extends State<OngoingProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                widget.project.title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.project.description,
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 25.h),
              Text(
                'Due',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(DateFormat('dd-MM-yyyy').format(widget.project.deadline)),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "Progress",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              FutureBuilder(
                future: Provider.of<ProjectProvider>(context, listen: false)
                    .getProjectTasks(widget.project.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Task> tasks =
                        Provider.of<ProjectProvider>(context).tasks;
                    double progress = calculateProgress(tasks);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 8.h,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Tasks",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        tasks.isEmpty
                            ? Text('No tasks assigned yet')
                            : Column(
                                children: tasks
                                    .map((task) => TaskCard(task: task))
                                    .toList(),
                              ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              Divider(
                thickness: 0.75.w,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundImage: NetworkImage(
                          widget.project.owner.pfp,
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.project.owner.companyName,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                            Text(
                              widget.project.owner.businessAddress,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyProfile(
                                otherProfile: widget.project.owner,
                              ),
                            ),
                          );
                        },
                        child: const Text('View Company Profile'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    int completedTasks =
        tasks.where((task) => task.status == 'completed').length;
    return completedTasks / tasks.length;
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description!,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            task.assignee != null && task.assignee!.isNotEmpty
                ? Column(
                    children: task.assignee!.map((assignee) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(assignee.pfp),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(child: Text(assignee.username)),
                            ],
                          ),
                          SizedBox(height: 8.h), // Add gap between assignees
                        ],
                      );
                    }).toList(),
                  )
                : Text('Unassigned'),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag_outlined),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(DateFormat('dd-MM-yyyy').format(task.deadline!)),
                  ],
                ),
                Row(
                  children: [
                    Icon(_getStatusIcon(task.status!),
                        color: _getStatusIconColor(task.status!)),
                    SizedBox(width: 8.w),
                    Text(task.status!),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'submitted':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.check_circle;
      case 'overdue':
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusIconColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'submitted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
