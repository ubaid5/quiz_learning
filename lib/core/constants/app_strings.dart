class AppStrings {
  // App Info
  static const String appName = 'Quiz Learning';
  
  // Home Screen
  static const String quizCategories = 'Quiz Categories';
  static const String rank = 'Rank';
  static const String score = 'Score';
  static const String completed = 'Completed';
  static const String progress = 'Progress';
  
  // Countdown Screen
  static const String getReady = 'Get Ready!';
  
  // Quiz Screen
  static const String question = 'Question';
  static const String multipleChoice = 'Multiple Choice';
  static const String trueFalse = 'True/False';
  static const String timeRemaining = 'Time Remaining';
  static const String submitAnswer = 'Submit Answer';
  static const String nextQuestion = 'Next Question';
  static const String viewResults = 'View Results';
  
  // Feedback Messages
  static const String feedbackCorrect = 'Correct! Well done! 🎉';
  static const String feedbackIncorrect = 'Incorrect. Try the next one! 💪';
  
  // Exit Dialog
  static const String exitQuiz = 'Exit Quiz?';
  static const String exitQuizMessage = 'Your progress will be lost. Are you sure you want to exit?';
  static const String cancel = 'Cancel';
  static const String exit = 'Exit';
  
  // Result Screen
  static const String greatJob = 'Great Job!';
  static const String keepLearning = 'Keep Learning!';
  static const String scoreLabel = 'Score';
  static const String correct = 'Correct';
  static const String incorrect = 'Incorrect';
  static const String total = 'Total';
  static const String pointsEarned = 'Points Earned';
  static const String backToHome = 'Back to Home';
  
  // Category Card
  static const String difficulty = 'Difficulty';
  
  // Emojis
  static const String emojiTrophy = '🏆';
  static const String emojiStar = '⭐';
  static const String emojiChart = '📊';
  static const String emojiCheckMark = '✅';
  static const String emojiCross = '❌';
  static const String emojiParty = '🎉';
  static const String emojiBook = '📚';
  
  // Time format
  static String secondsFormat(int seconds) => '${seconds}s';
  static String progressFormat(int current, int total) => '$current/$total';
  static String questionFormat(int current, int total) => 'Question $current/$total';
  static String percentageFormat(int percentage) => '$percentage%';
  static String rankFormat(int rank) => '#$rank';
  static String pointsFormat(int points) => '+$points';
  static String difficultyFormat(String difficulty) => 'Difficulty: ${difficulty.toUpperCase()}';
}

