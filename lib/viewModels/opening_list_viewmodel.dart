import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';

import '../models/opening.dart';
import '../models/opening_filter_type.dart';

class OpeningListViewModel extends Model {
  List<Opening> _openingListSource;
  List<Opening> get openingListSource => _openingListSource;
  set openingListSource(List<Opening> openings) {
    _openingListSource = openings;
    _openingList = openings.map((x) => x).toList();
    notifyListeners();
  }

  List<Opening> _openingList;
  List<Opening> get openingList => _openingList;
  set openingList(List<Opening> openings) {
    _openingList = openings;
    notifyListeners();
  }

  void filterOpenings() {
    var x = openingListSource;
    switch (currentFilter) {
      case OpeningFilterType.Opening:
        openingList = x.where((o) {
          var x = o.title.contains(RegExp("[O|o]pening"));
          return x;
        }).toList();
        break;
      case OpeningFilterType.Ending:
        openingList =
            x.where((o) => o.title.contains(RegExp("[E|e]nding"))).toList();
        break;
      default:
        openingList = x;
        break;
    }
  }

  void setOpeningList(List<Opening> openingList) {}

  OpeningFilterType _currentFilter;
  OpeningFilterType get currentFilter => _currentFilter;
  set currentFilter(OpeningFilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  final Map<String, bool> _filterOptions =
      LinkedHashMap.fromIterables(["Opening", "Ending"], [false, false]);
  Map<String, bool> get filterOptions => _filterOptions;

  void toggleFilter(String label, value) {
    filterOptions[label] = value;
    notifyListeners();
  }

  void resetFilter() {
    filterOptions.forEach((x, y) => filterOptions[x] = false);
    notifyListeners();
  }
}
