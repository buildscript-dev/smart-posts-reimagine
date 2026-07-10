import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/mock_shell.dart';
import '../../shared/ui_kit.dart';
import 'shell.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    final results = _query.isEmpty
        ? searchCorpus
        : searchCorpus
            .where((s) =>
                s.title.toLowerCase().contains(_query.toLowerCase()) ||
                s.subtitle.toLowerCase().contains(_query.toLowerCase()))
            .toList();
    return ShellScaffold(
      index: tabSearch,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
            child: SoftCard(
              padding: EdgeInsets.zero,
              radius: Corners.lg,
              child: TextField(
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(color: ink),
                decoration: const InputDecoration(
                  hintText: 'Search products, posts, people…',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: AppColors.brandGreen),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Text('No results for "$_query"',
                        style: const TextStyle(color: AppColors.greyText)))
                : ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final r = results[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SoftCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: AppColors.heroGradient,
                                  borderRadius:
                                      BorderRadius.circular(Corners.sm),
                                ),
                                child: Icon(
                                  switch (r.kind) {
                                    'Product' => Icons.shopping_bag_rounded,
                                    'Post' => Icons.image_rounded,
                                    _ => Icons.person_rounded,
                                  },
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(r.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: ink)),
                                    Text(r.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.greyText)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.brandGreen
                                      .withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(r.kind,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.brandGreen)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
