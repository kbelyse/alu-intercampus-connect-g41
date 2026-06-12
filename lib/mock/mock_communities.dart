import '../shared/models/community_model.dart';
import '../core/constants/image_constants.dart';

class MockCommunities {
  static final List<CommunityModel> communities = [
    CommunityModel(
      id: 'comm_001',
      name: 'AI Club',
      description:
          'The hub for AI enthusiasts, researchers, and practitioners at ALU. From machine learning fundamentals to cutting-edge deep learning, we explore AI\'s potential to transform Africa.',
      imageUrl: ImageConstants.communityAI,
      coverUrl: ImageConstants.eventAiSummit,
      tags: ['AI & Machine Learning', 'Technology', 'Data Science', 'Research'],
      memberCount: 342,
      isTrending: true,
      campus: 'Kigali',
      memberAvatars: [
        ImageConstants.avatar2,
        ImageConstants.avatar4,
        ImageConstants.avatar7,
        ImageConstants.avatar8,
      ],
      lastActivity: '2 minutes ago',
      weeklyPosts: 47,
    ),
    CommunityModel(
      id: 'comm_002',
      name: 'Product Club',
      description:
          'Where product thinkers, designers, and builders come together. Weekly design critiques, product teardowns, and workshops. The launchpad for ALU\'s next generation of product leaders.',
      imageUrl: ImageConstants.communityProduct,
      coverUrl: ImageConstants.eventProductDesign,
      tags: ['Product Design', 'Technology', 'Marketing', 'Arts & Culture'],
      memberCount: 218,
      isTrending: true,
      campus: 'Mauritius',
      memberAvatars: [
        ImageConstants.avatar1,
        ImageConstants.avatar5,
        ImageConstants.avatar3,
      ],
      lastActivity: '15 minutes ago',
      weeklyPosts: 31,
    ),
    CommunityModel(
      id: 'comm_003',
      name: 'Entrepreneurship Society',
      description:
          'ALU\'s largest entrepreneurship community. Home to founders, operators, and investors building Africa\'s future. Monthly pitch nights, founder stories, and business development workshops.',
      imageUrl: ImageConstants.communityEntrepreneurship,
      coverUrl: ImageConstants.eventFounderFriday,
      tags: ['Entrepreneurship', 'Finance', 'Leadership', 'Social Impact'],
      memberCount: 487,
      isTrending: true,
      campus: 'Kigali',
      memberAvatars: [
        ImageConstants.avatar3,
        ImageConstants.avatar6,
        ImageConstants.avatar1,
        ImageConstants.avatar4,
        ImageConstants.avatar7,
      ],
      lastActivity: '5 minutes ago',
      weeklyPosts: 68,
    ),
    CommunityModel(
      id: 'comm_004',
      name: 'ALU Builders',
      description:
          'The engineering and technical community at ALU. Hackathons, coding challenges, open source projects, and technical workshops. Build things that matter.',
      imageUrl: ImageConstants.communityBuilders,
      coverUrl: ImageConstants.eventHackathon,
      tags: ['Technology', 'Engineering', 'Data Science', 'AI & Machine Learning'],
      memberCount: 276,
      isTrending: false,
      campus: 'Kigali',
      memberAvatars: [
        ImageConstants.avatar2,
        ImageConstants.avatar4,
        ImageConstants.avatar8,
      ],
      lastActivity: '1 hour ago',
      weeklyPosts: 24,
    ),
    CommunityModel(
      id: 'comm_005',
      name: 'Impact Leaders',
      description:
          'Students committed to creating sustainable social and environmental change across Africa. Community projects, impact investments, and policy advocacy.',
      imageUrl: ImageConstants.communityImpact,
      coverUrl: ImageConstants.eventCommunityImpact,
      tags: ['Social Impact', 'Sustainability', 'Leadership', 'Policy & Governance'],
      memberCount: 189,
      isTrending: false,
      campus: 'Mauritius',
      memberAvatars: [
        ImageConstants.avatar5,
        ImageConstants.avatar7,
        ImageConstants.avatar3,
      ],
      lastActivity: '3 hours ago',
      weeklyPosts: 18,
    ),
    CommunityModel(
      id: 'comm_006',
      name: 'Women In Tech',
      description:
          'Supporting, inspiring, and connecting women in technology across ALU and beyond. Mentorship programs, career development, and a safe space to grow as leaders in tech.',
      imageUrl: ImageConstants.communityWomenTech,
      coverUrl: ImageConstants.eventWomenLeadership,
      tags: ['Technology', 'Leadership', 'Social Impact', 'Education'],
      memberCount: 234,
      isTrending: true,
      campus: 'Kigali',
      memberAvatars: [
        ImageConstants.avatar2,
        ImageConstants.avatar5,
        ImageConstants.avatar8,
        ImageConstants.avatar3,
      ],
      lastActivity: '30 minutes ago',
      weeklyPosts: 35,
    ),
  ];
}
