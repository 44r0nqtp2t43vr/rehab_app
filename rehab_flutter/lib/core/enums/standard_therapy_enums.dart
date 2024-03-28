enum StandardTherapy { pianoTiles, musicVisualizer, actuatorTherapy, patternTherapy, textureTherapy }

StandardTherapy stringToStandardTherapyEnum(String name) {
  switch (name) {
    case "pianoTiles":
      return StandardTherapy.pianoTiles;
    case "musicVisualizer":
      return StandardTherapy.musicVisualizer;
    case "actuatorTherapy":
      return StandardTherapy.actuatorTherapy;
    case "patternTherapy":
      return StandardTherapy.patternTherapy;
    case "textureTherapy":
      return StandardTherapy.textureTherapy;
    default:
      return StandardTherapy.actuatorTherapy;
  }
}
