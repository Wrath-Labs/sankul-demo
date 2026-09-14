enum Channel { sms, whatsapp, app }

extension ChannelX on Channel {
  String get label => switch (this) {
        Channel.sms => 'SMS',
        Channel.whatsapp => 'WhatsApp',
        Channel.app => 'App',
      };
}

enum DeliveryStatus { delivered, failed, pending }

enum AnnouncementCategory { event, holiday, fee, academic }

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.audience,
    required this.channels,
    required this.sentAt,
    required this.sentBy,
    required this.recipients,
    required this.category,
  });

  final String id;
  final String title;
  final String body;

  /// Human-readable audience, e.g. "Whole school" or "Class X-A".
  final String audience;
  final Set<Channel> channels;
  final DateTime sentAt;
  final String sentBy;
  final int recipients;
  final AnnouncementCategory category;
}

class MessageTemplate {
  const MessageTemplate({
    required this.id,
    required this.name,
    required this.body,
    required this.channels,
    this.dltId,
  });

  final String id;
  final String name;

  /// Body with {{variable}} placeholders.
  final String body;
  final Set<Channel> channels;

  /// TRAI DLT template registration id (required for SMS in India).
  final String? dltId;

  List<String> get variables => RegExp(r'\{\{(\w+)\}\}')
      .allMatches(body)
      .map((m) => m.group(1)!)
      .toSet()
      .toList();

  MessageTemplate copyWith({String? body}) => MessageTemplate(
        id: id,
        name: name,
        body: body ?? this.body,
        channels: channels,
        dltId: dltId,
      );
}

class MessageLog {
  const MessageLog({
    required this.id,
    required this.recipient,
    required this.context,
    required this.phone,
    required this.channel,
    required this.template,
    required this.status,
    required this.sentAt,
    this.failureReason,
  });

  final String id;

  /// "Mr. Rajesh Sharma"
  final String recipient;

  /// "Parent · Aarav Sharma (X-A)"
  final String context;
  final String phone;
  final Channel channel;
  final String template;
  final DeliveryStatus status;
  final DateTime sentAt;
  final String? failureReason;
}

class SchoolEvent {
  const SchoolEvent(this.title, this.date, this.detail, this.category);
  final String title;
  final DateTime date;
  final String detail;
  final AnnouncementCategory category;
}
