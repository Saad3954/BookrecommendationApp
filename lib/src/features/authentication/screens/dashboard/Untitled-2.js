children: [
            Container(
              color: tSecondaryColorWithOpacity,
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${userData?['user']['name']}!',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'What would you like to read today?',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Add notification functionality here
                            },
                          ),
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 10,
                                minHeight: 10,
                              ),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Padding(
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
                          child: Container(
                            height: 300, // Set a fixed height for the list
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Avoid scroll issues
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final book = _searchResults[index];
                                final coverImage =
                                    book['cover_image'] as String?;
                                final title = book['title'] as String?;
                                final authorName =
                                    book['author']?['name'] as String?;
                                final genreName =
                                    book['genre']?['name'] as String?;

                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16.0),
                                  leading: coverImage != null
                                      ? Container(
                                          width: 75,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              coverImage,
                                              width: 75,
                                              height: 100,
                                              fit: BoxFit.contain,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(Icons.error),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : SizedBox(width: 75, height: 100),
                                  title: Text(title ?? 'Unknown Title'),
                                  subtitle: Text(
                                      '${authorName ?? 'Unknown Author'} • ${genreName ?? 'Unknown Genre'}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailsPage(
                                          bookName: title ?? 'Unknown Title',
                                          bookId: book['id'],
                                          authorName:
                                              authorName ?? 'Unknown Author',
                                          publisherCompany:
                                              book['publisher_company'] ??
                                                  'Unknown Publisher',
                                          publisherDate:
                                              book['publisher_date'] ??
                                                  'Unknown Date',
                                          pageNumbers:
                                              book['page_numbers'] ?? '0',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text('No results found'),
                          ),
                        ),
                ],
              ),
            ),
          ],
        