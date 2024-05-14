// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:outsourcepro/models/post.dart'; // Include your Post model
//
// class CommunityProfileScreen extends StatelessWidget {
//   final Author author;
//   final List<Post> userPosts; // Assuming you pass the posts separately
//
//   CommunityProfileScreen(
//       {Key? key, required this.author, required this.userPosts})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(author.name),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             CircleAvatar(
//               backgroundImage: NetworkImage(
//                   author.profilePicture ?? 'https://via.placeholder.com/150'),
//               radius: 50, // Adjust size as needed
//             ),
//             SizedBox(height: 10),
//             Text(author.name,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             Text('${userPosts.length} posts',
//                 style: TextStyle(fontSize: 18, color: Colors.grey)),
//             SizedBox(height: 20),
//             buildPostsGrid(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildPostsGrid() {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h,
//         childAspectRatio: 1.5,
//       ),
//       shrinkWrap: true,
//       physics:
//           NeverScrollableScrollPhysics(), // to disable GridView's scrolling
//
//       itemCount: userPosts.length,
//       itemBuilder: (BuildContext context, int index) =>
//           buildPostItem(userPosts[index]),
//     );
//   }
//
//   Widget buildPostItem(Post post) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: <Widget>[
//           Image.network(
//             post.media.isNotEmpty
//                 ? post.media.first
//                 : 'https://via.placeholder.com/400x200',
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               post.content,
//               style: TextStyle(fontWeight: FontWeight.bold),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
