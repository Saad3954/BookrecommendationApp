/* _onTapBook(BuildContext context, Map<String, dynamic> book) {
    final bookId = book['book_id']; // Adjust based on your book data structure
    final bookName = book['title'];
    final authorName = book['author']?['name'] ?? 'Unknown Author';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          bookId: bookId,
          bookName: bookName,
          authorName: authorName,
        ),
      ),
    );
  } */


 /* Container(
                    margin: EdgeInsets.only(top: 12.0, bottom: 0.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ), */

                  /* Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by title, author, ISBN, or genre...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (query) {
                        if (query.length > 2) {
                          _searchBooks(query);
                        } else {
                          setState(() {
                            _searchResults = [];
                          });
                        }
                      },
                    ),
                  ),
                  _searchResults.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Avoid scroll issues
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final book = _searchResults[index];
                              final coverImage = book['cover_image'] as String?;
                              final title = book['title'] as String?;
                              final authorName =
                                  book['author']?['name'] as String?;
                              final genreName =
                                  book['genre']?['name'] as String?;

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                leading: coverImage != null
                                    ? Image.network(
                                        coverImage,
                                        width: 50,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox(width: 50, height: 75),
                                title: Text(title ?? 'Unknown Title'),
                                subtitle: Text(
                                    '${authorName ?? 'Unknown Author'} • ${genreName ?? 'Unknown Genre'}'),
                                onTap: () {
                                  // Handle book click, navigate to details or other actions
                                },
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text('No results found'),
                          ),
                        ), */