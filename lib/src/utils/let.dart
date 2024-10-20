typedef LetCallback<Q, T> = Q Function(T value);

Q? let<Q, T>(T? value, LetCallback<Q, T> cb) {
  if (value != null) {
    return cb(value);
  }

  return null;
}
