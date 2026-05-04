package com.eco.habit.tracker.companion.climate.change

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
// NOTE: Ads are temporarily disabled.
//
// Original AdMob plugin import preserved for later re-enable:
// import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // NOTE: Ads are temporarily disabled.
        //
        // Original native ad factory registration preserved for later re-enable:
        /*
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
        */
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // NOTE: Ads are temporarily disabled.
        //
        // Original unregistration preserved for later re-enable:
        /*
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileLanguage")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium")
        */
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
