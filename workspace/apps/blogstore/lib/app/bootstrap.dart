import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart' show BlocSignalProvider, MultiBlocSignalProvider;
import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../features/settings/appearance/presentation/bloc/appearance_settings_bloc.dart' show AppearanceSettingsBloc;
import '../firebase_options.dart' show DefaultFirebaseOptions;
import '../injection/dependency_injection.dart' show AppDependencies, AppDependenciesProvider;
import '../router.dart';
import 'error/bootstrap_error.dart';
import 'router/router.dart' show AppRouter;

/// Measurement ID for Firebase Analytics on web.
const String measurementId = 'G-EX30SN5FR5'; // Optional Not needed for now

/// Service worker script path for Firebase Cloud Messaging on web.
const String serviceWorkerScriptPath =
    '/firebase-messaging-sw.js'; // Optional Not needed for now

/// VAPID key for web push notifications.
const String vapidKey = '';

/// Initializer for Firebase services.
abstract interface class FirebaseInitializer {
  /// Initializes Firebase and related platform services.
  Future<FirebaseApp> initialize();
}

/// Default implementation of [FirebaseInitializer].
final class const DefaultFirebaseInitializer({
  /// Optional explicit Firebase options.
  final FirebaseOptions? options,
}) implements FirebaseInitializer {
  @override
  Future<FirebaseApp> initialize() =>
      Firebase.initializeApp(options: _platformOptions);

  FirebaseOptions get _platformOptions {
    final options = this.options ?? DefaultFirebaseOptions.currentPlatform;

    if (!kIsWeb) {
      return options;
    }

    return FirebaseOptions(
      apiKey: options.apiKey,
      appId: options.appId,
      messagingSenderId: options.messagingSenderId,
      projectId: options.projectId,
      authDomain: options.authDomain,
      databaseURL: options.databaseURL,
      storageBucket: options.storageBucket,
      measurementId: options.measurementId ?? measurementId,
      trackingId: options.trackingId,
      deepLinkURLScheme: options.deepLinkURLScheme,
      androidClientId: options.androidClientId,
      iosClientId: options.iosClientId,
      iosBundleId: options.iosBundleId,
      appGroupId: options.appGroupId,
    );
  }
}

/// Reporter for recording unhandled crashes and errors.
abstract interface class CrashReporter {
  /// Records an unhandled error and stack trace.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  });

  /// Records a Flutter error. pass fatal as true when error is critical.
  /// If the app is running in debug mode, the error will be printed to the console.
  /// If the app is running in release mode, the error will be sent to Firebase Crashlytics.
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  });
}

/// Default implementation of [CrashReporter].
final class const DefaultCrashReporter({
  /// Firebase Crashlytics instance.
  ///
  /// If `null`, errors will not be reported to Firebase Crashlytics.
  final FirebaseCrashlytics? _crashlytics,
}) implements CrashReporter {
  FirebaseCrashlytics? get _instance =>
      kIsWeb ? null : _crashlytics ?? FirebaseCrashlytics.instance;

  /// Creates a default crash reporter.

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    return unawaited(
      _instance?.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal,
      ),
    );
  }

  @override
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) async {
    return unawaited(
      _instance?.recordFlutterError(flutterErrorDetails, fatal: fatal),
    );
  }
}

/// Callback for background notification processing.
// typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

/// Gateway for push notification setup and permissions.
abstract interface class const NotificationGateway() {
  Future<bool> isSupported();

  /// Requests user permission for notifications.
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  });

  Future<NotificationSettings> getNotificationSettings();

  Future<String?> getToken({String? vapidKey, String? serviceWorkerScriptPath});

  Future<String?> getAPNSToken();

  Stream<String> get tokenChanges;

  Future<void> deleteToken();

  Stream<RemoteMessage> get onForegroundMessage;

  Stream<RemoteMessage> get onNotificationOpened;

  Future<RemoteMessage?> getInitialMessage();

  bool get isAutoInitEnabled;

  Future<void> setAutoInitEnabled(bool enabled);

  Future<void> setDeliveryMetricsExportToBigQuery(bool enabled);

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> setForegroundPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  });

  Future<void> registerBackgroundHandler(BackgroundMessageHandler handler);
}

