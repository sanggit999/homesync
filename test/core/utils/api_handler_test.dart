import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/errors/failures.dart';
import 'package:home_sync/core/utils/api_handler.dart';

void main() {
  group('safeApiCall Global Handler Type-Safe Tests', () {
    test('returns Right(data) on successful execution', () async {
      final result = await safeApiCall(() async => 'success_data');
      expect(result, isA<Right<Failure, String>>());
      result.match((l) => fail('should not fail'), (r) => expect(r, 'success_data'));
    });

    test('maps TimeoutException to Left(TimeoutFailure)', () async {
      final result = await safeApiCall(
        () async => Future.delayed(const Duration(milliseconds: 100), () => 'data'),
        timeout: const Duration(milliseconds: 20),
      );
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<TimeoutFailure>()), (r) => fail('should fail with TimeoutFailure'));
    });

    test('maps SocketException to Left(NetworkFailure)', () async {
      final result = await safeApiCall(() async {
        throw const SocketException('No Internet Connection');
      });
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<NetworkFailure>()), (r) => fail('should fail with NetworkFailure'));
    });

    test('maps http.ClientException to Left(NetworkFailure)', () async {
      final result = await safeApiCall(() async {
        throw http.ClientException('Client socket failed');
      });
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<NetworkFailure>()), (r) => fail('should fail with NetworkFailure'));
    });

    test('maps HandshakeException to Left(NetworkFailure)', () async {
      final result = await safeApiCall(() async {
        throw const HandshakeException('Handshake failed');
      });
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<NetworkFailure>()), (r) => fail('should fail with NetworkFailure'));
    });

    test('maps AuthException to Left(AuthFailure)', () async {
      final result = await safeApiCall(() async {
        throw const AuthException('Invalid login credentials', statusCode: '400');
      });
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<AuthFailure>()), (r) => fail('should fail with AuthFailure'));
    });

    test('maps PostgrestException to Left(ServerFailure)', () async {
      final result = await safeApiCall(() async {
        throw const PostgrestException(message: 'Database query failed', code: '42P01');
      });
      expect(result, isA<Left<Failure, String>>());
      result.match((l) => expect(l, isA<ServerFailure>()), (r) => fail('should fail with ServerFailure'));
    });
  });
}
