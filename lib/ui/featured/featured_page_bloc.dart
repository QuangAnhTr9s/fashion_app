import 'package:flutter/material.dart';

import '../../base/bloc/bloc.dart';

class FeaturedPageBloc extends Bloc{
  final pageCartController = PageController();
  late TabController tabController;

  @override
  void dispose() {
    super.dispose();
  }
}