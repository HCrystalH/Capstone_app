# Capstone_app

1. Check local.properties(module) - have to add by yourself --> about sdk, flutter location

2. Check gradle-wrapper.properties

distributionUrl=https\://services.gradle.org/distributions/gradle-7.4-all.zip
--- change gralde supported version for more suitable

3.Check kotlin version 
-- if the problem is "duplicated class in Kotlin" --> change to  id "org.jetbrains.kotlin.android" version "1.8.0" apply false
in settings.gradle (project) 
