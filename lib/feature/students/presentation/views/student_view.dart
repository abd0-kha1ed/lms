// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/core/widget/custom_icon_button.dart';
import 'package:Ahmed_Hamed_lecture/core/widget/custom_show_diolog.dart';
import 'package:Ahmed_Hamed_lecture/feature/assistant/presentation/view/widget/whats_phone.dart';
import 'package:Ahmed_Hamed_lecture/feature/auth/data/model/student_model.dart';
import 'package:Ahmed_Hamed_lecture/feature/students/presentation/views/add_new_student_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/students/presentation/views/edti_student.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


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

  // Variable to store the selected grade

  // Method to get students filtered by code
  Stream<QuerySnapshot> _getStudentsByCode() {
    final studentsCollection =
        FirebaseFirestore.instance.collection('students');
    return studentsCollection
        .where('code', isGreaterThanOrEqualTo: _searchQuery)
        .where('code', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
        .snapshots();
  }

  // Method to get students filtered by name
  Stream<QuerySnapshot> _getStudentsByName() {
    final studentsCollection =
        FirebaseFirestore.instance.collection('students');
    return studentsCollection
        .where('name', isGreaterThanOrEqualTo: _searchQuery)
        .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
        .snapshots();
  }

  // Get the appropriate stream based on search query
  Stream<QuerySnapshot> _getStudentsStream() {
    final studentsCollection =
        FirebaseFirestore.instance.collection('students');
    if (_searchQuery.isNotEmpty) {
      if (_searchQuery.contains(RegExp(r'^[0-9]*$'))) {
        // If the query looks like a code (numeric), search by code
        return _getStudentsByCode();
      } else {
        // Otherwise, search by name
        return _getStudentsByName();
      }
    } else {
      // If no search query, return all students (apply grade filter if selected)
      Query query = studentsCollection;
      if (_selectedGrade.isNotEmpty) {
        query = query.where('grade', isEqualTo: _selectedGrade);
      }
      return query.snapshots();
    }
  }

  void _deleteStudent(String id) async {
    try {
      await FirebaseFirestore.instance.collection('students').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.studentDeleted.tr())),
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              // Show confirmation dialog
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(LocaleKeys.confirmText.tr()),
                    content: Text(LocaleKeys
                        .areyousureyouwanttomarkallstudentsasnotpaid
                        .tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Close dialog, return false
                        },
                        child: Text(
                          LocaleKeys.no.tr(),
                          style: TextStyle(color: Colors.grey, fontSize: 24),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Close dialog, return true
                        },
                        child: Text(
                          LocaleKeys.yes.tr(),
                          style: TextStyle(color: Colors.red, fontSize: 24),
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
                          "تم جعل كل الطلاب لم يقومو بدفع الرسوم",
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
        title: Text(LocaleKeys.studentsList.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
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
                        selected:
                            _selectedGrade == "3rd Secondary", // Stored value
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade =
                                "3rd Secondary"; // Store English value
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.eleven.tr()),
                        selected: _selectedGrade == "2nd Secondary",
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "2nd Secondary";
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.ten.tr()),
                        selected: _selectedGrade == "1st Secondary",
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "1st Secondary";
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.nine.tr()),
                        selected: _selectedGrade == "3rd Prep",
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "3rd Prep";
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.eight.tr()),
                        selected: _selectedGrade == "2nd Prep",
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "2nd Prep";
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.seven.tr()),
                        selected: _selectedGrade == "1st Prep",
                        onSelected: (selected) {
                          setState(() {
                            _selectedGrade = "1st Prep";
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
                    return Center(
                        child: CircularProgressIndicator(color: kPrimaryColor));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text(LocaleKeys.noStudentsFound.tr()));
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
                        child: Column(
                          children: [
                            ListTile(
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
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                WhatsPhone(phoneNumber: student.phone),
                                const Spacer(),
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
                                      await doc
                                          .update({'ispaid': !currentState});

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            currentState
                                                ? LocaleKeys
                                                    .paymentstatusmarkedasunpaid
                                                    .tr()
                                                : LocaleKeys
                                                    .paymentstatusmarkedaspaid
                                                    .tr(),
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Failed to update payment status: $e")),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: student.isPaid
                                        ? Colors.red
                                        : Colors.grey, // Toggle color
                                    size: 32,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                    size: 26,
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
                                const Spacer(),
                                CustomIconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomShowDialog(
                                          delete:
                                              LocaleKeys.studentDeletion.tr(),
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
                                    size: 28,
                                    color: Colors.red,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
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
          LocaleKeys.addNewStudent.tr(),
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
