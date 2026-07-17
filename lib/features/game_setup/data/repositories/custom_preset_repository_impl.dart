import 'dart:convert';

import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/repositories/custom_preset_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPresetRepositoryImpl implements CustomPresetRepository {
  static const _key = 'custom_worker_presets';

  @override
  Future<List<CustomPresetEntity>> getPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return [];
      final list = jsonDecode(jsonString) as List;
      return list
          .map((e) => CustomPresetEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('Error loading custom presets: $e\n$stackTrace');
      return [];
    }
  }

  @override
  Future<void> savePresets(List<CustomPresetEntity> presets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(presets.map((p) => p.toJson()).toList());
      await prefs.setString(_key, jsonString);
    } catch (e, stackTrace) {
      debugPrint('Error saving custom presets: $e\n$stackTrace');
    }
  }
}
