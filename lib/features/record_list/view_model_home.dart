import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/record_model.dart';

class HomeViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Cache records for each page
  final Map<int, List<RecordModel>> pageCache = {};
  List<RecordModel> filteredRecords = [];
  List<RecordModel> displayedRecords = []; // Records currently being displayed
  
  int currentPage = 1;
  bool isLoading = true;
  String searchQuery = '';
  static const int pageSize = 50;

  HomeViewModel() {
    fetchCurrentPageRecords();
  }

  Future<void> fetchCurrentPageRecords() async {
    if (pageCache.containsKey(currentPage)) {
      _updateDisplayedRecords();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('records')
          .select()
          .range((currentPage - 1) * pageSize, (currentPage * pageSize) - 1);

      final pageRecords = (response as List)
          .map((json) => RecordModel.fromJson(json))
          .toList();
          
      pageCache[currentPage] = pageRecords;
      _updateDisplayedRecords();

    } catch (error) {
      debugPrint('Error fetching records: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateDisplayedRecords() {
    if (searchQuery.isEmpty) {
      displayedRecords = pageCache[currentPage] ?? [];
    } else {
      filteredRecords = [];
      pageCache.forEach((_, records) {
        filteredRecords.addAll(records.where((record) =>
          record.name.toLowerCase().contains(searchQuery.toLowerCase())
        ));
      });
      
      // Sort filtered records by ID
      filteredRecords.sort((a, b) => a.id.compareTo(b.id));

      int startIndex = (currentPage - 1) * pageSize;
      int endIndex = startIndex + pageSize;
      if (startIndex >= filteredRecords.length) {
        currentPage = 1;
        startIndex = 0;
        endIndex = pageSize;
      }
      
      displayedRecords = filteredRecords.sublist(
        startIndex,
        endIndex.clamp(0, filteredRecords.length)
      );
    }
    notifyListeners();
  }

  void nextPage() {
    if (searchQuery.isEmpty) {
      // Normal pagination for unfiltered data
      if (displayedRecords.length == pageSize) {
        currentPage++;
        fetchCurrentPageRecords();
      }
    } else {
      // Pagination for filtered results
      int maxPage = (filteredRecords.length / pageSize).ceil();
      if (currentPage < maxPage) {
        currentPage++;
        _updateDisplayedRecords();
      }
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      if (searchQuery.isEmpty && !pageCache.containsKey(currentPage)) {
        fetchCurrentPageRecords();
      } else {
        _updateDisplayedRecords();
      }
    }
  }

  void searchRecords(String query) {
    searchQuery = query;
    currentPage = 1; // Reset to first page when searching
    _updateDisplayedRecords();
  }

  void clearSearch() {
    searchQuery = '';
    currentPage = 1; // Reset to first page
    _updateDisplayedRecords();
  }

  bool get canGoBack => currentPage > 1;
  
  bool get canGoForward {
    if (searchQuery.isEmpty) {
      return displayedRecords.length == pageSize;
    } else {
      int maxPage = (filteredRecords.length / pageSize).ceil();
      return currentPage < maxPage;
    }
  }

  String get displayRange {
    if (searchQuery.isEmpty) {
      int startIndex = (currentPage - 1) * pageSize + 1;
      int endIndex = startIndex + displayedRecords.length - 1;
      return '$startIndex-$endIndex';
    } else {
      int startIndex = (currentPage - 1) * pageSize + 1;
      int endIndex = startIndex + displayedRecords.length - 1;
      return '$startIndex-$endIndex of ${filteredRecords.length} matches';
    }
  }
}
