//---------------------email author --------------------
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  final String username;
  final String password;

  EmailService({required this.username, required this.password});

  Future<void> sendEmail(String to, String subject, String body) async {
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Jonk Laboratories Services')
      ..recipients.add(to)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. Error: $e');
    }
  }
}
