import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/DI/dependency_injection.dart';
import 'package:wallpaper/core/routing/routes.dart';
import 'package:wallpaper/core/widgets/brand_name.dart';
import 'package:wallpaper/core/widgets/wallpapers_list.dart';
import 'package:wallpaper/features/home/logic/home_cubit.dart';
import 'package:wallpaper/features/home/logic/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..getTrendingWallpapers(),
      child: Scaffold(
        appBar: AppBar(
          title: const BrandName(),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 232, 237, 245),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "     Search",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.push(Routes.searchScreen, extra: value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Made By", style: TextStyle(color: Colors.black, fontSize: 15)),
                    Text(" Dragon", style: TextStyle(color: Colors.blue, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 25),
                BlocBuilder<HomeCubit, HomeState>(
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
