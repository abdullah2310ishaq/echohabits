package com.eco.habit.tracker.companion.climate.change

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactorySmall(private val context: Context) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {

        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_small, null) as NativeAdView

        // Icon
        adView.iconView = adView.findViewById(R.id.native_ad_icon)

        if (nativeAd.icon != null) {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
        } else {
            adView.iconView?.visibility = View.GONE
        }

        // CTA Button
        adView.callToActionView =
            adView.findViewById(R.id.native_ad_button)

        if (nativeAd.callToAction != null) {
            (adView.callToActionView as Button).text =
                nativeAd.callToAction
        } else {
            adView.callToActionView?.visibility = View.GONE
        }

        // Headline
        adView.headlineView =
            adView.findViewById(R.id.native_ad_headline)

        (adView.headlineView as TextView).text =
            nativeAd.headline

        // Body
        adView.bodyView =
            adView.findViewById(R.id.native_ad_body)

        if (nativeAd.body != null) {
            (adView.bodyView as TextView).text =
                nativeAd.body
        } else {
            adView.bodyView?.visibility = View.GONE
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}