enum OpportunityType { internship, job, competition, grant, scholarship, fellowship, program, volunteer }

class OpportunityModel {
  final String id;
  final String title;
  final String description;
  final String company;
  final String imageUrl;
  final OpportunityType type;
  final List<String> categories;
  final String deadline;
  final String location;
  final String compensation;
  final List<String> skills;
  final bool isRemote;
  final String applicationUrl;
  final int applicantCount;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.imageUrl,
    required this.type,
    required this.categories,
    required this.deadline,
    required this.location,
    required this.compensation,
    required this.skills,
    required this.isRemote,
    this.applicationUrl = '',
    required this.applicantCount,
  });

  String get typeLabel {
    switch (type) {
      case OpportunityType.internship:
        return 'Internship';
      case OpportunityType.job:
        return 'Job';
      case OpportunityType.competition:
        return 'Competition';
      case OpportunityType.grant:
        return 'Grant';
      case OpportunityType.scholarship:
        return 'Scholarship';
      case OpportunityType.fellowship:
        return 'Fellowship';
      case OpportunityType.program:
        return 'Program';
      case OpportunityType.volunteer:
        return 'Volunteer';
    }
  }
}
