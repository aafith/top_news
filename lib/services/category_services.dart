import 'package:top_news/model/category_model.dart';

List<Category> getCategorys() {
  List<Category> categorys = [];

  // Business
  Category category = Category();
  category.name = 'Business';
  category.image = 'assets/business.jpg';
  categorys.add(category);

  // Entertainment
  category = Category();
  category.name = 'Entertainment';
  category.image = 'assets/entertainment.jpg';
  categorys.add(category);

  // Health
  category = Category();
  category.name = 'Health';
  category.image = 'assets/health.jpg';
  categorys.add(category);

  // Science
  category = Category();
  category.name = 'Science';
  category.image = 'assets/science.jpg';
  categorys.add(category);

  // Sports
  category = Category();
  category.name = 'Sports';
  category.image = 'assets/sports.jpg';
  categorys.add(category);

  // Technology
  category = Category();
  category.name = 'Technology';
  category.image = 'assets/technology.jpg';
  categorys.add(category);

  return categorys;
}
