import 'package:app_with_wearable/backend/api_requests/api_calls.dart';
import 'package:app_with_wearable/utils/notification.dart';

Future<String> checkReminderAndSend(String transcript) async {
  const reminderRegex = RegExp(r'\bremind me\b|\bI need to\b', caseSensitive: false);
  // Check for specific phrases in the transcript
  if (reminderRegex.hasMatch(transcript)) {
    var prompt = '''
      Extract a reminder from the following transcript:
      ```
      $transcript
      ```
      Please format the reminder in a concise sentence.
    ''';

    // Call OpenAI to process the extraction
    String reminder = await executeGptPrompt(prompt);
    if (reminder.isNotEmpty) {
      // Send the reminder as a notification or handle it as needed
      const timeId = new DateTime.now().millisecondsSinceEpoch;
      createNotification({ title: 'Reminder', body: reminder, id: timeId });
    }
  }
  return '';
}

