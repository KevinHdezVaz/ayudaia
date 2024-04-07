import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/home/category_list/category_list_screen_one.dart';
import 'package:quicklai/ui/home/category_list/category_list_screen_two.dart';

class CategoryListScreen extends StatelessWidget {
  final bool? isShowing;

  const CategoryListScreen({Key? key, this.isShowing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1"
        ? const CategoryListScreenOne()
        : CategoryListScreenTwo(
            isShowing: isShowing,
          );
  }
}
