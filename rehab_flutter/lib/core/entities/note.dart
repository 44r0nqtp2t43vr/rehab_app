class Note {
  final int orderNumber;
  final List<int> lines;
  NoteState state = NoteState.ready;

  Note(this.orderNumber, this.lines);
}

enum NoteState { ready, tapped, missed }
