import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/core/utils/app_router.dart';
import 'package:Ahmed_Hamed_lecture/feature/report/presentation/view/widget/circular_state.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int _approvedVideos = 0; // Approved videos count
  int _rejectedVideos = 0; // Rejected videos count
  int _pendingVideos = 0; // Pending videos count
  int _studentCount = 0; // Student count state
  int _videoCount = 0; // Video count state
  bool _isLoadingStudents = true; // Loading state for student count
  bool _isLoadingVideos = true; // Loading state for video count

  @override
  void initState() {
    super.initState();
    fetchStudentCount(); // Fetch student count
    fetchVideoCount(); // Fetch video count
    fetchVideoCounts();
  }

  Future<void> fetchVideoCounts() async {
    try {
      // Get all videos
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('videos').get();

      // Count videos based on `isApproved` field
      int approved = 0, rejected = 0, pending = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['isApproved'] == true) {
          approved++;
        } else if (data['isApproved'] == false) {
          rejected++;
        } else {
          pending++;
        }
      }

      setState(() {
        _approvedVideos = approved;
        _rejectedVideos = rejected;
        _pendingVideos = pending;
        _isLoadingVideos = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        _isLoadingVideos = false; // Stop loading in case of error
      });
    }
  }

  Future<void> fetchStudentCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('students').get();

      setState(() {
        _studentCount = snapshot.docs.length; // Update student count
        _isLoadingStudents = false; // Stop loading
      });
    } catch (e) {
      // print("Error fetching student count: $e");
      setState(() {
        _isLoadingStudents = false; // Stop loading in case of error
      });
    }
  }

  Future<void> fetchVideoCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('videos').get();

      setState(() {
        _videoCount = snapshot.docs.length; // Update video count
        _isLoadingVideos = false; // Stop loading
      });
    } catch (e) {
      // print("Error fetching video count: $e");
      setState(() {
        _isLoadingVideos = false; // Stop loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Gradient Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.reports.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Circular Stats Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularState(
                  count: _isLoadingStudents
                      ? 0
                      : _studentCount, // Dynamic student count
                  color: kPrimaryColor,
                  label: LocaleKeys.studentCount.tr(),
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kStudentView);
                  },
                ),
                CircularState(
                  count:
                      _isLoadingVideos ? 0 : _videoCount, // Dynamic video count
                  color: Colors.green,
                  label: LocaleKeys.videoCount.tr(),
                  onTap: () {
                    // GoRouter.of(context).push(AppRouter.kVideoView); // Navigate to video view
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Cards Section
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(16.0),
              children: [
                buildStatCard(
                  LocaleKeys.approvedVideos.tr(),
                  _isLoadingVideos ? 0 : _approvedVideos,
                  Colors.teal,
                  Icons.check,
                  () {
                    GoRouter.of(context).push(AppRouter.kApprovedVideo);
                  },
                ),
                buildStatCard(
                  LocaleKeys.rejectedVideos.tr(),
                  _isLoadingVideos ? 0 : _rejectedVideos,
                  Colors.red,
                  Icons.close,
                  () {
                    GoRouter.of(context).push(AppRouter.kRejectedVideo);
                  },
                ),
                buildStatCard(
                  LocaleKeys.pendingVideos.tr(),
                  _isLoadingVideos ? 0 : _pendingVideos,
                  Colors.orange,
                  Icons.pending,
                  () {
                    GoRouter.of(context).push(AppRouter.kPendingVideo);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(
      String label, int count, Color color, IconData icon, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[100],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
