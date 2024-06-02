import 'dart:math';
import 'package:friend_private/backend/api_requests/api_calls.dart';
import 'package:friend_private/utils/notifications.dart';

Future<String> checkReminderAndSend(String transcript) async {
  final reminderRegex =
      RegExp(r'\bremind me\b|\bi need to\b', caseSensitive: false);
  // Check for specific phrases in the transcript
  if (reminderRegex.hasMatch(transcript)) {
    String prompt = '''
      Extract a reminder from the following transcript:
      ```
      $transcript
      ```
      Please format the reminder in a concise sentence.
    ''';

    // Call OpenAI to process the extraction
    String reminder = await executeGpt4oPrompt(prompt);

    if (reminder.isNotEmpty) {
      // Send the reminder as a notification or handle it as needed
      int randomId = Random().nextInt(0x7FFFFFFF);
      createNotification(
          title: 'Reminder: $reminder',
          body: reminder,
          notificationId: randomId);
    }
  }
  return '';
}
