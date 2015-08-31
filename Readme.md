# Introduction
swift-content-provider is an iOS framework written in Swift 2. It is a set of classes that utilize the framework-agnostic [swift-protocols-sqlite](https://github.com/JeffBNimble/swift-protocols-sqlite) for managing data in your SQLite mobile applications. The framework is an iOS implementation of the Android [ContentProvider](http://developer.android.com/reference/android/content/ContentProvider.html) which provides a clean interface for managing your application content. It provides is a simple SQL interface to content (INSERT, UPDATE, DELETE, QUERY) and a URI-based identification mechanism.

All threading is left to the caller and all operations occur synchronously on the calling thread.

# Documentation
The ContentProvider is documented in the [WIKI](https://github.com/JeffBNimble/swift-content-provider/wiki).

# Installation
Use [Carthage](https://github.com/Carthage/Carthage). This framework requires the use of Swift 2 and XCode 7 or greater.

Specify the following in your Cartfile to use swift-content-provider:

```github "JeffBNimble/swift-content-provider" "0.0.14"```

This library/framework has its own set of dependencies and you should use ```carthage update```. The framework dependencies are specified in the [Cartfile](https://github.com/JeffBNimble/swift-content-provider/blob/master/Cartfile).