/// Default implementation of [NotificationGateway].
final class const DefaultNotificationGateway({
  /// When omitted, [FirebaseMessaging.instance] is resolved lazily.
  final FirebaseMessaging? _messaging,

  /// VAPID key used for web push notifications.
  final String? vapidKey,

  /// Service worker script path used for web push notifications.
  final String? serviceWorkerScriptPath,
}) implements NotificationGateway {
  FirebaseMessaging get _instance => _messaging ?? FirebaseMessaging.instance;

  static const _unsupportedSettings = NotificationSettings(
    authorizationStatus: AuthorizationStatus.notDetermined,
    alert: AppleNotificationSetting.notSupported,
    announcement: AppleNotificationSetting.notSupported,
    badge: AppleNotificationSetting.notSupported,
    carPlay: AppleNotificationSetting.notSupported,
    lockScreen: AppleNotificationSetting.notSupported,
    notificationCenter: AppleNotificationSetting.notSupported,
    showPreviews: AppleShowPreviewSetting.notSupported,
    timeSensitive: AppleNotificationSetting.notSupported,
    criticalAlert: AppleNotificationSetting.notSupported,
    sound: AppleNotificationSetting.notSupported,
    providesAppNotificationSettings: AppleNotificationSetting.notSupported,
  );

  Future<T> _ifSupported<T>(Future<T> Function() action, T? unsupported) {
    return isSupported().then(
      (supported) => supported ? action() : Future<T>.value(unsupported),
    );
  }

  @override
  Future<bool> isSupported() => _instance.isSupported();

  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) {
    return _ifSupported(
      () => _instance.requestPermission(
        alert: alert,
        announcement: announcement,
        badge: badge,
        carPlay: carPlay,
        criticalAlert: criticalAlert,
        provisional: provisional,
        sound: sound,
        providesAppNotificationSettings: providesAppNotificationSettings,
      ),
      _unsupportedSettings,
    );
  }

  @override
  Future<NotificationSettings> getNotificationSettings() {
    return _ifSupported(
      _instance.getNotificationSettings,
      _unsupportedSettings,
    );
  }

  @override
  Future<String?> getToken({
    String? vapidKey,
    String? serviceWorkerScriptPath,
  }) {
    return _ifSupported(
      () => _instance
          .getToken(
            vapidKey: vapidKey ?? this.vapidKey,
            serviceWorkerScriptPath:
                serviceWorkerScriptPath ?? this.serviceWorkerScriptPath,
          )
          .catchError((_) => null),
      null,
    );
  }

  @override
  Future<String?> getAPNSToken() {
    return _ifSupported(_instance.getAPNSToken, null);
  }

  @override
  Stream<String> get tokenChanges =>
      isSupported().asStream().asyncExpand((supported) {
        if (!supported) {
          return const Stream.empty();
        }

        return Stream.multi((controller) {
          unawaited(
            getToken().then((token) {
              if (token != null) {
                controller.add(token);
              }

              return controller.addStream(_instance.onTokenRefresh);
            }),
          );
        });
      });

  @override
  Future<void> deleteToken() {
    return _ifSupported<void>(_instance.deleteToken, null);
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onNotificationOpened =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() {
    return _ifSupported(_instance.getInitialMessage, null);
  }

  @override
  bool get isAutoInitEnabled => _instance.isAutoInitEnabled;

  @override
  Future<void> setAutoInitEnabled(bool enabled) {
    return _ifSupported<void>(
      () => _instance.setAutoInitEnabled(enabled),
      null,
    );
  }

  @override
  Future<void> setDeliveryMetricsExportToBigQuery(bool enabled) {
    return _ifSupported<void>(
      () => _instance.setDeliveryMetricsExportToBigQuery(enabled),
      null,
    );
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    return _ifSupported<void>(() => _instance.subscribeToTopic(topic), null);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    return _ifSupported<void>(
      () => _instance.unsubscribeFromTopic(topic),
      null,
    );
  }

  @override
  Future<void> setForegroundPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) {
    return _ifSupported<void>(
      () => _instance.setForegroundNotificationPresentationOptions(
        alert: alert,
        badge: badge,
        sound: sound,
      ),
      null,
    );
  }

  @override
  Future<void> registerBackgroundHandler(BackgroundMessageHandler handler) {
    return _ifSupported<void>(() {
      FirebaseMessaging.onBackgroundMessage(handler);
      return Future<void>.value();
    }, null);
  }
}

