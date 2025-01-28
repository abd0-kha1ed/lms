// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_icon_button.dart';
import 'package:video_player_app/core/widget/custom_show_diolog.dart';
import 'package:video_player_app/feature/assistant/presentation/view/widget/whats_phone.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';
import 'package:video_player_app/feature/students/add_new_student_view.dart';
import 'package:video_player_app/feature/students/presentation/views/edti_student.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  _StudentViewState createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedGrade = ""; // Variable to store the selected grade

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    // Safely use the saved reference
    // _scaffoldMessenger.showSnackBar(
    //   SnackBar(content: Text("Widget is being disposed")),
    // );
    super.dispose();
  }

  Stream<QuerySnapshot> _getStudentsStream() {
    final studentsCollection =
        FirebaseFirestore.instance.collection('students');
    Query query = studentsCollection;

    if (_searchQuery.isNotEmpty) {
      query = query
          .where('code', isGreaterThanOrEqualTo: _searchQuery)
          .where('code', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    if (_selectedGrade.isNotEmpty) {
      query = query.where('grade', isEqualTo: _selectedGrade);
    }

    return query.snapshots();
  }

  void _deleteStudent(String id) async {
    try {
      await FirebaseFirestore.instance.collection('students').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete student: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              // Show confirmation dialog
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content: Text(
                        "Are you sure you want to mark all students as not paid? This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Close dialog, return false
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Close dialog, return true
                        },
                        child: Text(
                          "Yes, Reset All",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );

              // If user confirmed the action
              if (shouldReset == true) {
                try {
                  final studentsCollection =
                      FirebaseFirestore.instance.collection('students');

                  // Fetch all student documents
                  final snapshot = await studentsCollection.get();

                  // Batch update `isPaid` to false for all students
                  final batch = FirebaseFirestore.instance.batch();
                  for (var doc in snapshot.docs) {
                    batch.update(doc.reference, {'ispaid': false});
                  }

                  // Commit the batch
                  await batch.commit();

                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Payment status reset for all students successfully.",
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  // Show error message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to reset payment status: $e"),
                      ),
                    );
                  }
                }
              }
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.blue,
              size: 28,
            ),
          ),
        ],
        backgroundColor: Colors.grey[100],
        title: Text("Students List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.name.tr(),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.allGrades.tr()),
                        selected: _selectedGrade.isEmpty,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "";
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.twelve.tr()),
                        selected: _selectedGrade == LocaleKeys.twelve.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.twelve.tr();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.eleven.tr()),
                        selected: _selectedGrade == LocaleKeys.eleven.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.eleven.tr();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.ten.tr()),
                        selected: _selectedGrade == LocaleKeys.ten.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.ten.tr();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.nine.tr()),
                        selected: _selectedGrade == LocaleKeys.nine.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.nine.tr();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.eight.tr()),
                        selected: _selectedGrade == LocaleKeys.eight.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.eight.tr();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.seven.tr()),
                        selected: _selectedGrade == LocaleKeys.seven.tr(),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = LocaleKeys.seven.tr();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getStudentsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No students found"));
                  }

                  final students = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final studentData =
                          students[index].data() as Map<String, dynamic>;
                      final student = StudentModel.fromJson(studentData);
                      final id = students[index].id;
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              student.code,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(student.name),
                          subtitle: Text(student.phone),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    // Get the current state of `isPaid` from Firestore
                                    final doc = FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(id);
                                    final snapshot = await doc.get();
                                    final currentState =
                                        snapshot['ispaid'] ?? false;

                                    // Toggle `isPaid` state
                                    await doc.update({'ispaid': !currentState});

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          currentState
                                              ? "Payment status marked as unpaid"
                                              : "Payment status marked as paid",
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Failed to update payment status: $e")),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: student.ispaid
                                      ? Colors.green
                                      : Colors.grey, // Toggle color
                                  size: 28,
                                ),
                              ),
                              WhatsPhone(phoneNumber: student.phone),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditStudent(
                                      studentModel: student,
                                    );
                                  }));
                                },
                              ),
                              CustomIconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomShowDialog(
                                        onPressed: () async {
                                          _deleteStudent(id);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 35,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddStudentScreen();
          })); // Navigate to Add Student page
        },
        label: Text(
          "Add New Student",
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
