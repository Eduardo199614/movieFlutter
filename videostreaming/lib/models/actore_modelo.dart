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
      home: HomeScreen(),
    );
  }
}

class Movie {
  final String title;
  final String url;
  final String poster;

  Movie({required this.title, required this.url, required this.poster});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MovieListScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
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
    Movie(
      title: 'Titanic',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/eVhYZtMdmMZ4sS4UHdU4NYYZfE1.jpg',
    ),
    Movie(
      title: 'The Dark Knight',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/q1QGZNO48kGhgfZ6edL1n5rZa6w.jpg',
    ),
    Movie(
      title: 'The Godfather',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/iY8g3ZP1M1V5kbbU1ePqEtQ2VVI.jpg',
    ),
    Movie(
      title: 'Forrest Gump',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/mB0NMTwWb9A3VBRIM8OK8t7X7Vg.jpg',
    ),
    Movie(
      title: 'The Matrix',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/4D1HNLkLlEo3a1Zf1QHnbVhBlqh.jpg',
    ),
    Movie(
      title: 'Interstellar',
      url:
          'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4',
      poster: 'https://image.tmdb.org/t/p/w500/8G8I7z6Er7hFZ4FzFhUsf7K7VWI.jpg',
    ),
    // Agrega más películas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Favoritos',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Perfil',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
