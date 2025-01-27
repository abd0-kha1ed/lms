import 'package:flutter/material.dart';

<<<<<<< HEAD
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

=======
class PendingVideo extends StatelessWidget {
  const PendingVideo({Key? key}) : super(key: key);
>>>>>>> 5c5af200ab4778e3d1aef89a2b51071e5f11b53a
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
