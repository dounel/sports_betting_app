import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_betting_app/shared/models/bet_ticket_model.dart';
import 'package:sports_betting_app/shared/models/payment_transaction.dart';
import 'package:sports_betting_app/shared/models/user_profile_model.dart';

/// Sèvis pou otantifikasyon ak pwofil itilizatè.
/// Tout done (imèl, modpas, balans, dat) sere nan pwofil itilizatè a.
class AuthService {
  static const _keyUsers = 'li_facil_users';
  static const _keyCurrentUser = 'li_facil_current_user';

  static Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  static Future<Map<String, Map<String, dynamic>>> _getUsersMap() async {
    final prefs = await _getPrefs();
    final json = prefs.getString(_keyUsers);
    if (json == null || json.isEmpty) return {};
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map) return {};
      final map = <String, Map<String, dynamic>>{};
      for (final e in decoded.entries) {
        if (e.value is Map) {
          map[e.key.toString()] = Map<String, dynamic>.from(e.value as Map);
        }
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  static Future<void> _saveUsersMap(Map<String, Map<String, dynamic>> users) async {
    final prefs = await _getPrefs();
    final encoded = jsonEncode(users);
    await prefs.setString(_keyUsers, encoded);
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyCurrentUser);
  }

  static Future<void> setCurrentUser(String? email) async {
    final prefs = await _getPrefs();
    if (email == null || email.isEmpty) {
      await prefs.remove(_keyCurrentUser);
    } else {
      await prefs.setString(_keyCurrentUser, email);
    }
  }

  /// Anrejistreman: kreye pwofil konplè (imèl, modpas, balans 0, dat) epi sere.
  static Future<String?> register(String email, String password) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty || password.isEmpty) return 'Antre imèl ak modpas';
    final users = await _getUsersMap();
    if (users.containsKey(trimmedEmail)) return 'Imèl sa a deja anrejistre';

    final profile = UserProfileModel(
      email: trimmedEmail,
      password: password,
      balance: 0.0,
      createdAt: DateTime.now(),
    );
    users[trimmedEmail] = profile.toJson();
    await _saveUsersMap(users);
    await setCurrentUser(trimmedEmail);
    return null;
  }

  /// Koneksyon: verifye imèl + modpas, mete itilizatè kounye a.
  static Future<String?> login(String email, String password) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty || password.isEmpty) return 'Antre imèl ak modpas';
    final users = await _getUsersMap();
    final userData = users[trimmedEmail];
    if (userData == null) return 'Pa gen kont pou imèl sa a';
    final storedPassword = userData['password'] as String?;
    if (storedPassword != password) return 'Modpas pa kòrèk';
    await setCurrentUser(trimmedEmail);
    return null;
  }

  static Future<void> logout() async {
    await setCurrentUser(null);
  }

  /// Jwenn pwofil konplè itilizatè kounye a (imèl, modpas, balans, dat).
  static Future<UserProfileModel?> getProfile() async {
    final email = await getCurrentUser();
    if (email == null || email.isEmpty) return null;
    final users = await _getUsersMap();
    final userData = users[email];
    if (userData == null) return null;
    return UserProfileModel.fromJson({...userData, 'email': email});
  }

  /// Balans bous itilizatè kounye a (HTG).
  static Future<double> getBalance() async {
    final profile = await getProfile();
    return profile?.balance ?? 0.0;
  }

  /// Mete balans bous itilizatè kounye a epi sere tout pwofil la.
  static Future<void> setBalance(double amount) async {
    final profile = await getProfile();
    if (profile == null) return;
    final updated = profile.copyWith(balance: amount);
    final users = await _getUsersMap();
    users[profile.email] = updated.toJson();
    await _saveUsersMap(users);
  }

  /// Mete ajou tout pwofil itilizatè kounye a (sere tout chanjemann).
  static Future<void> updateProfile(UserProfileModel profile) async {
    final users = await _getUsersMap();
    users[profile.email] = profile.toJson();
    await _saveUsersMap(users);
  }

  static String _transactionsKey(String email) => 'li_facil_transactions_$email';

  /// Ajoute yon tranzaksyon (depo oswa retrait) nan istwa itilizatè kounye a.
  static Future<void> addTransaction(PaymentTransaction transaction) async {
    final email = await getCurrentUser();
    if (email == null || email.isEmpty) return;
    final prefs = await _getPrefs();
    final key = _transactionsKey(email);
    final json = prefs.getString(key);
    List<dynamic> list = [];
    if (json != null && json.isNotEmpty) {
      try {
        list = jsonDecode(json) as List<dynamic>;
      } catch (_) {}
    }
    list.insert(0, transaction.toJson());
    await prefs.setString(key, jsonEncode(list));
  }

  static String _betTicketsKey(String email) => 'li_facil_bet_tickets_$email';

  /// Ajoute yon tikè pari nan istwa itilizatè kounye a (lè y ap plase pari).
  static Future<void> addBetTicket(BetTicketModel ticket) async {
    final email = await getCurrentUser();
    if (email == null || email.isEmpty) return;
    final prefs = await _getPrefs();
    final key = _betTicketsKey(email);
    final json = prefs.getString(key);
    List<dynamic> list = [];
    if (json != null && json.isNotEmpty) {
      try {
        list = jsonDecode(json) as List<dynamic>;
      } catch (_) {}
    }
    list.insert(0, ticket.toJson());
    await prefs.setString(key, jsonEncode(list));
  }

  /// Jwenn tout tikè pari itilizatè kounye a (istwa fich), pi resan an premye.
  static Future<List<BetTicketModel>> getBetTickets() async {
    final email = await getCurrentUser();
    if (email == null || email.isEmpty) return [];
    final prefs = await _getPrefs();
    final json = prefs.getString(_betTicketsKey(email));
    if (json == null || json.isEmpty) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => BetTicketModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Jwenn istwa peman itilizatè kounye a (depo ak retrait), pi resan an premye.
  static Future<List<PaymentTransaction>> getPaymentHistory() async {
    final email = await getCurrentUser();
    if (email == null || email.isEmpty) return [];
    final prefs = await _getPrefs();
    final json = prefs.getString(_transactionsKey(email));
    if (json == null || json.isEmpty) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => PaymentTransaction.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Chanje modpas: verifye modpas kounye a, epi sere nouvo modpas la.
  static Future<String?> updatePassword(String currentPassword, String newPassword) async {
    final profile = await getProfile();
    if (profile == null) return 'Pa gen pwofil';
    if (profile.password != currentPassword) return 'Modpas kounye a pa kòrèk';
    if (newPassword.length < 6) return 'Nouvo modpas dwe gen omwen 6 karaktè';
    final updated = profile.copyWith(password: newPassword);
    await updateProfile(updated);
    return null;
  }
}
