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
