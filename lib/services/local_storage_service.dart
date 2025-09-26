import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';

class LocalStorageService {
  static const String _gamesKey = 'local_games';
  static const String _completedGamesKey = 'completed_games';

  // 로컬 게임 저장
  static Future<void> saveGame(Game game) async {
    final prefs = await SharedPreferences.getInstance();
    final games = await getGames();
    
    // 기존 게임이 있으면 업데이트, 없으면 추가
    final existingIndex = games.indexWhere((g) => g.id == game.id);
    if (existingIndex >= 0) {
      games[existingIndex] = game;
    } else {
      games.add(game);
    }
    
    final gamesJson = games.map((g) => g.toJson()).toList();
    await prefs.setString(_gamesKey, jsonEncode(gamesJson));
  }

  // 로컬 게임 목록 가져오기
  static Future<List<Game>> getGames() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesString = prefs.getString(_gamesKey);
    
    if (gamesString == null) return [];
    
    try {
      final List<dynamic> gamesJson = jsonDecode(gamesString);
      return gamesJson.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      print('로컬 게임 데이터 파싱 오류: $e');
      return [];
    }
  }

  // 완료된 게임 저장
  static Future<void> saveCompletedGame(Game game) async {
    final prefs = await SharedPreferences.getInstance();
    final completedGames = await getCompletedGames();
    
    // 기존 게임이 있으면 업데이트, 없으면 추가
    final existingIndex = completedGames.indexWhere((g) => g.id == game.id);
    if (existingIndex >= 0) {
      completedGames[existingIndex] = game;
    } else {
      completedGames.add(game);
    }
    
    final gamesJson = completedGames.map((g) => g.toJson()).toList();
    await prefs.setString(_completedGamesKey, jsonEncode(gamesJson));
  }

  // 완료된 게임 목록 가져오기
  static Future<List<Game>> getCompletedGames() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesString = prefs.getString(_completedGamesKey);
    
    if (gamesString == null) return [];
    
    try {
      final List<dynamic> gamesJson = jsonDecode(gamesString);
      return gamesJson.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      print('완료된 게임 데이터 파싱 오류: $e');
      return [];
    }
  }

  // 모든 게임 가져오기 (진행중 + 완료)
  static Future<List<Game>> getAllGames() async {
    final inProgressGames = await getGames();
    final completedGames = await getCompletedGames();
    
    // 완료된 게임 중 진행중 게임과 중복되지 않는 것만 추가
    final allGames = List<Game>.from(inProgressGames);
    for (final completedGame in completedGames) {
      if (!allGames.any((g) => g.id == completedGame.id)) {
        allGames.add(completedGame);
      }
    }
    
    return allGames;
  }

  // 게임 삭제
  static Future<void> deleteGame(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 진행중 게임에서 삭제
    final inProgressGames = await getGames();
    inProgressGames.removeWhere((g) => g.id == gameId);
    await prefs.setString(_gamesKey, jsonEncode(inProgressGames.map((g) => g.toJson()).toList()));
    
    // 완료된 게임에서도 삭제
    final completedGames = await getCompletedGames();
    completedGames.removeWhere((g) => g.id == gameId);
    await prefs.setString(_completedGamesKey, jsonEncode(completedGames.map((g) => g.toJson()).toList()));
  }

  // 모든 데이터 삭제
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gamesKey);
    await prefs.remove(_completedGamesKey);
  }
}
