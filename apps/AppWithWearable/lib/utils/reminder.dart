import 'dart:math';
import 'package:friend_private/backend/api_requests/api_calls.dart';
import 'package:friend_private/utils/notifications.dart';
import 'package:reminders/reminders.dart';

Future<String> checkReminderAndSend(String transcript) async {
  final reminderRegex = RegExp(r'\bremind me\b|\bi need to\b', caseSensitive: false);
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
    String reminderText = await executeGpt4oPrompt(prompt);



    if (reminderText.isNotEmpty) {
      // Initialize the reminders plugin
      final Reminders reminders = Reminders();
      // Request permission to access reminders
      bool permissionGranted = await reminders.requestPermission();
      if (permissionGranted) {
        // Check if we have access to reminders
        if (await reminders.hasAccess()) {
          // Get the default list ID to add the reminder to
          String? defaultListId = await reminders.getDefaultListId();
          // Create a new reminder
          Reminder newReminder = Reminder(
            title: reminderText, // Use the extracted reminder text as the title
            list: RemList(defaultListId), // Assuming RemList has a constructor accepting an ID
            // Set other attributes as needed, e.g., dueDate, notes, etc.
          );
          // Save the reminder
          await reminders.saveReminder(newReminder);
        }
      }

      // Send the reminder as a notification or handle it as needed
      int randomId = Random().nextInt(0x7FFFFFFF);
      createNotification(title: 'Reminder: $reminderText', body: reminderText, notificationId: randomId);
    
    
    
    }
  }
  return '';
}