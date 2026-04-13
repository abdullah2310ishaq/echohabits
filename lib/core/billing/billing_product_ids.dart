/// Central place to define your store product IDs.
///
/// Replace these with the exact IDs from Play Console / App Store Connect.
abstract final class BillingProductIds {
  /// One‑time purchase (non‑consumable).
  static const String lifetime = 'eco_habit_lifetime_trial';

  /// Subscription (weekly) – configure the 3‑day free trial in Play Console
  /// via base plan / offer (the code will pick the best available offer).
  static const String weekly = 'eco_habit_weekly_3day_trial';
}

