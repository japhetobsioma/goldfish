import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/tile_color.dart';

class TileColorNotifier extends StateNotifier<AsyncValue<TileColor>> {
  TileColorNotifier() : super(const AsyncValue.loading()) {
    _fetchTileColor();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _fetchTileColor() async {
    final selectedTileColor = await dbHelper.getSelectedTileColor();
    final allTileColor = await dbHelper.getAllTileColor();

    state = AsyncValue.data(
      TileColor(
        selectedTileColor: selectedTileColor[0]['tileColors'],
        allTileColor: allTileColor,
      ),
    );
  }

  Future<void> setSelectedTileColor(String tileColor) async {
    await dbHelper.setSelectedTileColor(tileColor);

    final selectedTileColor = await dbHelper.getSelectedTileColor();
    final allTileColor = await dbHelper.getAllTileColor();

    state = AsyncValue.data(
      TileColor(
        selectedTileColor: selectedTileColor[0]['tileColors'],
        allTileColor: allTileColor,
      ),
    );
  }
}

final tileColorProvider =
    StateNotifierProvider<TileColorNotifier, AsyncValue<TileColor>>(
  (ref) => TileColorNotifier(),
);
