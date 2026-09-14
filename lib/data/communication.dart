import '../config/branding.dart';
import '../config/demo_clock.dart';
import '../models/communication.dart';
import '../utils/formatters.dart';
import 'exams.dart';
import 'students.dart';

const int seedMessageCredits = 2340;

/// Unique parent households (siblings share a number).
const int parentHouseholds = 598;

DateTime get ptmDate => DemoClock.nextWeekday(DateTime.saturday);
/// Last date for this quarter's fee — never a Sunday.
DateTime get feeLastDate {
  final d = DemoClock.daysFromNow(6);
  return d.weekday == DateTime.sunday ? d.add(const Duration(days: 1)) : d;
}

final List<Announcement> seedAnnouncements = [
  Announcement(
    id: 'a1',
    title: 'Parent–Teacher Meeting · Half-Yearly Results',
    body:
        'Dear Parents, a Parent–Teacher Meeting will be held on ${Fmt.shortWeekdayDate(ptmDate)} from 9:00 AM to 12:30 PM in the respective classrooms. Half-yearly report cards will be handed over at the meeting. Kindly bring your ward\'s ID card.',
    audience: 'Classes I – XII',
    channels: {Channel.sms, Channel.whatsapp, Channel.app},
    sentAt: DemoClock.daysAgo(1, hour: 17, minute: 30),
    sentBy: Branding.principalName,
    recipients: 509,
    category: AnnouncementCategory.academic,
  ),
  Announcement(
    id: 'a2',
    title: 'Fee Reminder · Q2 (Jul – Sep)',
    body:
        'Dear Parent, this is a gentle reminder that second-quarter fees are due by ${Fmt.date(feeLastDate)}. You can pay at the school accounts office or instantly through the ${Branding.schoolName} parent app. Kindly ignore if already paid.',
    audience: 'Parents with pending dues',
    channels: {Channel.sms, Channel.whatsapp},
    sentAt: DemoClock.daysAgo(2, hour: 11, minute: 5),
    sentBy: 'Accounts Office',
    recipients: 40,
    category: AnnouncementCategory.fee,
  ),
  Announcement(
    id: 'a3',
    title: 'Diwali Vacation',
    body:
        'The school will remain closed from Saturday, 07/11/2026 to Wednesday, 11/11/2026 on account of Diwali, Govardhan Puja and Bhai Dooj. Classes will resume on Thursday, 12/11/2026. Wishing all our families a safe and joyous Diwali!',
    audience: 'Whole school',
    channels: {Channel.sms, Channel.whatsapp, Channel.app},
    sentAt: DemoClock.daysAgo(4, hour: 13, minute: 15),
    sentBy: Branding.principalName,
    recipients: parentHouseholds,
    category: AnnouncementCategory.holiday,
  ),
  Announcement(
    id: 'a4',
    title: 'Annual Day “Utsav 2026” · Save the Date',
    body:
        'We are delighted to announce that our Annual Day, Utsav 2026, will be held on Saturday, 19/12/2026 at the school auditorium from 5:00 PM onwards. Rehearsals begin in November; parents of participating students will receive a separate schedule.',
    audience: 'Whole school',
    channels: {Channel.whatsapp, Channel.app},
    sentAt: DemoClock.daysAgo(7, hour: 10, minute: 30),
    sentBy: Branding.principalName,
    recipients: parentHouseholds,
    category: AnnouncementCategory.event,
  ),
  Announcement(
    id: 'a5',
    title: 'Inter-House Science Quiz',
    body:
        'The Inter-House Science Quiz for Classes VI – X will be held on ${Fmt.date(DemoClock.daysFromNow(11))} in the school auditorium. Each house will field a team of four. Names to be submitted to the class teacher by Friday.',
    audience: 'Classes VI – X',
    channels: {Channel.app},
    sentAt: DemoClock.daysAgo(9, hour: 12, minute: 40),
    sentBy: 'Mrs. Kavita Saxena',
    recipients: 223,
    category: AnnouncementCategory.event,
  ),
  Announcement(
    id: 'a6',
    title: 'Half-Yearly Examination Date Sheet',
    body:
        'The Half-Yearly Examinations will commence from ${Fmt.date(halfYearlyExam.startDate)}. The detailed date sheet is available in the parent app. Students must carry their admit cards on all examination days.',
    audience: 'Classes III – XII',
    channels: {Channel.sms, Channel.whatsapp, Channel.app},
    sentAt: DemoClock.daysAgo(33, hour: 12, minute: 0),
    sentBy: 'Examination Cell',
    recipients: 422,
    category: AnnouncementCategory.academic,
  ),
];

final List<SchoolEvent> seedEvents = [
  SchoolEvent('Parent–Teacher Meeting', ptmDate, '9:00 AM – 12:30 PM · Report cards distributed', AnnouncementCategory.academic),
  SchoolEvent('Q2 Fee — Last Date', feeLastDate, 'Late fine of ₹200 applies after this date', AnnouncementCategory.fee),
  SchoolEvent('Inter-House Science Quiz', DemoClock.daysFromNow(11), 'Auditorium · Classes VI – X', AnnouncementCategory.event),
  SchoolEvent('Diwali Vacation', DateTime(2026, 11, 7), '07/11 – 11/11 · School closed', AnnouncementCategory.holiday),
  SchoolEvent('Annual Day · Utsav 2026', DateTime(2026, 12, 19), 'School auditorium · 5:00 PM', AnnouncementCategory.event),
];

