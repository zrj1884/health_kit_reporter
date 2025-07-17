import 'package:shared_preferences/shared_preferences.dart';

/// 授权状态管理服务
/// 用于缓存和读取健康数据和临床记录的授权状态
class AuthorizationService {
  static const String _healthDataAuthKey = 'health_data_authorized';
  static const String _clinicalRecordsAuthKey = 'clinical_records_authorized';
  static const String _lastAuthCheckKey = 'last_auth_check_time';

  /// 缓存健康数据授权状态
  static Future<void> cacheHealthDataAuthorization(bool isAuthorized) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_healthDataAuthKey, isAuthorized);
    await prefs.setInt(_lastAuthCheckKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 缓存临床记录授权状态
  static Future<void> cacheClinicalRecordsAuthorization(bool isAuthorized) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clinicalRecordsAuthKey, isAuthorized);
    await prefs.setInt(_lastAuthCheckKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 读取缓存的健康数据授权状态
  static Future<bool> getCachedHealthDataAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_healthDataAuthKey) ?? false;
  }

  /// 读取缓存的临床记录授权状态
  static Future<bool> getCachedClinicalRecordsAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_clinicalRecordsAuthKey) ?? false;
  }

  /// 获取上次授权检查时间
  static Future<DateTime?> getLastAuthCheckTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastAuthCheckKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// 清除所有缓存的授权状态
  static Future<void> clearCachedAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_healthDataAuthKey);
    await prefs.remove(_clinicalRecordsAuthKey);
    await prefs.remove(_lastAuthCheckKey);
  }

  /// 检查授权状态是否需要刷新
  /// 如果距离上次检查超过指定时间，建议刷新授权状态
  static Future<bool> shouldRefreshAuthorization({Duration threshold = const Duration(hours: 24)}) async {
    final lastCheckTime = await getLastAuthCheckTime();
    if (lastCheckTime == null) {
      return true; // 从未检查过，需要刷新
    }

    final now = DateTime.now();
    final difference = now.difference(lastCheckTime);
    return difference > threshold;
  }

  /// 获取授权状态摘要信息
  static Future<Map<String, dynamic>> getAuthorizationSummary() async {
    final healthDataAuth = await getCachedHealthDataAuthorization();
    final clinicalRecordsAuth = await getCachedClinicalRecordsAuthorization();
    final lastCheckTime = await getLastAuthCheckTime();
    final shouldRefresh = await shouldRefreshAuthorization();

    return {
      'healthDataAuthorized': healthDataAuth,
      'clinicalRecordsAuthorized': clinicalRecordsAuth,
      'lastCheckTime': lastCheckTime?.toIso8601String(),
      'shouldRefresh': shouldRefresh,
    };
  }
}
