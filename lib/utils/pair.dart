class Pair<T> {
  Pair(this.left, this.right);

  final T left;
  final T right;

  @override
  String toString() => 'Pair[$left, $right]';
}