/// Background handler for Firebase Cloud Messaging events.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await const DefaultFirebaseInitializer().initialize();
  // create seprate instance of database frst as this is a new isolate
  final db = AppDatabase();
  try {
    /// Purge expired notifications before inserting the newly received message
    await db.notificationMsgDao.deleteExpiredMessages();
    await db.notificationMsgDao.insertNotificationMessage(
      message.toCompanion(),
    );
  } finally {
    // Close the database for onyl this isolate when this isolate has finished using it.
    await db.close();
  }
}

/// Root bootstrap widget initializing dependencies and managing splash state.
class const BootStrap({
  /// Application binding used to defer and allow frames.
  required final WidgetsBinding binding,

  /// Error reporter capturing boot and runtime errors.
  required final BootstrapErrorReporter errors,

  /// Pluggable service dependencies for the application bootstrap.
  required final AppDependencies appDependencies,
  super.key,
}) extends StatefulWidget {
  @override
  State<BootStrap> createState() => _BootStrapState();
}

class _BootStrapState extends State<BootStrap> {
  late final AppDatabase _db;
  late final AppearanceSettingsBloc? _appearanceSettingsBloc;
  late final AppRouter? _appRouter;
  double _progress = 0;
  String _loadingMessage = 'Starting application...';


  void _setProgress(double progress, String message) {
    if (!mounted) return;

    setState(() {
      _progress = progress;
      _loadingMessage = message;
    });
  }

  Future<void> _initAsync() async {
    _db = AppDatabase();
    final firebaseInitializer = widget.appDependencies.firebaseInitializer;
    final crashReporter = widget.appDependencies.crashReporter;
    final notificationGateway = widget.appDependencies.notificationGateway;
    try {
      _setProgress(0, 'Initializing Firebase...');
      await firebaseInitializer.initialize();

      widget.errors.attach((error, stackTrace) {
        unawaited(crashReporter.recordError(error, stackTrace, fatal: true));
      });

      _setProgress(0.25, 'Configuring notifications...');
      unawaited(
        notificationGateway.registerBackgroundHandler(
          firebaseMessagingBackgroundHandler,
        ),
      );
      // Startup cleanup on active database connection
      _setProgress(0.35, 'Cleaning up expired notifications...');
      await _db.notificationMsgDao.deleteExpiredMessages();
      _setProgress(0.45, 'Configuring application...');
      Intl.defaultLocale =
          // db..... ??
          PlatformDispatcher.instance.locale.toLanguageTag();
      final appearanceSettingsBloc = AppearanceSettingsBloc();
      _setProgress(0.60, 'Loading settings...');
      // await appearanceSettingsBloc.loadSettings();
      _setProgress(0.75, 'Preparing navigation...');
      final appRouter = AppRouter(
        appearenceSettingBloc: appearanceSettingsBloc,
      ); //db, dependencies
      if (!mounted) return;
      setState(() {
        _appearanceSettingsBloc = appearanceSettingsBloc;
        _appRouter = appRouter;
        _progress = 1.0;
        _loadingMessage = 'Ready';
      });
      await notificationGateway.requestPermission();
      // Bootstrap catches any exception or error during initialization.
      // ignore: avoid_catches_without_on_clauses
    } catch (error, stackTrace) {
      crashReporter.recordError(error, stackTrace, fatal: true);
    } finally {
      _allowFirstFrame();
    }
  }

  void _allowFirstFrame() {
    if (!widget.binding.sendFramesToEngine) {
      widget.binding.allowFirstFrame();
    }
  }

  @override
  void initState() {
    unawaited(_initAsync());
    super.initState();
  }

  @override
  void dispose() {
    widget.errors.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = _appRouter;
    if (router != null) {
      return AppDependenciesProvider(appDependencies: ,
       child: MultiBlocSignalProvider(
        providers: [
          BlocSignalProvider<AppearanceSettingsBloc>.value(value: appearanceSettingsBloc),
        ],
        child: router.buildApp(context)));
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: const Color(0xFF121212),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  backgroundColor: const Color(0xFF2C2C2C),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6750A4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _loadingMessage,
                style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
