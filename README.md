# ATTND

This is an app for tracking personal attendance - be it in school, university or college. It's still in active development, so README.md will be updated along!

Right now, the app is developed strictly for mobile. **Desktop** branch will come later.
**iOS** support is not planned, because of Apple's ecosystem restrictions.

## Build (Android)

**You will need:**
1. Godot export templates:
`Editor -> Manage export templates -> Download and install`
2. Keystore (`.jks`) files:
Pre-generated `debug.jks` and `release.jks` are found in `_dependencies/`. **'User's**: `debug` and `release` respectfully. **Password**: 123456.

If you wish to update / use your own `.jks`'s, use [official keystore generation guide](https://developer.android.com/studio/publish/app-signing#generate-key). Android Studio is required for this.

**Build:**
1. Enter `Editor -> Project -> Export`.
2. Select `Android (Runnable)` template. Edit or create your own if needed.
3. Click `Export Project` and pick a location.
4. You are beautiful! The app can be distributed without the `.idsig` file.

### Usage

The app is in active development, so there's nothing to write here yet! Stay updated!