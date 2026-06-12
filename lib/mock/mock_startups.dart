import '../shared/models/startup_model.dart';
import '../core/constants/image_constants.dart';

class MockStartups {
  static final List<StartupModel> startups = [
    StartupModel(
      id: 'startup_001',
      name: 'EduBridge',
      tagline: 'Making quality education accessible across Africa',
      description:
          'EduBridge connects African students in rural areas to quality digital learning through offline-first technology and peer mentorship. We\'ve reached 5,000 students across 3 countries.',
      logoUrl: ImageConstants.startupEdutech,
      tags: ['Education', 'Technology', 'Social Impact'],
      founderName: 'Fatima Ndiaye',
      founderAvatar: ImageConstants.avatar3,
      founderId: 'user_003',
      stage: 'Seed',
      openRoles: ['Full-Stack Developer', 'UX Designer', 'Growth Marketer'],
      isLookingForCofounder: true,
      campus: 'Mauritius',
      teamSize: 3,
    ),
    StartupModel(
      id: 'startup_002',
      name: 'AgriSense',
      tagline: 'AI-powered crop monitoring for smallholder farmers',
      description:
          'AgriSense uses computer vision and IoT sensors to help smallholder farmers in East Africa detect crop disease early, optimize irrigation, and increase yields by 40%.',
      logoUrl: ImageConstants.startupAgritech,
      tags: ['AI & Machine Learning', 'Sustainability', 'Social Impact', 'Engineering'],
      founderName: 'Chidi Okonkwo',
      founderAvatar: ImageConstants.avatar4,
      founderId: 'user_004',
      stage: 'Pre-seed',
      openRoles: ['Machine Learning Engineer', 'Hardware Engineer'],
      isLookingForCofounder: false,
      campus: 'Kigali',
      teamSize: 4,
    ),
    StartupModel(
      id: 'startup_003',
      name: 'PayFlow',
      tagline: 'Cross-border payments made simple for SMEs',
      description:
          'PayFlow enables African SMEs to send and receive cross-border payments instantly with low fees. Processing \$2M/month across 8 African countries with 300+ business customers.',
      logoUrl: ImageConstants.startupFintech,
      tags: ['Finance', 'Technology', 'Entrepreneurship'],
      founderName: 'Kwame Asante',
      founderAvatar: ImageConstants.avatar2,
      founderId: 'user_002',
      stage: 'Series A',
      openRoles: ['Backend Engineer', 'Compliance Manager'],
      isLookingForCofounder: false,
      campus: 'Kigali',
      teamSize: 8,
    ),
    StartupModel(
      id: 'startup_004',
      name: 'HealthPulse',
      tagline: 'Remote diagnostics for community health workers',
      description:
          'HealthPulse equips community health workers with AI-powered diagnostic tools via mobile app, enabling early detection of malaria, TB, and hypertension in underserved areas.',
      logoUrl: ImageConstants.startupHealth,
      tags: ['Healthcare', 'AI & Machine Learning', 'Social Impact'],
      founderName: 'Aisha Mensah',
      founderAvatar: ImageConstants.avatar5,
      founderId: 'user_005',
      stage: 'Pre-seed',
      openRoles: ['Medical Advisor', 'Flutter Developer', 'Data Scientist'],
      isLookingForCofounder: true,
      campus: 'Mauritius',
      teamSize: 2,
    ),
  ];

  static final List<CollaborationRequestModel> collaborationRequests = [
    CollaborationRequestModel(
      id: 'collab_001',
      userId: 'user_003',
      userName: 'Fatima Ndiaye',
      userAvatar: ImageConstants.avatar3,
      role: 'Looking for Co-Founder (Tech)',
      description:
          'Building EduBridge and need a technical co-founder. You should be a strong full-stack developer with passion for education and impact. Equity available.',
      skills: ['React Native', 'Node.js', 'Firebase', 'Product Management'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      isActive: true,
    ),
    CollaborationRequestModel(
      id: 'collab_002',
      userId: 'user_004',
      userName: 'Chidi Okonkwo',
      userAvatar: ImageConstants.avatar4,
      role: 'Looking for Machine Learning Engineer',
      description:
          'AgriSense is hiring a part-time ML engineer to improve our crop disease detection model. Great learning opportunity with potential to join full-time post-graduation.',
      skills: ['Python', 'TensorFlow', 'Computer Vision', 'Edge ML'],
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      isActive: true,
    ),
    CollaborationRequestModel(
      id: 'collab_003',
      userId: 'user_005',
      userName: 'Aisha Mensah',
      userAvatar: ImageConstants.avatar5,
      role: 'Looking for Research Partner',
      description:
          'Working on a UX research project analyzing design patterns in African health apps. Looking for a co-researcher for a 3-month study. Could turn into a publication.',
      skills: ['User Research', 'Data Analysis', 'Academic Writing'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
    ),
    CollaborationRequestModel(
      id: 'collab_004',
      userId: 'user_002',
      userName: 'Kwame Asante',
      userAvatar: ImageConstants.avatar2,
      role: 'Looking for UI/UX Designer',
      description:
          'PayFlow is revamping our mobile app and needs a talented designer for a 2-month contract. Great for your portfolio — we have 300+ users who will see your work.',
      skills: ['Figma', 'UI Design', 'User Testing', 'Design Systems'],
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      isActive: true,
    ),
  ];

  static final List<BadgeModelSimple> badges = [
    const BadgeModelSimple(
      id: 'badge_001',
      name: 'Early Adopter',
      emoji: '🚀',
      description: 'One of the first students on ALU Connect',
    ),
    const BadgeModelSimple(
      id: 'badge_002',
      name: 'Community Builder',
      emoji: '👥',
      description: 'Joined 3 or more communities',
    ),
    const BadgeModelSimple(
      id: 'badge_003',
      name: 'Event Enthusiast',
      emoji: '🎉',
      description: 'Attended 10 or more events',
    ),
    const BadgeModelSimple(
      id: 'badge_004',
      name: 'Startup Founder',
      emoji: '💡',
      description: 'Launched a startup on ALU Connect',
    ),
    const BadgeModelSimple(
      id: 'badge_005',
      name: 'Impact Champion',
      emoji: '🌍',
      description: 'Participated in a community impact project',
    ),
    const BadgeModelSimple(
      id: 'badge_006',
      name: 'Hackathon Hero',
      emoji: '⚡',
      description: 'Participated in ALU Hackathon',
    ),
    const BadgeModelSimple(
      id: 'badge_007',
      name: 'Connector',
      emoji: '🤝',
      description: 'Connected with 20+ students',
    ),
    const BadgeModelSimple(
      id: 'badge_008',
      name: 'Opportunity Seeker',
      emoji: '🔍',
      description: 'Applied to 5 or more opportunities',
    ),
  ];
}

class BadgeModelSimple {
  final String id;
  final String name;
  final String emoji;
  final String description;

  const BadgeModelSimple({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });
}
