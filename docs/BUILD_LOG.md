# Sankul Demo — Build Log

A clickable, front-end-only Flutter Web demo of the Sankul school management
platform, used as a sales tool in principals' offices. There is no backend:
all data is hardcoded seed data, and interactions update in-memory state that
resets on refresh.

- **Live site:** https://wrath-labs.github.io/sankul-demo/
- **Repo:** https://github.com/Wrath-Labs/sankul-demo
- **Status (15/09/2026):** foundation, login, admin shell and dashboard are
  done and deployed. The remaining screens are next.

---

## 1. What's done

### Project setup
- Flutter 3.45 (Dart 3.12). Targets are web (primary), macOS, Android and iOS.
- Dependencies: `flutter_riverpod` 3.4, `go_router` 17.5, `fl_chart` 1.2,
  `pdf` 3.13, `printing` 5.15 and `intl` 0.20.
- Inter font bundled in `assets/fonts/` (weights 400–800) and registered in
  `pubspec.yaml`.
- `flutter analyze` reports no issues.

### Folder structure
```
lib/
  config/      branding.dart (white-label), brand_assets.dart, demo_clock.dart
  models/      student, school_class, staff, fee, attendance, exam, communication, activity
  data/        seed data: classes, names, students, staff, fees, attendance, exams, communication, activity
  providers/   Riverpod state: session, school, fee, attendance, exam, communication, activity
  router/      routes.dart (paths), app_router.dart (go_router config)
  screens/     auth/login, admin/shell (sidebar, top bar), admin/dashboard, admin/fees (record payment dialog), common/
  widgets/     AppCard, KpiCard, StatusChip, DeltaBadge, SchoolLogo, InitialsAvatar, SegmentBar,
               SegmentedToggle, FadeBottom, ResponsiveRow/EqualGrid, StudentSearchField, charts/
  theme/       tokens.dart (spacing, radius, shadows, colours, text styles), app_theme.dart
  utils/       formatters.dart (₹ lakh formatting, DD/MM/YYYY, amount in words, relative time)
  pdf/         (empty; receipt and report-card PDFs go here)
test/          seed_data_test.dart (checks that the seed data is consistent)
scripts/       deploy_gh_pages.sh
```

### White-label branding
- Every school-specific value is in `lib/config/branding.dart`: name,
  tagline, address, phone, email, logo, three brand colours, school code
  (used in admission and receipt numbers), board, affiliation number and
  principal name.
- If `assets/logo.png` is missing, a monogram of the school's initials is
  drawn instead ("SPS").
- The sidebar and login text colour adapts if a school picks a light brand
  colour.

### Seed data (Sunrise Public School, Agra; CBSE, Nursery–XII)
| Item | Value |
|---|---|
| Students | 620 active (344 boys, 276 girls) across 32 sections, plus 2 with TC issued |
| Showcase classes | X-A (16), VIII-A (16), V-B (14): 46 hand-written, fully detailed profiles |
| Other classes | Generated from a fixed seed, with Indian names, parents, Agra addresses, admission nos. like `SPS/2019/0142` |
| Staff | 33 teachers; every section has a class teacher |
| Monthly fee billed | ₹21,21,400 (tuition ₹1,800–₹4,500/month by class, plus transport on 6 routes) |
| Collected this month | ₹10,66,700 month-to-date, including ₹1,53,900 today from 18 receipts (`SPS/26-27/04812` onward) |
| Fees pending | ₹2,47,050: 18 defaulters (₹1,81,900 overdue) and 22 students due this week (₹65,150) |
| Attendance today | 92.4%: 562 present, 11 late, 47 absent (7 named absentees or latecomers in the showcase classes) |
| Exam | Half-Yearly Examination 2026, with full subject-wise marks for X-A, VIII-A and V-B |
| Communication | 6 announcements, 6 SMS/WhatsApp templates, 15 delivery-log entries, 2,340 message credits |

Demo personas:
- **Parent:** Mr. Rajesh Sharma, father of Aarav (X-A) and Anaya (V-B), for
  the multi-child parent app.
- **Teacher:** Mr. Rakesh Verma, PGT Mathematics and class teacher of X-A.
- **Defaulters:** siblings Rohan (X-A) and Pari (V-B) Rajput are 4 months
  overdue.

### Screens built
- **Login:** a branded split screen with a role selector (Principal / Admin,
  Teacher, Parent). Any password is accepted. A "Powered by Sankul" link opens
  the Super Admin route.
- **Admin shell:**
  - Sidebar with a live defaulter badge, a user card and a "Demo Mode" note.
  - Top bar with the page title, school name, a search box, the date, a
    notification bell (3 items) and an account menu (switch to the Teacher or
    Parent view, sign out).
  - The sidebar collapses into a drawer below 1100px.
- **Dashboard:**
  - Four KPI cards with trend badges and segment bars.
  - Four quick actions.
  - Fee collection chart with a Monthly / By class toggle.
  - Attendance donut.
  - Recent activity feed, a "Fees due this week" list with one-click
    reminders, and upcoming events.
