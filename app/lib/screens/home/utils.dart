class Creation {
  final String title;
  final DateTime lastEdited;
  final String imageName;

  const Creation({
    required this.title,
    required this.lastEdited,
    required this.imageName,
  });
}

String getRelativeTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours > 1 ? 'days' : 'day'} ago';
  }
  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'days' : 'day'} ago';
  } else {
    return 'Just now';
  }
}

final dummyCreations = [
  Creation(
    title: 'Tranquil',
    lastEdited: DateTime(2024, 2, 10),
    imageName: 'assets/images/dummy_img_1.png',
  ),
  Creation(
    title: 'Dinosaur Fossil Sunset',
    lastEdited: DateTime(2024, 1, 15),
    imageName: 'assets/images/dummy_img_2.png',
  ),
  Creation(
    title: 'Autumn Railway Stop',
    lastEdited: DateTime(2023, 12, 5),
    imageName: 'assets/images/dummy_img_3.png',
  ),
  Creation(
    title: 'Mystical Cave Light',
    lastEdited: DateTime(2023, 11, 20),
    imageName: 'assets/images/dummy_img_4.png',
  ),
];