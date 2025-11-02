import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Service - Backend integration
/// Specification from Backend_Specification_v2.5.1
class SupabaseService {
  static SupabaseClient? _client;
  
  // Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _client = Supabase.instance.client;
  }
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call SupabaseService.initialize() first.');
    }
    return _client!;
  }
  
  // Authentication
  static Future<AuthResponse> signInWithEmail(String email, String password) {
    return client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) {
    return client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }
  
  static Future<void> signOut() {
    return client.auth.signOut();
  }
  
  static User? get currentUser => client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // Real-time subscriptions
  static RealtimeChannel channel(String name) {
    return client.channel(name);
  }
}

