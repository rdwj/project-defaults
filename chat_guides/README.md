# Chat Guide Templates

## What Are Chat Guides?

Chat guides are structured markdown documents designed to break down complex software development projects into manageable, single-conversation tasks with AI assistants. Each guide represents a focused unit of work that can typically be completed in one chat session.

## Why Use Chat Guides?

### 1. **Focused Scope**
- Each guide targets a specific feature or component
- Prevents context overflow in AI conversations
- Clear start and end points for each session

### 2. **Systematic Progress**
- Checkbox-driven task tracking
- Visual progress indicators
- Clear prerequisites and dependencies

### 3. **Knowledge Transfer**
- Documents implementation decisions
- Captures troubleshooting solutions
- Serves as onboarding material

### 4. **Quality Assurance**
- Built-in testing checklists
- Success criteria definition
- Consistent implementation standards

## How to Use Chat Guides

### For Project Managers

1. **Plan Your Project**
   - Break down the project into logical phases
   - Identify features that can be implemented independently
   - Create a sequence of chat guides

2. **Create Guide Files**
   - Copy `CHAT-GUIDE-TEMPLATE.md`
   - Fill in project-specific details
   - Number guides sequentially (01-, 02-, etc.)

3. **Track Progress**
   - Monitor checkbox completion
   - Review completed guides for quality
   - Adjust future guides based on learnings

### For Developers

1. **Start a Chat Session**
   - Open a new AI assistant conversation
   - Share the relevant chat guide markdown
   - Include any necessary context files

2. **Work Through Tasks**
   - Follow the guide systematically
   - Check off completed items
   - Document issues in troubleshooting section

3. **Complete the Session**
   - Verify all success criteria are met
   - Update the guide status
   - Note any follow-up actions

## Template Structure

### Core Sections

1. **Overview**: High-level goal and expected outcome
2. **Context**: Background and project integration
3. **Prerequisites**: What must be ready before starting
4. **Implementation Tasks**: Checkbox-driven task list
5. **Technical Specifications**: Architecture, APIs, data models
6. **Testing Checklist**: Verification steps
7. **Success Criteria**: Definition of done
8. **Troubleshooting**: Common issues and solutions

### Best Practices

#### Scope Definition
- **Small**: 1-2 hours, single component (e.g., "Add user authentication endpoint")
- **Medium**: 2-4 hours, integrated feature (e.g., "Implement payment processing")
- **Large**: 4-6 hours, complex system (e.g., "Build analytics dashboard")

#### Task Granularity
- Each checkbox should be 5-30 minutes of work
- Group related subtasks under major headings
- Include both implementation and verification tasks

#### Technical Details
- Provide enough detail to guide implementation
- Include API contracts and data schemas
- Reference external documentation

## Creating Effective Chat Guides

### 1. Clear Objectives
```markdown
**Goal**: Implement user authentication with JWT tokens
**Expected Outcome**: Secure login/logout endpoints with token refresh
```

### 2. Specific Tasks
```markdown
### 1. Database Setup
- [ ] Create users table with email, password_hash, created_at
- [ ] Add indexes on email field
- [ ] Create refresh_tokens table
```

### 3. Testable Criteria
```markdown
## Success Criteria
- [ ] Users can register with email/password
- [ ] Login returns JWT access token
- [ ] Protected routes require valid token
- [ ] Tokens expire and can be refreshed
```

## Managing Guide Sequences

### Project Structure
```
swe-pm/
├── README.md                    # Project overview
├── 01-foundation-setup.md       # First guide
├── 02-core-features.md          # Second guide
├── 03-integrations.md          # Third guide
└── templates/
    ├── README.md               # This file
    └── CHAT-GUIDE-TEMPLATE.md  # Template
```

### Dependency Management
- Number guides to show sequence
- List prerequisite guides in each document
- Update main README with completion status

### Progress Tracking
```markdown
| Phase | Guides | Completed | In Progress | Not Started |
|-------|--------|-----------|-------------|-------------|
| Foundation | 3 | 2 | 1 | 0 |
| Features | 5 | 0 | 0 | 5 |
```

## Tips for Success

### DO:
- ✅ Keep guides focused on single features
- ✅ Include all necessary context in the guide
- ✅ Test as you implement
- ✅ Update checkboxes in real-time
- ✅ Document issues for future reference

### DON'T:
- ❌ Create guides longer than 6 hours of work
- ❌ Skip prerequisites
- ❌ Leave technical specs vague
- ❌ Forget to define success criteria
- ❌ Create separate completion tracking files

## Example Use Cases

### 1. API Development
- Authentication endpoints
- CRUD operations
- Third-party integrations
- Webhook handlers

### 2. Frontend Features
- Component libraries
- Form implementations
- Dashboard pages
- Mobile responsiveness

### 3. Infrastructure
- Database migrations
- CI/CD pipelines
- Monitoring setup
- Security hardening

### 4. Data Processing
- ETL pipelines
- Analytics queries
- Report generation
- Data validation

## Maintenance

### Updating Guides
- Modify guides directly (no versioning)
- Check off completed tasks
- Add troubleshooting entries as discovered
- Update time estimates based on experience

### Post-Completion
- Review completed guides for insights
- Extract common patterns for future guides
- Update templates with learnings
- Create reference documentation from guides

## Getting Started

1. Copy `CHAT-GUIDE-TEMPLATE.md` to your project
2. Customize for your first feature
3. Run through the guide with an AI assistant
4. Iterate and improve the process

Remember: The goal is to make complex projects manageable by breaking them into focused, well-documented conversations that produce working code.