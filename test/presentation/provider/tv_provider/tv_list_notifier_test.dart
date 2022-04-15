import 'package:dartz/dartz.dart';

import 'package:ditonton/common/failure.dart';

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecase/get_popular_tv_show.dart';
import 'package:ditonton/domain/usecases/tv_usecase/get_top_rated_tv_show.dart';
import 'package:ditonton/domain/usecases/tv_usecase/get_tv_on_the_air.dart';
import 'package:ditonton/presentation/provider/tv_provider/Tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTVOnTheAir, GetPopularTVShows, GetTopRatedTVShows])
void main() {
  late TVListNotifier provider;
  late MockGetTVOnTheAir mockGetTVOnTheAir;
  late MockGetPopularTVShows mockGetPopularTVShows;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVOnTheAir = MockGetTVOnTheAir();
    mockGetPopularTVShows = MockGetPopularTVShows();
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    provider = TVListNotifier(
      getTVOnTheAir: mockGetTVOnTheAir,
      getPopularTVShows: mockGetPopularTVShows,
      getTopRatedTVShows: mockGetTopRatedTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTV = TV(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    originalName: 'originalName',
    popularity: 1,
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    originalLanguage: '',
    originCountry: [],
  );

  final tTVList = <TV>[tTV];

  group('now playing TV Shows', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTVOnTheAir.execute()).thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchtvOnTheAir();
      // assert
      verify(mockGetTVOnTheAir.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTVOnTheAir.execute()).thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchtvOnTheAir();
      // assert
      expect(provider.onTheAirState, RequestState.Loading);
    });

    test('should change TV Shows when data is gotten successfully', () async {
      // arrange
      when(mockGetTVOnTheAir.execute()).thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchtvOnTheAir();
      // assert
      expect(provider.onTheAirState, RequestState.Loaded);
      expect(provider.tvOnTheAir, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVOnTheAir.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchtvOnTheAir();
      // assert
      expect(provider.onTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular TV Shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change TV Shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.Loaded);
      expect(provider.popularTVShows, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated TV Shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.Loading);
    });

    test('should change TV Shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.Loaded);
      expect(provider.topRatedTVShows, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}