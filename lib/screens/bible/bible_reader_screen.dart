import 'package:christian_calendar/services/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/translations.dart';
import '../../config/constants.dart';
import '../../data/bible_data.dart';

class BibleReaderScreen extends StatefulWidget {
  final String lang;
  const BibleReaderScreen({Key? key, required this.lang}) : super(key: key);

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  String selectedBook = 'Genesis';
  int selectedChapter = 1;
  bool isLoading = true;
  double fontSize = 18.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBibleData();
  }

  @override
  void didUpdateWidget(BibleReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) _loadBibleData();
  }

  Future<void> _loadBibleData() async {
    setState(() => isLoading = true);
    await BibleData.load(widget.lang);
    if (BibleData.availableBooks.isNotEmpty) {
      if (!BibleData.availableBooks.contains(selectedBook)) {
        selectedBook = BibleData.availableBooks[0];
        selectedChapter = 1;
      }
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _launchAmazon() async {
    final Uri url = Uri.parse(AppConstants.BIBLE_AMAZON_LINK);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not open link: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String chapterText = BibleData.getChapterText(
      selectedBook,
      selectedChapter,
    );
    String firstLetter = "";
    String remainingText = "";
    if (chapterText.isNotEmpty && chapterText != "Loading...") {
      String trimmed = chapterText.trimLeft();
      if (trimmed.isNotEmpty) {
        firstLetter = trimmed.substring(0, 1);
        remainingText = trimmed.substring(1);
      }
    }

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: bgColor,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        title: Text(
                          AppTranslations.get('bible_reader', widget.lang),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        actions: [
                          // --- NEW ELEGANT BUY BUTTON ---
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            child: _buildElegantBuyButton(),
                          ),

                          // ------------------------------
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            color: primaryColor,
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: BibleSearchDelegate(
                                  lang: widget.lang,
                                  onVerseSelected: (book, chapter) {
                                    setState(() {
                                      selectedBook = book;
                                      selectedChapter = chapter;
                                    });
                                    _scrollController.jumpTo(0);
                                  },
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.format_size_rounded),
                            color: primaryColor,
                            onPressed: () => _showFormatSettings(),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _showBookSelector(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    selectedBook.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "${AppTranslations.get('chapter', widget.lang)} $selectedChapter",
                                style: TextStyle(
                                  fontSize: 42,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: fontSize,
                                color: textColor,
                                height: 1.8,
                                fontFamily: 'Serif',
                              ),
                              children: [
                                TextSpan(
                                  text: firstLetter,
                                  style: TextStyle(
                                    fontSize: fontSize * 3.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF673AB7),
                                    height: 0.8,
                                  ),
                                ),
                                TextSpan(text: remainingText),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: () => _navigateChapter(-1),
                            ),
                            GestureDetector(
                              onTap: () => _showBookSelector(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF673AB7),
                                      Color(0xFF512DA8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "$selectedBook $selectedChapter",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: () => _navigateChapter(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  // --- NEW ELEGANT BUTTON WIDGET ---
  Widget _buildElegantBuyButton() {
    return GestureDetector(
      onTap: _launchAmazon,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA726),
              Color(0xFFFB8C00),
            ], // Gold/Amber Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_rounded, // Better than shopping cart for books
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              AppTranslations.get('buy_bible_book', widget.lang).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateChapter(int change) {
    if (change == -1 && selectedChapter > 1) {
      setState(() => selectedChapter--);
      _scrollController.jumpTo(0);
    } else if (change == 1 &&
        selectedChapter < BibleData.getChapterCount(selectedBook)) {
      setState(() => selectedChapter++);
      _scrollController.jumpTo(0);
    }
  }

  void _showFormatSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.get('text_size', widget.lang),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "A",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: fontSize,
                          min: 12.0,
                          max: 40.0,
                          divisions: 14,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (val) {
                            setModalState(() => fontSize = val);
                            this.setState(() => fontSize = val);
                          },
                        ),
                      ),
                      const Text(
                        "A",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBookSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          AppTranslations.get('select_book', widget.lang),
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemCount: BibleData.availableBooks.length,
                          itemBuilder: (ctx, i) {
                            final book = BibleData.availableBooks[i];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedBook = book;
                                  selectedChapter = 1;
                                });
                                Navigator.pop(ctx);
                                _scrollController.jumpTo(0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color:
                                          i < 39
                                              ? const Color(0xFF673AB7)
                                              : const Color(0xFFFFA000),
                                      width: 4,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    book,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}

class BibleSearchDelegate extends SearchDelegate {
  final String lang;
  final Function(String, int) onVerseSelected;
  BibleSearchDelegate({required this.lang, required this.onVerseSelected});

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context).copyWith(
    scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
  );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );
  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.length < 3) {
      return Center(
        child: Text(
          AppTranslations.get('search_scripture', lang),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    final results = BibleData.searchVerses(query);
    if (results.isEmpty) {
      return Center(child: Text(AppTranslations.get('no_verses', lang)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              "${result['book']} ${result['chapter']}:${result['verse']}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "\"${result['text']}\"",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Serif', height: 1.4),
              ),
            ),
            onTap: () {
              AdHelper.showInterstitialAd();
              close(context, null);
              onVerseSelected(result['book'], result['chapter']);
            },
          ),
        );
      },
    );
  }
}
