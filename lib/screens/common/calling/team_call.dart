import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../Providers/freelance_profile_provider.dart';
import '../../../providers/team_provider.dart';

class TeamCall extends StatefulWidget {
  final String callType;
  const TeamCall({super.key, required this.callType});

  @override
  State<TeamCall> createState() => _TeamCallState();
}

class _TeamCallState extends State<TeamCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1428909108, // your AppID,
      appSign:
          'c4b44e6b3090707d1ae39ee96a3ffc3792f1787755944add58fc745c1c9c4347',
      userID: Provider.of<FreelancerProfileProvider>(context, listen: false)
          .profile
          .id,
      userName: Provider.of<FreelancerProfileProvider>(context, listen: false)
          .profile
          .username,
      callID:
          '${Provider.of<TeamProvider>(context, listen: false).team!.id} - ${widget.callType}',
      config: widget.callType == 'video'
          ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          : ZegoUIKitPrebuiltCallConfig.groupVoiceCall(),
    );
  }
}
