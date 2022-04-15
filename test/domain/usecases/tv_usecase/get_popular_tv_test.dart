import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecase/get_popular_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper_tv.mocks.dart';

void main() {
  late GetPopularTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetPopularTVShows(mockTVRepository);
  });

  final tTV = <TV>[];

  group('GetPopularTVShows Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        // arrange
        when(mockTVRepository.getPopularTVShows())
            .thenAnswer((_) async => Right(tTV));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTV));
      });
    });
  });
}
