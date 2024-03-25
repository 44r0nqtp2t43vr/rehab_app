import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/enums/genre_enum.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;
  final Function() onTap;

  const GenreCard({super.key, required this.genre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(genre.name.capitalize!),
        ),
      ),
    );
  }
}
