import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';

final StateProvider<Map<String, bool>> mapUsingMapProvider = StateProvider((ref) => {});
final onMapSearchProvider = StateProvider((ref) => false);
final StateProvider<List<MapDetail>> mapSearchListProvider = StateProvider((ref) => []);
final mapPageProvider = StateProvider((ref) => 2);
final textEditingControllerProvider = StateProvider((ref) => TextEditingController());
final mapSearchBarFocusProvider = StateProvider((ref) => FocusNode());
final mapFocusMapDetailProvider = StateProvider((ref) => MapDetail.none);
final mapViewTransformationControllerProvider =
    StateProvider((ref) => TransformationController(Matrix4.identity()));
final searchDatetimeProvider =
    NotifierProvider<SearchDatetimeNotifier, DateTime>(() => SearchDatetimeNotifier());
final mapDetailMapProvider = FutureProvider(
  (ref) async {
    return MapDetailMap(await MapRepository().getMapDetailMapFromFirebase());
  },
);

class SearchDatetimeNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void set(DateTime dt) {
    state = dt;
  }

  void reset() {
    state = DateTime.now();
  }
}
