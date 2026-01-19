# Database seeds for MagenticResources
# Run with: rails db:seed

puts "Seeding database..."

# Create Users
puts "Creating users..."
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.role = :admin
end

manager = User.find_or_create_by!(email: "manager@example.com") do |u|
  u.name = "Project Manager"
  u.role = :user
end

puts "Created #{User.count} users"

# Create Skills
puts "Creating skills..."
skills_data = [
  # Programming
  { name: "Ruby", category: "programming", description: "Ruby programming language" },
  { name: "Python", category: "programming", description: "Python programming language" },
  { name: "JavaScript", category: "programming", description: "JavaScript/TypeScript" },
  { name: "Go", category: "programming", description: "Go programming language" },
  { name: "Rust", category: "programming", description: "Rust programming language" },

  # AI/ML
  { name: "Machine Learning", category: "ai_ml", description: "ML model development and training" },
  { name: "Natural Language Processing", category: "ai_ml", description: "NLP and text analysis" },
  { name: "Computer Vision", category: "ai_ml", description: "Image and video analysis" },
  { name: "LLM Integration", category: "ai_ml", description: "Large Language Model integration" },
  { name: "Prompt Engineering", category: "ai_ml", description: "Crafting effective AI prompts" },

  # Design
  { name: "UI Design", category: "design", description: "User interface design" },
  { name: "UX Research", category: "design", description: "User experience research" },
  { name: "Figma", category: "design", description: "Figma design tool" },

  # DevOps
  { name: "Docker", category: "devops", description: "Container management" },
  { name: "Kubernetes", category: "devops", description: "Container orchestration" },
  { name: "AWS", category: "devops", description: "Amazon Web Services" },
  { name: "CI/CD", category: "devops", description: "Continuous Integration/Deployment" },

  # Data
  { name: "SQL", category: "data", description: "Database queries and management" },
  { name: "Data Analysis", category: "data", description: "Data analysis and visualization" },
  { name: "ETL", category: "data", description: "Extract, Transform, Load processes" },

  # Management
  { name: "Project Management", category: "management", description: "Project planning and execution" },
  { name: "Agile/Scrum", category: "management", description: "Agile methodologies" },
  { name: "Technical Writing", category: "communication", description: "Documentation and technical writing" },

  # Testing
  { name: "Test Automation", category: "testing", description: "Automated testing frameworks" },
  { name: "QA", category: "testing", description: "Quality assurance" }
]

skills_data.each do |skill_attrs|
  Skill.find_or_create_by!(name: skill_attrs[:name]) do |s|
    s.category = skill_attrs[:category]
    s.description = skill_attrs[:description]
  end
end

puts "Created #{Skill.count} skills"

# Create Human Resources
puts "Creating human resources..."
humans_data = [
  {
    name: "Sarah Chen",
    email: "sarah.chen@example.com",
    resource_type: :human,
    status: :available,
    capacity_hours: 40,
    hourly_rate: 150,
    timezone: "America/New_York",
    description: "Senior full-stack developer with 8 years of experience in Ruby and JavaScript.",
    skills: ["Ruby", "JavaScript", "Docker", "SQL", "Agile/Scrum"]
  },
  {
    name: "Marcus Johnson",
    email: "marcus.j@example.com",
    resource_type: :human,
    status: :available,
    capacity_hours: 40,
    hourly_rate: 175,
    timezone: "America/Los_Angeles",
    description: "Machine learning engineer specializing in NLP and LLM applications.",
    skills: ["Python", "Machine Learning", "Natural Language Processing", "LLM Integration"]
  },
  {
    name: "Emily Rodriguez",
    email: "emily.r@example.com",
    resource_type: :human,
    status: :partially_available,
    capacity_hours: 32,
    hourly_rate: 125,
    timezone: "America/Chicago",
    description: "UX designer with strong research background.",
    skills: ["UI Design", "UX Research", "Figma"]
  },
  {
    name: "Alex Kim",
    email: "alex.kim@example.com",
    resource_type: :human,
    status: :available,
    capacity_hours: 40,
    hourly_rate: 140,
    timezone: "America/New_York",
    description: "DevOps engineer with cloud infrastructure expertise.",
    skills: ["Docker", "Kubernetes", "AWS", "CI/CD", "Go"]
  },
  {
    name: "Jordan Taylor",
    email: "jordan.t@example.com",
    resource_type: :human,
    status: :available,
    capacity_hours: 40,
    hourly_rate: 130,
    timezone: "Europe/London",
    description: "Backend developer focused on data pipelines and APIs.",
    skills: ["Python", "SQL", "Data Analysis", "ETL", "Docker"]
  }
]

