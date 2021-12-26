import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  /////////////////////////////Test 1
  test('FETCHTOPIDS', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 3, 4, 5, 7]), 200);
    });

    final ids = await newsApi.fetchTopIds();
    expect(ids, [1, 3, 4, 5, 7]);
  });
  ////////////////////////////Test 2
  test('FETCHTOPIDS', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode({'id': 555}), 200);
    });

    final ids = await newsApi.fetchItem(999);
    expect(ids.id, 555);
  });
}
