import 'dart:async';

// The dart:async library supports asynchronous programming with Futures and Streams.
void main() async {
  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Data fetched!';
  }
  String data = await fetchData();
  print(data);
}