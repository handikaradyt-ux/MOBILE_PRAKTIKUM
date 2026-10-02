class ScreenArguments {
  final String cover;
  final String title;
  final String description;
  final String shortDesc;
  final String thumbnail;

  ScreenArguments(
    this.cover,
    this.title,
    this.description,
    this.shortDesc, [
    this.thumbnail = '',
  ]);
}
