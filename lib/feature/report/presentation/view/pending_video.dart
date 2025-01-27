import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PendingVideo extends StatefulWidget {
  const PendingVideo({super.key});

  @override
  State<PendingVideo> createState() => _PendingVideosPageState();
}

class _PendingVideosPageState extends State<PendingVideo> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserRole(); // Fetch the user's role (teacher or assistant)
  }

  /// Fetch the user's role by checking the `teachers` and `assistants` collections
  Future<void> fetchUserRole() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // Check the `teachers` collection
      final teacherSnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userId)
          .get();

      if (teacherSnapshot.exists) {
        setState(() {
          userRole = 'teacher';
        });
        return;
      }

      // Check the `assistants` collection
      final assistantSnapshot = await FirebaseFirestore.instance
          .collection('assistants')
          .doc(userId)
          .get();

      if (assistantSnapshot.exists) {
        setState(() {
          userRole = 'assistant';
        });
        return;
      }

      // If the user is not found in either collection
      setState(() {
        userRole = 'unknown';
      });
    } catch (e) {
      print("Error fetching user role: $e");
      setState(() {
        userRole = null;
      });
    }
  }

  /// Approve a video by setting `isApproved` to true and `isVideoVisible` to true
  void approveVideo(String videoId) async {
    try {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoId)
          .update({
        "isApproved": true,
        "isVideoVisible": true,
      });

      print("Video approved successfully.");
    } catch (e) {
      print("Error approving video: $e");
    }
  }

  /// Reject a video by deleting it from the `videos` collection
  Future<void> rejectVideo(String videoId) async {
    try {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Video rejected!")));
    } catch (e) {
      print("Error rejecting video: $e");
    }
  }

  /// Format the date as relative time (e.g., "4 hours ago")
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 1) {
      return DateFormat('d MMM').format(date);
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${difference.inMinutes} mins ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Videos List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('isApproved', isEqualTo: false) // Fetch unapproved videos
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending videos."));
          }

          final pendingVideos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pendingVideos.length,
            itemBuilder: (context, index) {
              final video = pendingVideos[index];
              final videoId = video.id;
              final title = video['title'];
              final uploaderName = video['uploaderName'];
              final createdAt = (video['createdAt'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade300,
                            child:
                                const Icon(Icons.play_circle_outline, size: 40),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Video uploaded by $uploaderName"),
                                Text(
                                  _formatDate(createdAt),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (userRole ==
                          'teacher') // Show buttons only for teachers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => approveVideo(videoId),
                              icon:
                                  const Icon(Icons.check, color: Colors.white),
                              label: const Text("Accept"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => rejectVideo(videoId),
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              label: const Text("Reject"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
