import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/enums/genre_enum.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;
  final Function() onTap;

  const GenreCard({super.key, required this.genre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      color: const Color(0xff128BED),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF128BED),
                    Color(0xFF01FF99),
                  ],
                  stops: [0.1, 1.0],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.2),
            ),
            InkWell(
              onTap: onTap,
              child: ListTile(
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    genre.name.capitalize!,
                    style: darkTextTheme().headlineMedium,
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 16, bottom: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
