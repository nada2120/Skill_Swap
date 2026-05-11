import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../book_session/screens/profile_mentor.dart';
import '../models/details_model.dart';

class SessionDetailsPage extends StatelessWidget {
  final SessionModel session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
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
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
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
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                        ),
                        const SizedBox(height: 4),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.to(ProfileMentor(
                              id: session.mentorId,
                              image: session.mentorImage,
                              name: session.mentorName,
                              track: session.mentorTrack,
                              rate: session.rating,
                              bio: session.bio,
                              skills: session.skills,
                              hoursAvailable: 0,
                              peopleHelped: 0,
                              hourlyRate: 0,
                              reviews: [],
                              role: '',
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

              SizedBox(height: screenHeight * 0.015),

              /// Session Summary
              Text(
                'Session Summary',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
              SizedBox(height: screenHeight * 0.02),

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
              SizedBox(height: screenHeight * 0.015),

              actionTile(context, Icons.calendar_today, 'Rebook Session'),
            ],
          ),
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
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
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
          // Get.to(BookSessionScreen(
          //   userId: session.mentorId,
          //   userName: session.mentorName,
          //   price: 100,
          // ));
        },
      ),
    );
  }
}
