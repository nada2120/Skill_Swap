import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../book_session/screens/book_session.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../models/details_model.dart';

class SessionDetailsPage extends StatelessWidget {
  final SessionModel session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Session Details',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
        leading: IconButton(
          onPressed: () {
            final didGoBack = desktopKey.currentState?.goBack();
            if (didGoBack == false) {
              desktopKey.currentState?.openPage(index: 0);
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Mentor Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    session.mentorImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.mentorName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.mentorTrack,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        onPressed: () {
                          desktopKey.currentState?.openSidePage(
                              body: ProfileMentorDesktop(
                                id: session.mentorId,
                                image: session.mentorImage,
                                name: session.mentorName,
                                track: session.mentorTrack,
                                rate: session.rating,
                                bio: '',
                                role: '',
                                hoursAvailable: 0,
                                peopleHelped: 0,
                                hourlyRate: 0,
                                skills: [],
                                reviews: [],
                              ),
                              rightPanel: BookSessionDesktop(
                                userId: session.mentorId,
                                userName: session.mentorName,
                                price: 0,
                                role: '',
                                availableDates: [],
                              ));
                        },
                        icon: const Icon(Icons.person_outline),
                        label: const Text('View Profile'),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Finished',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Session Summary
            Text(
              'Session Summary',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: 16),

            infoRow(
              context,
              Icons.calendar_today,
              'Date',
              '${session.date.day}-${session.date.month}-${session.date.year}',
            ),
            infoRow(context, Icons.access_time, 'Time', session.time),
            infoRow(
              context,
              Icons.timer_outlined,
              'Duration',
              '${session.duration} min',
            ),

            const Divider(height: 32),

            /// Session Notes
            Text(
              'Session Notes',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: 8),
            Text(
              session.notes,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),

            const Divider(height: 32),

            /// Session Conclusion
            Text(
              'Session Conclusion',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: 8),
            Text(
              'The session ended earlier than expected!',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),

            const Divider(height: 32),

            /// Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Rating',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Rating'),
                ),
              ],
            ),

            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < session.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                // Text(
                //   session.review,
                //   style: const TextStyle(color: Colors.grey),
                // ),
              ],
            ),

            const Divider(height: 32),

            /// Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: 12),

            actionTile(context, Icons.calendar_today, 'Rebook Session'),
            //_actionTile(Icons.attach_file, 'View Attachments'),
            //_actionTile(Icons.history, 'Session History'),
          ],
        ),
      ),
    );
  }

  /// Helpers
  Widget infoRow(
      BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).textTheme.bodyMedium!.color),
          const SizedBox(width: 12),
          Expanded(
              child: Text(
            title,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
          )),
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ],
      ),
    );
  }

  Widget actionTile(BuildContext context, IconData icon, String title) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xffEEEEEE)),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: Theme.of(context).textTheme.bodyMedium!.color),
        title: Text(
          title,
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
        onTap: () {
          desktopKey.currentState?.openSidePage(
              body: ProfileMentorDesktop(
                id: session.mentorId,
                image: session.mentorImage,
                name: session.mentorName,
                track: session.mentorTrack,
                rate: session.rating,
                bio: '',
                role: '',
                hoursAvailable: 0,
                peopleHelped: 0,
                hourlyRate: 0,
                skills: [],
                reviews: [],
              ),
              rightPanel: BookSessionDesktop(
                userId: session.mentorId,
                userName: session.mentorName,
                role: '',
                price: 0,
                availableDates: [],
              ));
        },
      ),
    );
  }
}
