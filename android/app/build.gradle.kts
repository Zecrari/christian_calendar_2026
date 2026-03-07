import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// 1. LOAD PROPERTIES (From android/key.properties)
val keystoreProperties = Properties()
// rootProject.file points to 'android/', so this finds 'android/key.properties'
val keystorePropertiesFile = rootProject.file("key.properties") 

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("⚠️ WARNING: key.properties not found at ${keystorePropertiesFile.absolutePath}")
}

android {
    namespace = "com.zecrari.christiancalendar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.zecrari.christiancalendar"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ✅ Bundle Config: Strips unused language resources in AAB (Play Store)
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }

    // 2. SIGNING CONFIG
    signingConfigs {
        create("release") {
            val pKeyAlias = keystoreProperties.getProperty("keyAlias")
            val pKeyPassword = keystoreProperties.getProperty("keyPassword")
            val pStoreFile = keystoreProperties.getProperty("storeFile")
            val pStorePassword = keystoreProperties.getProperty("storePassword")

            // Check if all keys exist to prevent build crashes
            if (pKeyAlias != null && pKeyPassword != null && pStoreFile != null && pStorePassword != null) {
                keyAlias = pKeyAlias
                keyPassword = pKeyPassword
                storePassword = pStorePassword
                
                // file() here looks inside 'android/app/', finding your keystore
                storeFile = file(pStoreFile) 
            } else {
                println("⚠️ RELEASE SIGNING SKIPPED: properties missing in key.properties")
            }
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
    implementation("com.google.firebase:firebase-analytics")
}