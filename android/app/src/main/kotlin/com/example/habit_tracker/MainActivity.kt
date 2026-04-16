package com.eco.habit.tracker.companion.climate.change

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTileLanguage",
            NativeAdFactoryLanguage(layoutInflater),
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTileMedium",
            NativeAdFactoryMedium(layoutInflater),
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileLanguage")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
