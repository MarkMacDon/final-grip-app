class APIPath {
  static String trainingday(String uid, String trainingdayId) =>
      'users/$uid/trainingdays/$trainingdayId';

  static String trainingdays(String uid) => 'users/$uid/trainingdays';
}
