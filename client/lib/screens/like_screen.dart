import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/like_model.dart';
import 'package:found_adoption_application/repository/like_post_api.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';

class LikeScreen extends StatefulWidget {
  final postId;
  LikeScreen({super.key, required this.postId});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Future<List<Like>>? likeFuture;

  @override
  void initState() {
    super.initState();
    likeFuture = getLike(context, widget.postId);
  }

  // //comment
  // Widget likeChild(List<Like> likes) {
  //   return FutureBuilder(
  //       future: likeFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else if (snapshot.hasError) {
  //           return Center(
  //             child: Text('Error: ${snapshot.error}'),
  //           );
  //         } else if (snapshot.hasData) {
  //           likes = snapshot.data as List<Like>;

  //           return ListView.builder(
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.fromLTRB(0.0, 4.0, 2.0, 0.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       ListTile(
  //                         contentPadding: EdgeInsets.zero,
  //                         leading: GestureDetector(
  //                           onTap: () async {
  //                           },
  //                           child: Container(
  //                             height: 50.0,
  //                             width: 50.0,
  //                             decoration: BoxDecoration(
  //                               color: Colors.blue,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(50)),
  //                             ),
  //                             child: CircleAvatar(
  //                               radius: 50,
  //                               backgroundImage: CommentBox.commentImageParser(

  //                                 // imageURLorPath: 'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg',
  //                                 imageURLorPath: likes[index].userId != null
  //                                     ? '${likes[index].userId!.avatar}'
  //                                     : '${likes[index].centerId!.avatar}',
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         title: Container(
  //                           padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 // data[i]['name'],
  //                                 likes[index].userId != null
  //                                     ? '${likes[index].userId!.firstName} ${likes[index].userId!.lastName}'
  //                                     : '${likes[index].centerId!.name}',
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12),
  //                               color: Colors.grey.shade200),
  //                         ),
  //                         trailing: IconButton(
  //                             onPressed: () {},
  //                             icon: const Icon(
  //                               Icons.favorite,
  //                               color: Colors.red,
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               });
  //         } else {
  //           return SizedBox.shrink();
  //         }
  //       });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Back'),
          leading: IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
            future: likeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                List<Like> likes = snapshot.data as List<Like>;

                return ListView.builder(
                    itemCount: likes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 2.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        CommentBox.commentImageParser(
                                      // imageURLorPath: 'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg',
                                      imageURLorPath: likes[index].userId !=
                                              null
                                          ? '${likes[index].userId!.avatar}'
                                          : '${likes[index].centerId!.avatar}',
                                    ),
                                  ),
                                ),
                              ),
                              title: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // data[i]['name'],
                                      likes[index].userId != null
                                          ? '${likes[index].userId!.firstName} ${likes[index].userId!.lastName}'
                                          : '${likes[index].centerId!.name}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200),
                              ),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return SizedBox.shrink();
              }
            }));
  }
}