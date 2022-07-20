import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("maven-publish")
    `maven-publish`
    kotlin("jvm") version "1.7.0"
}

publishing {
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/jakub-spiewak/grpc-multilanguage-package-blog-example")
            credentials {
                username = project.findProperty("gpr.user") as String? ?: System.getenv("USERNAME")
                password = project.findProperty("gpr.key") as String? ?: System.getenv("TOKEN")
            }
        }
    }
    publications {
        register<MavenPublication>("gpr") {
            groupId = "com.jakubspiewak"
            artifactId = "grpc"
            version = (project.findProperty("version") ?: "unspecified") as String?
            from(components["java"])
        }
    }
}

group = "com.jakubspiewak.grpc"
version = project.findProperty("version") ?: "unspecified"

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
    implementation(platform("org.jetbrains.kotlin:kotlin-bom"))

    // protobuf
    api("com.google.protobuf:protobuf-java:3.21.1")
    api("com.google.protobuf:protobuf-kotlin:3.21.1")

    // grpc
    api("io.grpc:grpc-protobuf:1.47.0")
    api("io.grpc:grpc-stub:1.47.0")
    api("io.grpc:grpc-kotlin-stub:1.3.0")

    // kotlin
    api("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.2")
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "17"
}