humans_data.each do |human_attrs|
  skills = human_attrs.delete(:skills)
  resource = Resource.find_or_create_by!(email: human_attrs[:email]) do |r|
    r.assign_attributes(human_attrs)
    r.created_by = admin
  end

  skills.each do |skill_name|
    skill = Skill.find_by(name: skill_name)
    next unless skill
    ResourceSkill.find_or_create_by!(resource: resource, skill: skill) do |rs|
      rs.proficiency_level = [:intermediate, :advanced, :expert].sample
      rs.years_experience = rand(1..10)
      rs.certified = [true, false].sample
    end
  end
end

puts "Created #{Resource.humans.count} human resources"

# Create AI Agent Resources
puts "Creating AI agent resources..."
ai_agents_data = [
  {
    name: "CodeAssist AI",
    email: "codeassist@ai.internal",
    resource_type: :ai_agent,
    status: :available,
    capacity_hours: 168, # 24/7
    hourly_rate: 25,
    timezone: "UTC",
    description: "AI coding assistant powered by Claude. Excellent at code review, refactoring, and documentation.",
    skills: ["Ruby", "Python", "JavaScript", "Technical Writing", "Test Automation"]
  },
  {
    name: "DataBot",
    email: "databot@ai.internal",
    resource_type: :ai_agent,
    status: :available,
    capacity_hours: 168,
    hourly_rate: 30,
    timezone: "UTC",
    description: "Specialized AI for data analysis, SQL query generation, and reporting.",
    skills: ["SQL", "Data Analysis", "Python", "ETL"]
  },
  {
    name: "PromptMaster",
    email: "promptmaster@ai.internal",
    resource_type: :ai_agent,
    status: :available,
    capacity_hours: 168,
    hourly_rate: 20,
    timezone: "UTC",
    description: "AI agent specialized in prompt engineering and LLM workflow optimization.",
    skills: ["Prompt Engineering", "LLM Integration", "Natural Language Processing"]
  },
  {
    name: "TestRunner AI",
    email: "testrunner@ai.internal",
    resource_type: :ai_agent,
    status: :available,
    capacity_hours: 168,
    hourly_rate: 15,
    timezone: "UTC",
    description: "Automated testing agent for generating and running test suites.",
    skills: ["Test Automation", "QA", "Ruby", "JavaScript"]
  }
]

ai_agents_data.each do |ai_attrs|
  skills = ai_attrs.delete(:skills)
  resource = Resource.find_or_create_by!(email: ai_attrs[:email]) do |r|
    r.assign_attributes(ai_attrs)
    r.created_by = admin
  end

  skills.each do |skill_name|
    skill = Skill.find_by(name: skill_name)
    next unless skill
    ResourceSkill.find_or_create_by!(resource: resource, skill: skill) do |rs|
      rs.proficiency_level = :expert
      rs.certified = false
    end
  end
end

puts "Created #{Resource.ai_agents.count} AI agent resources"

# Create Teams
puts "Creating teams..."
teams_data = [
  {
    name: "Platform Engineering",
    description: "Core platform development team combining human engineers with AI coding assistants.",
    team_type: :department,
    members: ["Sarah Chen", "Alex Kim", "CodeAssist AI"]
  },
  {
    name: "Data & Analytics",
    description: "Data engineering and analytics team leveraging AI for data processing.",
    team_type: :department,
    members: ["Jordan Taylor", "Marcus Johnson", "DataBot"]
  },
  {
    name: "Product Design",
    description: "Design team focused on user experience.",
    team_type: :department,
    members: ["Emily Rodriguez"]
  },
  {
    name: "AI Integration Squad",
    description: "Virtual team for AI-powered feature development.",
    team_type: :virtual,
    members: ["Marcus Johnson", "PromptMaster", "CodeAssist AI"]
  }
]

