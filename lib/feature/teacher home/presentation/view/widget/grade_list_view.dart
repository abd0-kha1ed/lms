import 'package:flutter/material.dart';

class HorizontalButtonList extends StatefulWidget {
  const HorizontalButtonList({super.key, required this.items});
  final List<String> items;

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalButtonListState createState() => _HorizontalButtonListState();
}

class _HorizontalButtonListState extends State<HorizontalButtonList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.teal : Colors.white,
                side: BorderSide(
                  color: Colors.teal,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                widget.items[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.teal,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
