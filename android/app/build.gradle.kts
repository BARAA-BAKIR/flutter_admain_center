plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_admain_center"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // <-- MODIFIED THIS (تعديل هذا السطر)

    compileOptions {
        // --- ADD THIS BLOCK --- (إضافة هذا البلوك)
        // This is for the "desugaring" error
        isCoreLibraryDesugaringEnabled = true
        // --------------------
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_admain_center"
        minSdk = flutter.minSdkVersion // <-- IMPORTANT: Make sure this is at least 21 (مهم: تأكد أن هذا الرقم 21 أو أعلى)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// --- ADD THIS BLOCK AT THE END --- (إضافة هذا البلوك في النهاية)
dependencies {
    // This is for the "desugaring" error
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
// ---------------------------------

flutter {
    source = "../.."
}
