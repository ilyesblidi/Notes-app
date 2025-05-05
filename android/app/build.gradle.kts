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
        namespace = "com.example.notes_app"
        compileSdk = flutter.compileSdkVersion
        ndkVersion = "27.0.12077973"

        compileOptions {
            sourceCompatibility = JavaVersion.VERSION_1_8
            targetCompatibility = JavaVersion.VERSION_1_8
            isCoreLibraryDesugaringEnabled = true
        }

        kotlinOptions {
            jvmTarget = "1.8"
        }

        defaultConfig {
            applicationId = "com.example.notes_app"
            minSdkVersion(23)
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

    flutter {
        source = "../.."
    }

    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    }