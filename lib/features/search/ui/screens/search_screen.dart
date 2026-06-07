import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/core/DI/dependency_injection.dart';
import 'package:wallpaper/core/widgets/brand_name.dart';
import 'package:wallpaper/core/widgets/wallpapers_list.dart';
import 'package:wallpaper/features/search/logic/search_cubit.dart';
import 'package:wallpaper/features/search/logic/search_state.dart';

class SearchScreen extends StatelessWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchCubit>()..searchWallpapers(searchQuery),
      child: Scaffold(
        appBar: AppBar(
          title: const BrandName(),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (message) => Center(child: Text('Error: $message')),
                      success: (wallpapers) => WallpapersList(wallpapers: wallpapers),
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
