import 'package:wallpaper/features/categories/data/models/category_model.dart';

class CategoriesRepo {
  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/955798/pexels-photo-955798.jpeg",
        categoryName: "Street Art",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/33045/lion-wild-africa-african.jpg",
        categoryName: "Wild Life",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/247599/pexels-photo-247599.jpeg",
        categoryName: "Nature",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/169647/pexels-photo-169647.jpeg",
        categoryName: "City",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/21696/pexels-photo.jpg",
        categoryName: "Motivation",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg",
        categoryName: "Bikes",
      ),
      CategoryModel(
        imgUrl: "https://images.pexels.com/photos/337909/pexels-photo-337909.jpeg",
        categoryName: "Cars",
      ),
    ];
  }
}