- **Record Payment dialog:**
  - Student search, fee head, amount, and mode (Cash / UPI / Cheque).
  - On success it issues the next receipt number and shows the amount in
    words.
  - It also updates the KPIs, the activity feed and the message log
    immediately.
  - The "View Receipt" button is wired up but hidden until the receipt PDF
    exists.

### Deployment
- GitHub Pages serves the `gh-pages` branch. That branch holds only the build
  output as a single commit, with no source code.
- `./scripts/deploy_gh_pages.sh` rebuilds with `--base-href /sankul-demo/` and
  `--no-web-resources-cdn`, then force-replaces `gh-pages`.
- Checked in headless Chrome: the build loads under `/sankul-demo/` with no
  console errors and no failed requests.

### Decisions and deviations from the original brief
- **Fonts are bundled, not loaded with `google_fonts`.** The demo then works
  offline, bold weights render properly, and the PDFs can use the same font
  (which includes the ₹ glyph).
- **"Collected this month" is month-to-date.** The fee scale in the brief
  implies about ₹21 L billed per month. The dashboard shows ₹10.67 L collected
  so far against that, with earlier months at ₹19–20 L, rather than a flat
  ₹10 L month that would read as 50% collection.
- **State uses Riverpod 3 `Notifier`s.** `StateNotifier` is legacy in
  Riverpod 3.
- **Hash URLs** (`/#/admin/dashboard`) are used so routing works on static
  hosting without server rewrites.
- **Seed dates are relative to the day the app is opened** (`DemoClock`), so
  "today", "2 mins ago" and due dates always look current. Fee-counter events
  are placed within school hours (9:30–15:30), and absence alerts go out at
  09:04.

---

## 2. What's next (in priority order)

Every unbuilt route currently shows a temporary `BuildQueueScreen`
("queued"). It must be gone before the demo is used with a principal.

1. **Fee Management** (`/admin/fees`), the #1 selling feature
   - Overview: collected, pending, today's collection, and collection by class.
   - Student fee table: search, class filter, and Paid / Partial / Overdue
     chips.
   - Defaulter report: filters for class and days overdue, sort by amount, and
     "Send Reminder to All" (a snackbar and message-log entries). Handle the
     `?tab=defaulters` link from the dashboard.
   - Receipt PDF in `lib/pdf/` (built with `pdf` + `printing`): letterhead from
     `Branding`, receipt number, amount in words and a signature line. Wire the
     "View Receipt" button on the payment success dialog.
   - Daily collection report: today's payments by mode, with a total.
2. **Exams & Report Cards** (`/admin/exams`), the "wow" moment
   - Editable marks-entry grid for X-A that recalculates total, percentage,
     grade and rank live. `marksProvider` and `classResultsProvider` already
     exist.
   - Report-card PDF, for one student or a whole class (multi-page):
     letterhead, photo placeholder, marks table, class-highest column, CBSE
     grading scale, co-scholastic grades, attendance, remarks and signature
     lines.
3. **Communication** (`/admin/communication`)
   - Announcements list and a Compose screen with an audience picker.
     `sendAnnouncement` already exists.
   - Editable SMS/WhatsApp templates with the `{{variables}}` highlighted.
   - Delivery log table.
   - Message-credits card with a "Buy More" pricing dialog.
4. **Students & Staff**
   - Student directory with search, class/section filter, card or table view,
     and status chips. Read `?q=` from the top-bar search.
   - "Import from Excel" modal with a CSV template and an import preview.
   - Student profile: personal and guardian details, attendance, fee status
     and latest result.
   - Staff directory.
5. **Attendance**
   - Mark attendance: Present / Absent / Late toggles, "Mark all present", and
     Save with an "Absence SMS sent to N parents" confirmation. Use
     `todayAttendanceProvider.saveClass`.
   - Monthly register grid with each student's percentage, and a fake Export.
6. **Timetable:** add seed data, a weekly grid per class, and each teacher's
   own schedule.
7. **Parent app** (`/parent`), inside a phone frame
   - Home with a switcher between the two children, a fee-due card with Pay
     Now (a fake Razorpay success), today's attendance and the latest
     announcement.
   - Attendance, Results (report card), Fees and Notifications tabs.
8. **Teacher view** (`/teacher`): Mr. Rakesh Verma's class, attendance, marks
   entry and timetable.
9. **Super Admin** (`/super-admin`), low priority: school list with MRR, and a
   "Create New School" form with the branding fields.
10. **Wrap-up**
    - Delete `BuildQueueScreen`.
    - Replace the default Flutter `README.md` with: how to run it, how to
      rebrand in `branding.dart`, and the 5-minute demo click-path.
    - Test at 1366×768, then redeploy.

### Known loose ends
- Some dashboard figures are fixed values rather than calculated: the
  students ↑3.2%, pending ↓4.6% and attendance-yesterday 91.3% deltas, and the
  three notification-bell items.
- The Diwali (07–11/11/2026) and Annual Day (19/12/2026) dates are fixed to
  2026.
- The web app's favicon and `manifest.json` are still the Flutter defaults.

---

## 3. Commands

```bash
flutter run -d chrome                  # run locally
flutter test                           # seed-data consistency test
flutter analyze                        # static checks
./scripts/deploy_gh_pages.sh           # build + publish to GitHub Pages
```
