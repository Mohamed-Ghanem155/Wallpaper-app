import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/core/DI/dependency_injection.dart';
import 'package:wallpaper/core/widgets/brand_name.dart';
import 'package:wallpaper/features/categories/logic/categories_cubit.dart';
import 'package:wallpaper/features/categories/logic/categories_state.dart';
import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/routing/routes.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoriesCubit>()..loadCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: const BrandName(),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (categories) {
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(Routes.searchScreen, extra: category.categoryName);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(category.imgUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category.categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.black45,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                orElse: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}
