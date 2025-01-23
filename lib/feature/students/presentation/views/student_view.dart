import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  _StudentViewState createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Stream<QuerySnapshot> _getStudentsStream() {
    final studentsCollection =
        FirebaseFirestore.instance.collection('students');
    if (_searchQuery.isEmpty) {
      return studentsCollection.snapshots();
    } else {
      return studentsCollection
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
          .snapshots();
    }
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
      appBar: AppBar(
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Name",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text("All Grades"),
                  onSelected: (value) {},
                  selected: true,
                ),
                FilterChip(
                  label: Text("3rd Secondary"),
                  onSelected: (value) {},
                  selected: false,
                ),
                FilterChip(
                  label: Text("2nd Secondary"),
                  onSelected: (value) {},
                  selected: false,
                ),
              ],
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
                      final student =
                          students[index].data() as Map<String, dynamic>;
                      final id = students[index].id;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              student['code'] ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(student['name'] ?? "Unknown"),
                          subtitle: Text(student['phone'] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.phone, color: Colors.green),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.wechat_sharp,
                                    color: Colors.green),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteStudent(id),
                              ),
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
          Navigator.pushNamed(
              context, '/add_student'); // Navigate to Add Student page
        },
        label: Text("Add New Student"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