final List<MessageTemplate> seedTemplates = [
  const MessageTemplate(
    id: 'fee_reminder',
    name: 'Fee Reminder',
    body: 'Dear Parent, fee of ₹{{amount}} for {{student_name}} ({{class}}) is due on {{due_date}}. Pay online via the {{school_name}} app or at the school office. Kindly ignore if already paid. - {{school_name}}',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078901',
  ),
  const MessageTemplate(
    id: 'absence_alert',
    name: 'Absence Alert',
    body: 'Dear Parent, {{student_name}} ({{class}}) was marked ABSENT today, {{date}}. If this is unexpected, please contact the school office at {{school_phone}}. - {{school_name}}',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078922',
  ),
  const MessageTemplate(
    id: 'exam_schedule',
    name: 'Exam Schedule',
    body: 'Dear Parent, the {{exam_name}} for Class {{class}} begins on {{start_date}}. The full date sheet is available in the {{school_name}} app. Please ensure your ward carries the admit card daily.',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078937',
  ),
  const MessageTemplate(
    id: 'holiday',
    name: 'Holiday Notice',
    body: 'Dear Parent, the school will remain closed on {{date}} on account of {{occasion}}. Classes will resume on {{resume_date}}. - {{school_name}}',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078945',
  ),
  const MessageTemplate(
    id: 'result_published',
    name: 'Result Published',
    body: 'Dear Parent, the {{exam_name}} result of {{student_name}} ({{class}}) has been published. Score: {{percentage}}% (Grade {{grade}}). View the full report card in the {{school_name}} app.',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078958',
  ),
  const MessageTemplate(
    id: 'ptm',
    name: 'PTM Invitation',
    body: 'Dear Parent, a Parent-Teacher Meeting is scheduled on {{date}} from {{time}}. Your presence is requested to discuss {{student_name}}\'s progress. - {{school_name}}',
    channels: {Channel.sms, Channel.whatsapp},
    dltId: '1207168934512078966',
  ),
];

/// Values substituted for {{variables}} in template previews.
Map<String, String> templateSampleValues() {
  final aarav = studentNamed('Aarav Sharma');
  return {
    'amount': '5,200',
    'student_name': aarav.firstName,
    'class': aarav.classId,
    'due_date': Fmt.date(feeLastDate),
    'date': Fmt.date(DemoClock.today),
    'school_name': Branding.schoolName,
    'school_phone': Branding.schoolPhone,
    'exam_name': halfYearlyExam.name,
    'start_date': Fmt.date(halfYearlyExam.startDate),
    'occasion': 'Diwali',
    'resume_date': '12/11/2026',
    'percentage': '87.2',
    'grade': 'A2',
    'time': '9:00 AM to 12:30 PM',
  };
}

final List<MessageLog> seedMessageLog = _buildLog();

List<MessageLog> _buildLog() {
  var n = 0;
  MessageLog log(String studentName, Channel channel, String template,
      DateTime at,
      {DeliveryStatus status = DeliveryStatus.delivered, String? reason}) {
    final s = studentNamed(studentName);
    return MessageLog(
      id: 'm${++n}',
      recipient: 'Mr. ${s.fatherName}',
      context: 'Parent · ${s.name} (${s.classId})',
      phone: s.phone,
      channel: channel,
      template: template,
      status: status,
      sentAt: at,
      failureReason: reason,
    );
  }

  final yesterdayPtm = DemoClock.daysAgo(1, hour: 17, minute: 31);
  final feeRun = DemoClock.schoolMinutesAgo(95);
  DateTime alert(int minute) => DemoClock.todayAt(9, minute);
  return [
    log('Nandini Goyal', Channel.whatsapp, 'Fee Receipt', DemoClock.schoolMinutesAgo(18)),
    log('Harshit Yadav', Channel.sms, 'Absence Alert', alert(4)),
    log('Riya Chauhan', Channel.sms, 'Absence Alert', alert(4)),
    log('Yash Kapoor', Channel.whatsapp, 'Absence Alert', alert(4)),
    log('Myra Jain', Channel.sms, 'Absence Alert', alert(4),
        status: DeliveryStatus.failed, reason: 'Handset unreachable'),
    log('Myra Jain', Channel.whatsapp, 'Absence Alert', alert(5)),
    log('Om Tiwari', Channel.sms, 'Absence Alert', alert(5)),
    log('Rohan Rajput', Channel.whatsapp, 'Fee Reminder', feeRun),
    log('Pari Rajput', Channel.sms, 'Fee Reminder', feeRun),
    log('Kunal Saxena', Channel.whatsapp, 'Fee Reminder', feeRun,
        status: DeliveryStatus.failed, reason: 'Number not on WhatsApp'),
    log('Kunal Saxena', Channel.sms, 'Fee Reminder', feeRun.add(const Duration(minutes: 1))),
    log('Saanvi Agarwal', Channel.whatsapp, 'PTM Invitation', yesterdayPtm),
    log('Ananya Gupta', Channel.sms, 'PTM Invitation', yesterdayPtm),
    log('Kabir Khan', Channel.sms, 'PTM Invitation', yesterdayPtm,
        status: DeliveryStatus.failed, reason: 'Invalid number'),
    log('Aarav Sharma', Channel.whatsapp, 'Fee Reminder', DemoClock.daysAgo(2, hour: 11, minute: 6)),
  ];
}
