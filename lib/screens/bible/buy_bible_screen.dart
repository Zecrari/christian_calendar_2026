import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/translations.dart';

class BuyBibleScreen extends StatelessWidget {
  final String lang;
  const BuyBibleScreen({Key? key, this.lang = 'en'}) : super(key: key);

  // ── Amazon Affiliate Links (Using Translation Keys) ──────────────────────
  static const List<_BibleCategory> _categories = [
    _BibleCategory(
      titleKey: 'adult_bibles',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF673AB7),
      items: [
        _BibleItem(
          titleKey: 'bible_compact_ref_title',
          subtitleKey: 'bible_compact_ref_sub',
          url: 'https://www.amazon.in/Compact-Reference-Celtic-Burgundy-Leathertouch/dp/153595681X?linkCode=ll1&tag=rameshkannany-21&linkId=ee9f04a007148f8317e167c8484d06c6&language=en_IN&ref_=as_li_ss_tl',
          badgeKey: 'badge_bestseller',
          badgeColor: Color(0xFF4CAF50),
        ),
        _BibleItem(
          titleKey: 'bible_niv_giant_title',
          subtitleKey: 'bible_niv_giant_sub',
          url: 'https://www.amazon.in/Personal-Giant-Print-Bible-Filament/dp/1496467949?linkCode=ll2&tag=rameshkannany-21&linkId=7070f4e8bba6d3ff99cefffe95fea4f8&ref_=as_li_ss_tl',
          badgeKey: 'badge_giant_print',
          badgeColor: Color(0xFF2196F3),
        ),
        _BibleItem(
          titleKey: 'bible_niv_holy_title',
          subtitleKey: 'bible_niv_holy_sub',
          url: 'https://www.amazon.in/Holy-Bible-International-Version-Leathersoft/dp/0310454727?linkCode=ll2&tag=rameshkannany-21&linkId=66fcc7a23fb402cd100efd2e72fe30cc&ref_=as_li_ss_tl',
          badgeKey: 'badge_premium',
          badgeColor: Color(0xFF9C27B0),
        ),
        _BibleItem(
          titleKey: 'bible_niv_comfort_title',
          subtitleKey: 'bible_niv_comfort_sub',
          url: 'https://www.amazon.in/Holy-Bible-International-Version-Comfort/dp/0310463807?linkCode=ll2&tag=rameshkannany-21&linkId=b5531d9f168c47beedccb01980c72291&ref_=as_li_ss_tl',
        ),
        _BibleItem(
          titleKey: 'bible_nlt_nt_title',
          subtitleKey: 'bible_nlt_nt_sub',
          url: 'https://www.amazon.in/Paperback-Testament-English-Flexibound-Translation/dp/B09HPVS3QR?linkCode=ll2&tag=rameshkannany-21&linkId=66bd74a603beb8b5063dea5fa916bbfe&ref_=as_li_ss_tl',
          badgeKey: 'badge_nlt',
          badgeColor: Color(0xFF795548),
        ),
      ],
    ),
    _BibleCategory(
      titleKey: 'study_bibles',
      icon: Icons.auto_stories_rounded,
      color: Color(0xFF1976D2),
      items: [
        _BibleItem(
          titleKey: 'bible_adv_study_title',
          subtitleKey: 'bible_adv_study_sub',
          url: 'https://www.amazon.in/Adventure-Bible-New-International-Version/dp/0310727480?linkCode=ll2&tag=rameshkannany-21&linkId=42f89314ae35755cf5fc0d06b5ca2d6e&ref_=as_li_ss_tl',
          badgeKey: 'badge_kids_study',
          badgeColor: Color(0xFF4CAF50),
        ),
        _BibleItem(
          titleKey: 'bible_action_study_title',
          subtitleKey: 'bible_action_study_sub',
          url: 'https://www.amazon.in/Niv-Action-Study-Bible/dp/0830772545?linkCode=ll2&tag=rameshkannany-21&linkId=5114133ad5673a697ffded12bcd8e488&ref_=as_li_ss_tl',
          badgeKey: 'badge_teen',
          badgeColor: Color(0xFFFF5722),
        ),
      ],
    ),
    _BibleCategory(
      titleKey: 'childrens_bibles',
      icon: Icons.child_care_rounded,
      color: Color(0xFFE91E63),
      items: [
        _BibleItem(
          titleKey: 'bible_golden_child_title',
          subtitleKey: 'bible_golden_child_sub',
          url: 'https://www.amazon.in/Golden-Childrens-Bible-Books/dp/0307165205?linkCode=ll2&tag=rameshkannany-21&linkId=702f9db9d776fba5c2457217cd355dab&ref_=as_li_ss_tl',
          badgeKey: 'badge_classic',
          badgeColor: Color(0xFFFFC107),
        ),
        _BibleItem(
          titleKey: 'bible_biggest_story_title',
          subtitleKey: 'bible_biggest_story_sub',
          url: 'https://www.amazon.in/Biggest-Story-Bible-Storybook/dp/1433557371?linkCode=ll2&tag=rameshkannany-21&linkId=667dff11ef689703e13aadaecbc0f772&ref_=as_li_ss_tl',
          badgeKey: 'badge_award_winning',
          badgeColor: Color(0xFF4CAF50),
        ),
        _BibleItem(
          titleKey: 'bible_101_stories_title',
          subtitleKey: 'bible_101_stories_sub',
          url: 'https://www.amazon.in/101-Bible-Stories-Set-Books/dp/B08KG6DJGP?linkCode=ll2&tag=rameshkannany-21&linkId=b028738b83d0cf17a17e168b65c41de6&ref_=as_li_ss_tl',
          badgeKey: 'badge_set',
          badgeColor: Color(0xFF2196F3),
        ),
        _BibleItem(
          titleKey: 'bible_treasury_title',
          subtitleKey: 'bible_treasury_sub',
          url: 'https://www.amazon.in/Illustrated-Treasury-Bible-Stories-Miles/dp/1786170523?linkCode=ll2&tag=rameshkannany-21&linkId=828d42ca918e7ca7c85d4702ce4d70bd&ref_=as_li_ss_tl',
          badgeKey: 'badge_illustrated',
          badgeColor: Color(0xFF9C27B0),
        ),
        _BibleItem(
          titleKey: 'bible_first_book_title',
          subtitleKey: 'bible_first_book_sub',
          url: 'https://www.amazon.in/My-First-Book-Bible-Stories/dp/938631617X?linkCode=ll2&tag=rameshkannany-21&linkId=e7590f2f53335202a87a0912c8fcfb27&ref_=as_li_ss_tl',
          badgeKey: 'badge_toddlers',
          badgeColor: Color(0xFFFF9800),
        ),
      ],
    ),
  ];

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220, // Slightly taller for breathing room
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
              title: Text(
                AppTranslations.get('buy_bible_title', lang),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF311B92), Color(0xFF6A1B9A), Color(0xFF880E4F)],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background watermark icon
                    Positioned(
                      right: -30,
                      bottom: -20,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Center content
                    Positioned(
                      bottom: 70,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppTranslations.get('buy_bible_subtitle', lang),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Category Sections ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = _categories[index];
                  return _CategorySection(
                    category: category,
                    lang: lang,
                    isDark: isDark,
                    onTap: (url) => _launchUrl(context, url),
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),

          // ── Footer Spacing ────────────────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _BibleCategory {
  final String titleKey;
  final IconData icon;
  final Color color;
  final List<_BibleItem> items;
  const _BibleCategory({
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _BibleItem {
  final String titleKey;
  final String subtitleKey;
  final String url;
  final String? badgeKey;
  final Color? badgeColor;
  const _BibleItem({
    required this.titleKey,
    required this.subtitleKey,
    required this.url,
    this.badgeKey,
    this.badgeColor,
  });
}

// ── Category Section Widget ───────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  final _BibleCategory category;
  final String lang;
  final bool isDark;
  final void Function(String url) onTap;

  const _CategorySection({
    required this.category,
    required this.lang,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(category.icon, color: category.color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  AppTranslations.get(category.titleKey, lang).toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white70 : category.color.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...category.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BibleCard(
                item: item,
                categoryColor: category.color,
                lang: lang,
                isDark: isDark,
                onTap: () => onTap(item.url),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bible Card Widget ─────────────────────────────────────────────────────────

class _BibleCard extends StatefulWidget {
  final _BibleItem item;
  final Color categoryColor;
  final String lang;
  final bool isDark;
  final VoidCallback onTap;

  const _BibleCard({
    required this.item,
    required this.categoryColor,
    required this.lang,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_BibleCard> createState() => _BibleCardState();
}

class _BibleCardState extends State<_BibleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = widget.isDark ? Colors.white10 : widget.categoryColor.withOpacity(0.15);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.isDark
                    ? Colors.black.withOpacity(0.4)
                    : widget.categoryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bible icon container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.categoryColor.withOpacity(0.2),
                        widget.categoryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: widget.categoryColor.withOpacity(0.2)),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: widget.categoryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge (if any)
                      if (widget.item.badgeKey != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.item.badgeColor!.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.item.badgeColor!.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppTranslations.get(widget.item.badgeKey!, widget.lang),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: widget.isDark ? widget.item.badgeColor : widget.item.badgeColor!.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        AppTranslations.get(widget.item.titleKey, widget.lang),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.get(widget.item.subtitleKey, widget.lang),
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isDark ? Colors.white60 : Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                    color: widget.categoryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}