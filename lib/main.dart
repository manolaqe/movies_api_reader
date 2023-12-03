import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import 'photos_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies API reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Movies API reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiUrl = 'https://yts.mx/api/v2/list_movies.json';

  Future<Response> fetchData() async {
    final Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 30))),
        ),
        body: FutureBuilder<Response>(
            future: fetchData(),
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final Map<String, dynamic> snapshotData =
                    json.decode(snapshot.data!.body) as Map<String, dynamic>;
                final Map<String, dynamic> jsonData =
                    snapshotData['data'] as Map<String, dynamic>;
                final List<dynamic> movies =
                    jsonData['movies']! as List<dynamic>;

                return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> movie =
                          movies[index] as Map<String, dynamic>;
                      final List<dynamic> torrents =
                          movie['torrents'] as List<dynamic>;

                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        'id: ${movie['id'] as int}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200))),
                                Expanded(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        'IMDB Code: ${movie['imdb_code'] as String}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200))),
                                Expanded(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        'YT Trailer Code: ${movie['yt_trailer_code'] as String}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200))),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: Text(
                                    textAlign: TextAlign.center,
                                    movie['title_long'] as String,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400))),
                            Center(
                                child: Text(movie['slug'] as String,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200))),
                            const SizedBox(
                              height: 10,
                            ),
                            PhotosWidget(movie: movie),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            '${movie['genres']}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onLongPress: () => movie['summary'] !=
                                                ''
                                            ? showDialog<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          content: SingleChildScrollView(
                                                              child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  movie['summary']
                                                                      as String,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200))),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Close'))
                                                          ],
                                                        ))
                                            : null,
                                        child: Text(
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            'summary: ${movie['summary']}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onLongPress:
                                            () =>
                                                movie['description_full'] != ''
                                                    ? showDialog<void>(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  content: SingleChildScrollView(
                                                                      child: Text(
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          movie['description_full']
                                                                              as String,
                                                                          style: const TextStyle(
                                                                              fontSize: 30,
                                                                              fontWeight: FontWeight.w200))),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Close'))
                                                                  ],
                                                                ))
                                                    : null,
                                        child: Text(
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            'description_full: ${movie['description_full']}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onLongPress: () => movie['synopsis'] !=
                                                ''
                                            ? showDialog<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          content: SingleChildScrollView(
                                                              child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  movie['synopsis']
                                                                      as String,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200))),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Close'))
                                                          ],
                                                        ))
                                            : null,
                                        child: Text(
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            'synopsis: ${movie['synopsis']}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('title: ${movie['title']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text(
                                          'title_english: ${movie['title_english']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text('language: ${movie['language']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text('year: ${movie['year']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text('rating: ${movie['rating']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text(
                                          'mpa_rating: ${movie['mpa_rating'] == '' ? 'N/A' : movie['mpa_rating']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text('runtime: ${movie['runtime']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text(
                                          'date_uploaded: ${movie['date_uploaded']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      Text('state: ${movie['state']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200)),
                                      GestureDetector(
                                          onTap: () => showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                final List<Widget> widgets =
                                                    <Widget>[
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ];

                                                for (int i = 0;
                                                    i < torrents.length;
                                                    i++) {
                                                  final Map<String, dynamic>
                                                      torrent = torrents[i]
                                                          as Map<String,
                                                              dynamic>;

                                                  widgets.addAll(<Widget>[
                                                    Text(
                                                        'url: ${torrent['url']}'),
                                                    Text(
                                                        'hash: ${torrent['hash']}'),
                                                    Text(
                                                        'quality: ${torrent['quality']}'),
                                                    Text(
                                                        'type: ${torrent['type']}'),
                                                    Text(
                                                        'is_repack: ${torrent['is_repack']}'),
                                                    Text(
                                                        'size: ${torrent['size']}'),
                                                    Text(
                                                        'size_bytes: ${torrent['size_bytes']}'),
                                                    Text(
                                                        'date_uploaded: ${torrent['date_uploaded']}'),
                                                    Text(
                                                        'date_uploaded_unix: ${torrent['date_uploaded_unix']}'),
                                                    Text(
                                                        'seeds: ${torrent['seeds']}'),
                                                    Text(
                                                        'peers: ${torrent['peers']}'),
                                                    Text(
                                                        'video_codec: ${torrent['video_codec']}'),
                                                    Text(
                                                        'bit_depth: ${torrent['bit_depth']}'),
                                                  ]);
                                                }
                                                return AlertDialog(
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Close'))
                                                    ],
                                                    content: Column(
                                                      children: widgets,
                                                    ));
                                              }),
                                          child: Text(
                                              'torrents: ${torrents.length}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w200))),
                                      Center(
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary)),
                                              onPressed: () => launchUrl(
                                                  Uri.parse(movie['url'] as String)),
                                              child: const Text('Open YTS page')))
                                    ]))
                          ],
                        ),
                      );
                    });
              }
            }));
  }
}
