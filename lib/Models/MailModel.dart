import 'dart:convert';

class Email {
  final String body;
  final String id;
  final String sender;
  final String subject;
  final String time;

  const Email({
    required this.body,
    required this.id,
    required this.sender,
    required this.subject,
    required this.time,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      body: json['body'] as String,
      id: json['id'] as String,
      sender: json['sender'] as String,
      subject: json['subject'] as String,
      time: json['time'] as String,
    );
  }
  static Map<String, dynamic> toMap(Email email) => {
        'body': email.body,
        'id': email.id,
        'sender': email.sender,
        'subject': email.subject,
        'time': email.time,
      };

  static String encode(List<Email> emails) => json.encode(
        emails
            .map<Map<String, dynamic>>((email) => Email.toMap(email))
            .toList(),
      );

  static List<Email> decode(String emails) =>
      (json.decode(emails) as List<dynamic>)
          .map<Email>((item) => Email.fromJson(item))
          .toList();
}
