import 'package:flutter/material.dart';
import 'package:minggu_05/detail_screen.dart';
import 'package:minggu_05/http_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpHelper? helper;
  List? movies;
  List? originalMovies;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  String selectedCategory = 'now_playing';

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future initialize() async {
    originalMovies = await helper?.getMovies(selectedCategory);
    setState(() {
      movies = originalMovies;
    });
  }

  Future<void> fetchMoviesByCategory(String category) async {
    movies = await helper?.getMovies(category);
    setState(() {
      selectedCategory = category;
      movies = movies;
    });
  }

  void filterMovies(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        movies = originalMovies;
      });
    } else {
      setState(() {
        movies = originalMovies?.where((movie) {
          return movie.title.toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              onChanged: (value) {
                filterMovies(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search Movie...',
              ),
            ),
          ),
          DropdownButton<String>(
            value: selectedCategory,
            items: <String>[
              'now_playing',
              'popular',
              'top_rated',
              'upcoming',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                fetchMoviesByCategory(selectedCategory);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (movies?.length == null) ? 0 : movies?.length,
              itemBuilder: (BuildContext context, int position) {
                if (movies![position].posterPath != null) {
                  image = NetworkImage(iconBase + movies![position].posterPath);
                } else {
                  image = NetworkImage(defaultImage);
                }
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  child: ListTile(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => DetailScreen(movies![position])
                      );
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                    title: Text(movies![position].title),
                    subtitle: Text(
                      'Released: ${movies![position].releaseDate} - Vote: ${movies![position].voteAverage.toString()}'
                    ),
                  )
                );
              }
            ),
          ),
        ],
      )
    );
  }
}