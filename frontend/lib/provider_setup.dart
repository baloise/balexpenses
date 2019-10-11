import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/providers/ocr_service.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildCloneableWidget> independentServices = [];

List<SingleChildCloneableWidget> dependentServices = [
  ChangeNotifierProvider.value(value: OcrService()),
  ChangeNotifierProvider.value(value: FirebaseAuthService()),
];

List<SingleChildCloneableWidget> uiConsumableProviders = [];
