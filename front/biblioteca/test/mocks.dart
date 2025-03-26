import 'package:biblioteca/data/providers/auth_provider.dart';
import 'package:biblioteca/data/providers/login_provider.dart';
import 'package:biblioteca/data/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}
class MockAuthProvider extends Mock implements AuthProvider {}
class MockLoginProvider extends Mock implements LoginProvider {}