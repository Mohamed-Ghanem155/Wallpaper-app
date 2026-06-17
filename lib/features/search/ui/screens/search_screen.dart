import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/core/DI/dependency_injection.dart';
import 'package:wallpaper/core/widgets/wallpapers_list.dart';
import 'package:wallpaper/features/search/logic/search_cubit.dart';
import 'package:wallpaper/features/search/logic/search_state.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchCtrl;
  late SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.searchQuery);
    _searchCubit = getIt<SearchCubit>()..searchWallpapers(widget.searchQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _searchCubit.searchWallpapers(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: const Color(0xFF0A0A0F),
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12), width: 1),
                      ),
                      child: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                title: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 45),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF7C5CFC).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _searchCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onFieldSubmitted: _performSearch,
                  ),
                ),
              ),
            ),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF7C5CFC)),
                      ),
                    ),
                  ),
                  error: (msg) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text('Error: $msg',
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                  ),
                  success: (wallpapers) => wallpapers.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Center(
                              child: Text(
                                'No results found 😔',
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                          sliver: WallpapersGrid(wallpapers: wallpapers),
                        ),
                  orElse: () => const SliverToBoxAdapter(child: SizedBox()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
