import 'package:christian_calendar/services/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    String chapterText = BibleData.getChapterText(selectedBook, selectedChapter);
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(primaryColor, bgColor),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                        child: Column(
                          children: [
                            _buildElegantSelector(primaryColor),
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
                _buildFloatingNavBar(),
              ],
            ),
    );
  }

  Widget _buildSliverAppBar(Color primaryColor, Color bgColor) {
    return SliverAppBar(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: _buildElegantBuyButton(),
        ),
        IconButton(
          icon: const Icon(Icons.format_size_rounded),
          color: primaryColor,
          onPressed: () => _showFormatSettings(),
        ),
      ],
    );
  }

  Widget _buildElegantSelector(Color primaryColor) {
    return GestureDetector(
      onTap: () => _showUnifiedSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 20,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              selectedBook,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 1,
              height: 16,
              color: primaryColor.withOpacity(0.3),
            ),
            Icon(
              Icons.format_list_numbered_rounded,
              size: 18,
              color: primaryColor.withOpacity(0.8),
            ),
            const SizedBox(width: 6),
            Text(
              "$selectedChapter",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: primaryColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  // --- FIXED: Unified Book & Chapter Selector with proper state management ---
  void _showUnifiedSelector(BuildContext context) {
    // Create a StatefulWidget to manage modal state independently
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookChapterSelector(
        lang: widget.lang,
        initialBook: selectedBook,
        initialChapter: selectedChapter,
        onBookChanged: (book) {
          setState(() {
            selectedBook = book;
            selectedChapter = 1;
          });
        },
        onChapterSelected: (chapter) {
          setState(() {
            selectedChapter = chapter;
          });
          Navigator.pop(ctx);
          _scrollController.jumpTo(0);
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  Widget _buildSelectorSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Text(
                AppTranslations.get('search_scripture', widget.lang),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "⌘ K",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavButton(
              icon: Icons.chevron_left_rounded,
              onTap: selectedChapter > 1
                  ? () {
                      setState(() => selectedChapter--);
                      _scrollController.jumpTo(0);
                    }
                  : null,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _showUnifiedSelector(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedBook,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${AppTranslations.get('chapter', widget.lang)} $selectedChapter",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildNavButton(
              icon: Icons.chevron_right_rounded,
              onTap: selectedChapter < BibleData.getChapterCount(selectedBook)
                  ? () {
                      setState(() => selectedChapter++);
                      _scrollController.jumpTo(0);
                    }
                  : null,
            ),
            _buildNavButton(
              icon: Icons.search_rounded,
              onTap: () {
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
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: onTap != null
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

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
            ],
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
              Icons.auto_stories_rounded,
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
}

// --- NEW: Separate StatefulWidget for the Book/Chapter Selector Modal ---
class _BookChapterSelector extends StatefulWidget {
  final String lang;
  final String initialBook;
  final int initialChapter;
  final Function(String) onBookChanged;
  final Function(int) onChapterSelected;
  final VoidCallback onCancel;

  const _BookChapterSelector({
    required this.lang,
    required this.initialBook,
    required this.initialChapter,
    required this.onBookChanged,
    required this.onChapterSelected,
    required this.onCancel,
  });

  @override
  State<_BookChapterSelector> createState() => _BookChapterSelectorState();
}

class _BookChapterSelectorState extends State<_BookChapterSelector> {
  late String selectedBook;
  late int selectedChapter;

  @override
  void initState() {
    super.initState();
    selectedBook = widget.initialBook;
    selectedChapter = widget.initialChapter;
  }

  void _selectBook(String book) {
    setState(() {
      selectedBook = book;
      selectedChapter = 1;
    });
    widget.onBookChanged(book);
  }

  void _selectChapter(int chapter) {
    setState(() => selectedChapter = chapter);
    widget.onChapterSelected(chapter);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Trigger search from parent
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade500),
                      const SizedBox(width: 12),
                      Text(
                        AppTranslations.get('search_scripture', widget.lang),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "⌘ K",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppTranslations.get('select_book_chapter', widget.lang),
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Scroll to current book
                    },
                    icon: const Icon(Icons.location_on, size: 18),
                    label: Text(AppTranslations.get('current', widget.lang)),
                  ),
                ],
              ),
            ),
            
            // Book & Chapter Grid
            Expanded(
              child: Row(
                children: [
                  // Books List (Left Side)
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: BibleData.availableBooks.length,
                      itemBuilder: (ctx, index) {
                        final book = BibleData.availableBooks[index];
                        final isSelected = book == selectedBook;
                        final isOldTestament = index < 39;
                        
                        return GestureDetector(
                          onTap: () => _selectBook(book),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isOldTestament
                                        ? const Color(0xFF673AB7)
                                        : const Color(0xFFFFA000),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    book,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Chapters Grid (Right Side) - NOW PROPERLY REACTIVE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "$selectedBook ${AppTranslations.get('chapters', widget.lang)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: BibleData.getChapterCount(selectedBook),
                            itemBuilder: (ctx, index) {
                              final chapter = index + 1;
                              final isSelected = chapter == selectedChapter;
                              
                              return GestureDetector(
                                onTap: () => _selectChapter(chapter),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.03),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$chapter",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
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
                ],
              ),
            ),
            
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.onCancel,
                        icon: const Icon(Icons.close),
                        label: Text(AppTranslations.get('cancel', widget.lang)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: Text(
                          "${AppTranslations.get('read', widget.lang)} $selectedBook $selectedChapter",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ENHANCED SEARCH DELEGATE ---
class BibleSearchDelegate extends SearchDelegate {
  final String lang;
  final Function(String, int) onVerseSelected;
  
  BibleSearchDelegate({required this.lang, required this.onVerseSelected});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        showSuggestions(context);
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildRecentSearches(context);
    }
    return _buildSearchResults(context);
  }

  Widget _buildRecentSearches(BuildContext context) {
    final recentSearches = <String>['John 3:16', 'Psalm 23', 'Genesis 1', 'Love'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.get('recent_searches', lang),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(AppTranslations.get('clear', lang)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((search) {
              return ActionChip(
                avatar: const Icon(Icons.history, size: 18),
                label: Text(search),
                onPressed: () {
                  query = search;
                  showResults(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            AppTranslations.get('popular_verses', lang),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPopularVerseCard(context, 'John 3:16', 'For God so loved the world...'),
          _buildPopularVerseCard(context, 'Psalm 23:1', 'The Lord is my shepherd...'),
          _buildPopularVerseCard(context, 'Philippians 4:13', 'I can do all things through Christ...'),
        ],
      ),
    );
  }

  Widget _buildPopularVerseCard(BuildContext context, String reference, String preview) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          reference,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          preview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        onTap: () {
          query = reference;
          showResults(context);
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              AppTranslations.get('type_to_search', lang),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    final results = BibleData.searchVerses(query);
    
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              AppTranslations.get('no_verses_found', lang),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.get('try_different_keywords', lang),
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Hero(
          tag: 'verse_${result['book']}_${result['chapter']}_${result['verse']}',
          child: Card(
            elevation: 0,
            color: Theme.of(context).cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                AdHelper.showInterstitialAd();
                close(context, null);
                onVerseSelected(result['book'], result['chapter']);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${result['book']} ${result['chapter']}:${result['verse']}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "\"${result['text']}\"",
                      style: const TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}