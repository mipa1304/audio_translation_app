import org.gradle.api.execution.TaskExecutionGraph
import org.gradle.api.execution.TaskExecutionGraphListener
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseSigningProperties = Properties().apply {
    val propertiesFile = rootProject.file("key.properties")
    if (propertiesFile.isFile) {
        propertiesFile.inputStream().use { load(it) }
    }
}
val releaseStoreFile = releaseSigningProperties.getProperty("storeFile")
val releaseStorePassword = releaseSigningProperties.getProperty("storePassword")
val releaseKeyAlias = releaseSigningProperties.getProperty("keyAlias")
val releaseKeyPassword = releaseSigningProperties.getProperty("keyPassword")
val hasReleaseSigning = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "com.mihir.transcription_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.mihir.transcription_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = file(requireNotNull(releaseStoreFile))
                storePassword = requireNotNull(releaseStorePassword)
                keyAlias = requireNotNull(releaseKeyAlias)
                keyPassword = requireNotNull(releaseKeyPassword)
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

gradle.taskGraph.addTaskExecutionGraphListener(
    object : TaskExecutionGraphListener {
        override fun graphPopulated(taskGraph: TaskExecutionGraph) {
            val buildingRelease = taskGraph.allTasks.any {
                it.project == project &&
                    it.name in setOf("bundleRelease", "assembleRelease")
            }
            if (buildingRelease) {
                check(hasReleaseSigning) {
                    "Release signing is not configured. Run scripts/build-release.ps1 " +
                        "or provide android/key.properties."
                }
                check(file(requireNotNull(releaseStoreFile)).isFile) {
                    "The upload keystore configured in android/key.properties does not exist."
                }
            }
        }
    },
)

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.play:feature-delivery:2.1.0")
    implementation("com.google.android.play:review:2.0.2")
    implementation("com.google.mlkit:text-recognition-chinese:16.0.1")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.1")    
    implementation("com.google.mlkit:text-recognition-japanese:16.0.1")
    implementation("com.google.mlkit:text-recognition-korean:16.0.1")

  }
