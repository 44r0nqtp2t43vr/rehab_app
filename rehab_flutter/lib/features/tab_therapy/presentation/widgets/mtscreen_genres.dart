import 'package:flutter/widgets.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/enums/genre_enum.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/genre_card.dart';
import 'package:rehab_flutter/injection_container.dart';

class MTScreenGenres extends StatelessWidget {
  const MTScreenGenres({super.key});

  @override
  Widget build(BuildContext context) {
    final SongProvider songProvider = SongProvider();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Songs',
                  style: darkTextTheme().displaySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _getGenres(songProvider),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getGenres(SongProvider provider) {
    return Genre.values.map((genre) {
      return GenreCard(
        genre: genre,
        onTap: () => _onGenreTapped(genre),
      );
    }).toList();
  }

  void _onGenreTapped(Genre genre) {
    sl<NavigationController>().setSelectedGenre(genre);
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.specificGenre);
  }
}
