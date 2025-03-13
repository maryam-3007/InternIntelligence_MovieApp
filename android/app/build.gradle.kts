plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // Corrected Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin") // Must be applied after Android & Kotlin Gradle plugins
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.movie_app"
    compileSdk = 34 // Explicitly set compileSdk version

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Upgrade to Java 17 for better compatibility
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.movie_app"
        minSdk = 23
        targetSdk = 34 // Explicitly set targetSdk version
        versionCode = 1 // Replace with your version code
        versionName = "1.0.0" // Replace with your version name
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.0.0")) // Use a stable Firebase BOM

    // Firebase dependencies
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")

    // Remove if not using
    // implementation("com.google.firebase:firebase-database-ktx")
    // implementation("com.google.firebase:firebase-storage-ktx")
}