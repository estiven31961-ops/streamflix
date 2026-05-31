import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:streamflix/providers/auth_provider.dart';
import 'package:streamflix/providers/content_provider.dart';
import 'package:streamflix/providers/favorites_provider.dart';
import 'package:streamflix/providers/watch_progress_provider.dart';
import 'package:streamflix/screens/auth/login_screen.dart';
import 'package:streamflix/screens/home/home_screen.dart';
import 'package:streamflix/screens/home/search_screen.dart';
import 'package:streamflix/screens/home/continue_watching_screen.dart';
import 'package:streamflix/screens/detail/movie_detail_screen.dart';
import 'package:streamflix/screens/detail/series_detail_screen.dart';
import 'package:streamflix/screens/detail/episode_detail_screen.dart';
import 'package:streamflix/screens/detail/tv_stream_screen.dart';
import 'package:streamflix/screens/favorites/favorites_screen.dart';
import 'package:streamflix/screens/profile/profile_screen.dart';
import 'package:streamflix/widgets/video_player_widget.dart';
import 'package:streamflix/models/movie_model.dart';
import 'package:streamflix/models/series_model.dart';
import 'package:streamflix/models/tv_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Inicializar Hive
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => WatchProgressProvider()),
      ],
      child: MaterialApp(
        title: 'StreamFlix',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Color(0xFF0F0F0F),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0F0F0F),
            elevation: 0,
            centerTitle: true,
          ),
          useMaterial3: true,
        ),
        home: _buildHome(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => _MainApp());
            case '/search':
              return MaterialPageRoute(builder: (_) => SearchScreen());
            case '/continue_watching':
              return MaterialPageRoute(builder: (_) => ContinueWatchingScreen());
            case '/favorites':
              return MaterialPageRoute(builder: (_) => FavoritesScreen());
            case '/profile':
              return MaterialPageRoute(builder: (_) => ProfileScreen());
            case '/movie_detail':
              if (settings.arguments is MovieModel) {
                return MaterialPageRoute(
                  builder: (_) => MovieDetailScreen(
                    movie: settings.arguments as MovieModel,
                  ),
                );
              }
              break;
            case '/series_detail':
              if (settings.arguments is SeriesModel) {
                return MaterialPageRoute(
                  builder: (_) => SeriesDetailScreen(
                    series: settings.arguments as SeriesModel,
                  ),
                );
              }
              break;
            case '/episode_detail':
              if (settings.arguments is Map) {
                final args = settings.arguments as Map;
                return MaterialPageRoute(
                  builder: (_) => EpisodeDetailScreen(
                    series: args['series'],
                    seasonNumber: args['season'],
                    episodeNumber: args['episode'],
                  ),
                );
              }
              break;
            case '/tv_stream':
              if (settings.arguments is TVModel) {
                return MaterialPageRoute(
                  builder: (_) => TVStreamScreen(
                    tv: settings.arguments as TVModel,
                  ),
                );
              }
              break;
            case '/player':
              if (settings.arguments is Map) {
                final args = settings.arguments as Map;
                return MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(
                    url: args['url'],
                    title: args['title'],
                    contentType: args['type'] ?? 'movie',
                    userId: args['userId'] ?? 'guest',
                    contentId: args['id'].toString(),
                    seasonNumber: args['season'],
                    episodeNumber: args['episode'],
                  ),
                );
              }
              break;
            default:
              break;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildHome() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoggedIn) {
          return _MainApp();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class _MainApp extends StatefulWidget {
  @override
  State<_MainApp> createState() => __MainAppState();
}

class __MainAppState extends State<_MainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF1a1a1a),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withValues(alpha: 0.6),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
