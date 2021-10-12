// import 'package:permission_handler/permission_handler.dart';

// import 'basenotificacion_providers.dart';

// class PermissionProvider extends BaseChangeNotifier {
//   bool? _locationEnabled;
//   bool? _cameraEnabled;

//   bool? get locationEnabled => _locationEnabled;
//   bool? get cameraEnabled => _cameraEnabled;

//   Future refreshPermissionsStatus() async {
//     await refreshLocationStatus();
//     await refreshCameraStatus();
//   }

//   Future refreshLocationStatus() async {
//     _locationEnabled = await Permission.location.isGranted;
//   }

//   Future refreshCameraStatus() async {
//     _cameraEnabled = await Permission.camera.isGranted;
//   }

//   Future askLocationPermission() async {
//     if (await Permission.location.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//       await openAppSettings();
//       await refreshLocationStatus();
//     }

//     if (!_locationEnabled!) {
//       await Permission.location.request();
//       await refreshLocationStatus();
//     }
//   }

//   Future askCameraPermission() async {
//     if (await Permission.camera.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//       await openAppSettings();
//       await refreshCameraStatus();
//     }
//     if (!_cameraEnabled!) {
//       await Permission.camera.request();
//       await refreshCameraStatus();
//     }
//   }
// }
