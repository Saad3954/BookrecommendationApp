import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
        // Add any other app bar customization here
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 10.0,
              alignment: WrapAlignment.center,
              children: [
                InputChip(
                  label: Text('All'),
                  onPressed: () {},
                ),
                InputChip(
                  label: Text('Books'),
                  onPressed: () {},
                ),
                InputChip(
                  label: Text('Author'),
                  onPressed: () {},
                ),
                InputChip(
                  label: Text('Quotes'),
                  onPressed: () {},
                ),
                InputChip(
                  label: Text('People'),
                  onPressed: () {},
                ),
                InputChip(
                  label: Text('List'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 2, // Replace with actual list length
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // Handle item tap
                      },
                      leading: Image.asset(
                        'assets/books/book1.jpg', // Replace with actual image path
                        width: 60,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Book Title $index'), // Replace with actual title
                      subtitle: Text('by: Author Name'), // Replace with actual author name
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star, color: Colors.yellow),
                          Icon(Icons.star_half, color: Colors.yellow),
                          Icon(Icons.star_border, color: Colors.yellow),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
