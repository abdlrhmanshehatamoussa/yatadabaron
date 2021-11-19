class SearchSlice {
  final int start;
  final int end;
  final String text;
  final bool match;

  SearchSlice({
    required this.start,
    required this.end,
    required this.text,
    required this.match,
  });
}