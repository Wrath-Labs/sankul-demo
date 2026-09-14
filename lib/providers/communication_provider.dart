import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/communication.dart';
import '../models/activity.dart';
import '../models/communication.dart';
import '../models/student.dart';
import 'activity_provider.dart';

class CommunicationState {
  const CommunicationState({
    required this.announcements,
    required this.log,
    required this.templates,
    required this.credits,
  });

  final List<Announcement> announcements;
  final List<MessageLog> log;
  final List<MessageTemplate> templates;
  final int credits;

  CommunicationState copyWith({
    List<Announcement>? announcements,
    List<MessageLog>? log,
    List<MessageTemplate>? templates,
    int? credits,
  }) =>
      CommunicationState(
        announcements: announcements ?? this.announcements,
        log: log ?? this.log,
        templates: templates ?? this.templates,
        credits: credits ?? this.credits,
      );
}

var _logCounter = 1000;

/// A message to a student's parent, stamped now.
MessageLog parentMessage(Student s, Channel channel, String template,
        {DeliveryStatus status = DeliveryStatus.delivered}) =>
    MessageLog(
      id: 'm${_logCounter++}',
      recipient: 'Mr. ${s.fatherName}',
      context: 'Parent · ${s.name} (${s.classId})',
      phone: s.phone,
      channel: channel,
      template: template,
      status: status,
      sentAt: DateTime.now(),
    );

class CommunicationNotifier extends Notifier<CommunicationState> {
  @override
  CommunicationState build() => CommunicationState(
        announcements: List.of(seedAnnouncements),
        log: List.of(seedMessageLog),
        templates: List.of(seedTemplates),
        credits: seedMessageCredits,
      );

  void sendAnnouncement(Announcement a) {
    final cost = a.channels.contains(Channel.sms) ? a.recipients : 0;
    state = state.copyWith(
      announcements: [a, ...state.announcements],
      credits: math.max(0, state.credits - cost),
    );
    ref.read(activityProvider.notifier).add(ActivityItem(
          type: ActivityType.announcement,
          title: 'Announcement sent · ${a.title}',
          subtitle: 'Delivered to ${a.recipients} ${a.recipients == 1 ? 'recipient' : 'parents'}',
          time: DateTime.now(),
        ));
  }

  /// Records outgoing messages; SMS consumes one credit each.
  void logMessages(List<MessageLog> entries) {
    final cost = entries.where((e) => e.channel == Channel.sms).length;
    state = state.copyWith(
      log: [...entries, ...state.log],
      credits: math.max(0, state.credits - cost),
    );
  }

  void updateTemplate(String id, String body) {
    state = state.copyWith(templates: [
      for (final t in state.templates) t.id == id ? t.copyWith(body: body) : t,
    ]);
  }

  void addCredits(int credits) =>
      state = state.copyWith(credits: state.credits + credits);
}

final communicationProvider =
    NotifierProvider<CommunicationNotifier, CommunicationState>(
        CommunicationNotifier.new);
