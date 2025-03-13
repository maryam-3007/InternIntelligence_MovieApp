// Top-level build file where you can add configuration options common to all sub-projects/modules.
import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.2.1") // Ensure this is present
        classpath("com.google.gms:google-services:4.4.2") // Google Services Plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Updated Kotlin Gradle Plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set new build directory path
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Task to clean the build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}