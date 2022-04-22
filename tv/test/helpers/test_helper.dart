import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TVRepository,
  TVRemoteDataSource,
  TVLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
