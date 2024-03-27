import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/company_profile_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Section',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 52.r,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: primaryColor,
                    backgroundImage: const AssetImage(
                      'assets/defaultpic.jpg',
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<CompanyProfileProvider>(context,
                                listen: false)
                            .uploadProfilePicture(context);
                      },
                      child: Consumer<CompanyProfileProvider>(
                        builder: (_, provider, child) {
                          return provider.isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : provider.profile.pfp != ''
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        provider.profile.pfp,
                                      ),
                                      radius: 50.r,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: const AssetImage(
                                        'assets/defaultpic.jpg',
                                      ),
                                      radius: 50.r,
                                    );
                        },
                      ),
                    ),
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
                        companyProvider.profile.companyName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: Text(
                          companyProvider.profile.businessAddress,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            Divider(
              thickness: 0.75.w,
            ),
            SizedBox(
              height: 15.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Representative Name',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  companyProvider.profile.name,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Representative Email',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  companyProvider.profile.email,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