teams_data.each do |team_attrs|
  members = team_attrs.delete(:members)
  team = Team.find_or_create_by!(name: team_attrs[:name]) do |t|
    t.description = team_attrs[:description]
    t.team_type = team_attrs[:team_type]
    t.owner = admin
  end

  members.each_with_index do |member_name, idx|
    resource = Resource.find_by(name: member_name)
    next unless resource
    team.add_resource(resource, role: idx == 0 ? :lead : :member)
  end
end

puts "Created #{Team.count} teams"

# Create Projects
puts "Creating projects..."
projects_data = [
  {
    name: "API Modernization",
    description: "Modernize legacy REST APIs to GraphQL with improved documentation.",
    status: :active,
    priority: :high,
    start_date: Date.current - 30.days,
    end_date: Date.current + 60.days,
    assignments: [
      { resource: "Sarah Chen", role: "Tech Lead", allocation: 80 },
      { resource: "CodeAssist AI", role: "Code Assistant", allocation: 50 },
      { resource: "Jordan Taylor", role: "Backend Developer", allocation: 60 }
    ]
  },
  {
    name: "ML Pipeline Overhaul",
    description: "Rebuild the machine learning pipeline for better scalability and monitoring.",
    status: :active,
    priority: :critical,
    start_date: Date.current - 14.days,
    end_date: Date.current + 90.days,
    assignments: [
      { resource: "Marcus Johnson", role: "ML Lead", allocation: 100 },
      { resource: "DataBot", role: "Data Processing", allocation: 100 },
      { resource: "Alex Kim", role: "Infrastructure", allocation: 40 }
    ]
  },
  {
    name: "Design System Refresh",
    description: "Update the design system with new components and accessibility improvements.",
    status: :planning,
    priority: :medium,
    start_date: Date.current + 7.days,
    end_date: Date.current + 45.days,
    assignments: [
      { resource: "Emily Rodriguez", role: "Design Lead", allocation: 100 }
    ]
  },
  {
    name: "Automated Test Coverage",
    description: "Increase test coverage using AI-assisted test generation.",
    status: :active,
    priority: :medium,
    start_date: Date.current - 7.days,
    end_date: Date.current + 30.days,
    assignments: [
      { resource: "TestRunner AI", role: "Test Generation", allocation: 100 },
      { resource: "CodeAssist AI", role: "Code Review", allocation: 50 }
    ]
  }
]

projects_data.each do |project_attrs|
  assignments = project_attrs.delete(:assignments)
  project = Project.find_or_create_by!(name: project_attrs[:name]) do |p|
    p.assign_attributes(project_attrs)
    p.owner = manager
  end

  assignments.each do |assign_attrs|
    resource = Resource.find_by(name: assign_attrs[:resource])
    next unless resource
    Assignment.find_or_create_by!(project: project, resource: resource) do |a|
      a.role = assign_attrs[:role]
      a.allocation_percentage = assign_attrs[:allocation]
      a.status = :active
      a.start_date = project.start_date
      a.end_date = project.end_date
      a.assigned_by = manager
    end
  end
end

puts "Created #{Project.count} projects"
puts "Created #{Assignment.count} assignments"

puts "\nSeeding complete!"
puts "="*50
puts "Summary:"
puts "  Users: #{User.count}"
puts "  Resources: #{Resource.count} (#{Resource.humans.count} humans, #{Resource.ai_agents.count} AI agents)"
puts "  Skills: #{Skill.count}"
puts "  Teams: #{Team.count}"
puts "  Projects: #{Project.count}"
puts "  Assignments: #{Assignment.count}"
puts "="*50
puts "\nYou can log in with: admin@example.com or manager@example.com"
