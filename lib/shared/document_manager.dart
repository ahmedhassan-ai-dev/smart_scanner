import 'models/document_page.dart';

class DocumentManager {
  static final List<DocumentPage> pages = [];

  static bool useSingleFilter = true;

  static String globalFilter = '';

  static bool globalUseCropped = true;

  static void addPage(
    DocumentPage page,
  ) {
    pages.add(page);

    if (globalFilter.isEmpty) {
      globalFilter =
          page.selectedFilter;

      globalUseCropped =
          page.useCropped;
    }
  }

  static void removePage(
    int index,
  ) {
    pages.removeAt(index);
  }

  static void reorder(
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    final item =
        pages.removeAt(oldIndex);

    pages.insert(
      newIndex,
      item,
    );
  }

  static void clear() {
    pages.clear();

    globalFilter = '';

    globalUseCropped = true;

    useSingleFilter = true;
  }
}