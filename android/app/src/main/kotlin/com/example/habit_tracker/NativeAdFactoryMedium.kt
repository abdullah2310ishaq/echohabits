package com.eco.habit.tracker.companion

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryMedium(
    private val layoutInflater: LayoutInflater,
) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?,
    ): NativeAdView {
        val adView = layoutInflater.inflate(
            R.layout.native_ads_medium,
            null,
        ) as NativeAdView

        val headlineView = adView.findViewById<TextView>(R.id.native_ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.native_ad_body)
        val iconView = adView.findViewById<ImageView>(R.id.native_ad_icon)
        val buttonView = adView.findViewById<Button>(R.id.native_ad_button)

        headlineView.text = nativeAd.headline

        val bodyText = nativeAd.body.orEmpty().trim()
        if (bodyText.isNotEmpty()) {
            bodyView.visibility = View.VISIBLE
            bodyView.text = bodyText
        } else {
            bodyView.visibility = View.GONE
        }

        val iconDrawable = nativeAd.icon?.drawable
        if (iconDrawable != null) {
            iconView.visibility = View.VISIBLE
            iconView.setImageDrawable(iconDrawable)
        } else {
            iconView.visibility = View.GONE
        }

        val ctaText = nativeAd.callToAction.orEmpty().trim()
        if (ctaText.isNotEmpty()) {
            buttonView.visibility = View.VISIBLE
            buttonView.text = ctaText
        } else {
            buttonView.visibility = View.GONE
        }

        adView.headlineView = headlineView
        adView.bodyView = bodyView
        adView.iconView = iconView
        adView.callToActionView = buttonView
        adView.mediaView = null
        adView.setNativeAd(nativeAd)

        return adView
    }
}
