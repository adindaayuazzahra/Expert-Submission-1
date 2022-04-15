import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_usecase/save_tv_watchlist.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper_tv.mocks.dart';

void main() {
  late SaveTVWatchList usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveTVWatchList(mockTVRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(mockTVRepository.saveWatchlist(testTVDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVDetail);
    // assert
    verify(mockTVRepository.saveWatchlist(testTVDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
