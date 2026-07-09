import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/mock_shell.dart';
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
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(color: ink),
              decoration: InputDecoration(
                hintText: 'Search products, posts, people…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.trackGrey.withValues(alpha: .6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Text('No results for "$_query"',
                        style: TextStyle(color: AppColors.greyText)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final r = results[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.brandGreenLight.withValues(alpha: .3),
                          child: Icon(
                            switch (r.kind) {
                              'Product' => Icons.shopping_bag_outlined,
                              'Post' => Icons.image_outlined,
                              _ => Icons.person_outline,
                            },
                            color: AppColors.deepGreen,
                          ),
                        ),
                        title: Text(r.title,
                            style: TextStyle(color: ink)),
                        subtitle: Text(r.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.greyText)),
                        trailing: Text(r.kind,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.brandGreen)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
