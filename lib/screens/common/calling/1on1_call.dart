import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class OneOnOneCall extends StatefulWidget {
  final String receiverId;
  final String userName;
  const OneOnOneCall(
      {super.key, required this.receiverId, required this.userName});

  @override
  State<OneOnOneCall> createState() => _OneOnOneCallState();
}

class _OneOnOneCallState extends State<OneOnOneCall> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ZegoSendCallInvitationButton(
            isVideoCall: false,
            invitees: [
              ZegoUIKitUser(
                id: widget.receiverId,
                name: widget.userName,
              ),
            ],
            text: 'Voice Call',
            textStyle: TextStyle(color: Colors.black, fontSize: 15),
          ),
          ZegoSendCallInvitationButton(
            isVideoCall: true,
            invitees: [
              ZegoUIKitUser(
                id: widget.receiverId,
                name: widget.userName,
              ),
            ],
            text: 'Video Call',
            textStyle: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
