import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming Platform',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MovieListScreen(),
    );
  }
}

class Movie {
  final String title;
  final String url;
  final String poster;

  Movie({required this.title, required this.url, required this.poster});
}

class MovieListScreen extends StatelessWidget {
  final List<Movie> movies = [
    Movie(
      title: 'Inception',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/8PVKfZzVYgZ5qfD5FIS3qVpm2km.jpg',
    ),
    Movie(
      title: 'Avatar',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/3y2k2oEDhB4c6J45F4nQkZ8GZZ5.jpg',
    ),
    // Agrega más películas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(movie: movies[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.network(
                      movies[index].poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movies[index].title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;

  VideoPlayerScreen({required this.movie});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.movie.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            SizedBox(height: 20),
            VideoProgressIndicator(_controller, allowScrubbing: true),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
