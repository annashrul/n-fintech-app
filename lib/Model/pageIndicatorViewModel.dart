//view model for page indicator
import 'package:n_fintech/Model/pageViewModel.dart';
import 'package:n_fintech/Constants/constants.dart';

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.pages,
      this.activeIndex,
      this.slideDirection,
      this.slidePercent,
      );
}
