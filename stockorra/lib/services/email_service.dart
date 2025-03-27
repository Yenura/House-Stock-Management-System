import 'dart:io';

class EmailService {
  Future<void> sendReportEmail({
    required String recipientEmail,
    required File attachment,
    required String userName,
  }) async {
    // TODO: Implement email sending functionality
    await Future.delayed(const Duration(seconds: 2));
  }
}
