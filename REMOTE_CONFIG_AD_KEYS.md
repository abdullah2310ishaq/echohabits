## Firebase Remote Config (Ads) – Easy Setup

### 1) Firebase console me kahan jana hai
- Firebase Console → **Remote Config** → **Parameters** → **Add parameter**

### 2) Kaun kaun se keys (parameters) banane hain
In 4 keys ko **exact same name** ke saath create karo:

1) `show_splash_ads` (Boolean)
2) `show_splash_app_open_ad` (Boolean)
3) `show_splash_interstitial_ad` (Boolean)
4) `show_native_language_ad` (Boolean)

### 3) Recommended default values (safe)
Start me safe defaults:
- `show_splash_ads` = `false`
- `show_splash_app_open_ad` = `false`
- `show_splash_interstitial_ad` = `false`
- `show_native_language_ad` = `false`

Phir jab ready ho jao:
- `show_splash_ads` = `true`
- aur jis ad type ko enable karna ho uska flag `true` kar do.

### 4) Publish kaise karna hai
- Values set karne ke baad **Publish changes** click karo.

### 5) Quick troubleshooting
- App me changes instantly nahi aa rahe: Remote Config fetch interval / caching ki wajah se delay ho sakta hai.
- Key ka spelling mismatch hoga to app default value use karega. Names exactly same rakho.

