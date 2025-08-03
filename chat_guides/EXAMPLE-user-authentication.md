# Chat Guide: User Authentication System

> **📋 CHECKBOX DIRECTIVE**: Update checkboxes `[ ]` to `[x]` as tasks are completed. Modify this file directly - do not create separate completion files.

## Overview

**Goal**: Implement a secure user authentication system with JWT tokens, user registration, login/logout, and password reset functionality.

**Expected Outcome**: A complete authentication API with secure endpoints, token management, and user account operations.

**Estimated Scope**: Medium (3-4 hours)

## Context

The application needs user authentication to protect sensitive resources and provide personalized experiences. This implementation will use JWT tokens for stateless authentication, bcrypt for password hashing, and include features like token refresh and password reset via email.

## Prerequisites

Before starting this chat guide:
- [x] Database connection configured and tested
- [x] Email service configured (for password reset)
- [x] Base Express.js server running
- [ ] Environment variables set up (.env file)

## Implementation Tasks

### 1. Database Schema
- [ ] Create users table with fields: id, email, password_hash, name, created_at, updated_at
- [ ] Create refresh_tokens table with fields: id, user_id, token, expires_at, created_at
- [ ] Create password_reset_tokens table
- [ ] Add appropriate indexes (email, tokens)

### 2. Authentication Middleware
- [ ] Install required packages (jsonwebtoken, bcrypt, express-validator)
- [ ] Create JWT token generation utility
- [ ] Create token verification middleware
- [ ] Implement refresh token rotation

### 3. User Registration
- [ ] Create POST /api/auth/register endpoint
- [ ] Validate email format and password strength
- [ ] Hash password with bcrypt
- [ ] Generate welcome email
- [ ] Return user object and tokens

### 4. User Login
- [ ] Create POST /api/auth/login endpoint
- [ ] Validate credentials
- [ ] Compare password hash
- [ ] Generate access and refresh tokens
- [ ] Return tokens and user data

### 5. Token Management
- [ ] Create POST /api/auth/refresh endpoint
- [ ] Validate refresh token
- [ ] Rotate refresh token
- [ ] Return new access token
- [ ] Create POST /api/auth/logout endpoint

### 6. Password Reset
- [ ] Create POST /api/auth/forgot-password endpoint
- [ ] Generate reset token
- [ ] Send reset email
- [ ] Create POST /api/auth/reset-password endpoint
- [ ] Validate reset token and update password

## Technical Specifications

### Architecture
The authentication system uses a stateless JWT approach with short-lived access tokens (15 minutes) and longer-lived refresh tokens (7 days). Refresh tokens are rotated on each use to prevent replay attacks.

### Key Components
- **AuthController**: Handles authentication endpoints
- **AuthMiddleware**: Validates tokens on protected routes
- **TokenService**: Manages JWT generation and validation
- **EmailService**: Sends password reset and welcome emails

### API/Interface Design
```typescript
// POST /api/auth/register
{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "name": "John Doe"
}

// POST /api/auth/login
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}

// Response format
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe"
  },
  "tokens": {
    "accessToken": "jwt...",
    "refreshToken": "jwt...",
    "expiresIn": 900
  }
}
```

### Data Models
```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  email_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Refresh tokens table
CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(500) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Implementation Notes

### Important Considerations
- Use httpOnly cookies for refresh tokens in production
- Implement rate limiting on auth endpoints
- Add CSRF protection for cookie-based auth
- Log authentication events for security monitoring

### Security & Safety
- Passwords must be at least 8 characters with complexity requirements
- Implement account lockout after 5 failed attempts
- Use constant-time comparison for password verification
- Sanitize all user inputs
- Refresh tokens should be revoked on password change

### Performance Requirements
- Token generation < 100ms
- Password hashing using bcrypt with cost factor 10
- Database queries optimized with proper indexes

## Testing Checklist

### Unit Tests
- [ ] JWT token generation and validation
- [ ] Password hashing and comparison
- [ ] Input validation functions
- [ ] Email formatting

### Integration Tests
- [ ] Complete registration flow
- [ ] Login with valid/invalid credentials
- [ ] Token refresh cycle
- [ ] Password reset flow
- [ ] Protected route access

### Manual Verification
- [ ] Register new user via API
- [ ] Receive welcome email
- [ ] Login and receive tokens
- [ ] Access protected endpoint with token
- [ ] Refresh expired token
- [ ] Complete password reset

## Success Criteria

The implementation is complete when:
- [ ] Users can register with email/password
- [ ] Login returns valid JWT tokens
- [ ] Protected routes require valid token
- [ ] Tokens expire and can be refreshed
- [ ] Password reset works end-to-end
- [ ] All tests pass
- [ ] API documentation is updated

## Troubleshooting Guide

### Common Issues

**Issue 1: "Invalid token" errors**
- Symptom: 401 errors on protected routes
- Solution: Check token expiry, ensure Bearer prefix, verify JWT secret

**Issue 2: Password reset tokens not working**
- Symptom: "Invalid or expired token" message
- Solution: Check token expiry (should be 1 hour), ensure URL encoding

**Issue 3: Refresh token rotation failing**
- Symptom: Multiple devices logged out
- Solution: Implement device tracking, allow multiple refresh tokens per user

## Follow-up Actions

After completing this guide:
1. Implement role-based access control (RBAC)
2. Add OAuth2 social login providers
3. Set up authentication monitoring and alerts
4. Create user profile management endpoints

## References

- [JWT Best Practices](https://datatracker.ietf.org/doc/html/rfc8725)
- [OWASP Authentication Cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist/)

---

**Status**: [ ] Not Started | [x] In Progress | [ ] Completed
**Started**: July 15, 2024
**Completed**: [Pending]
**Implementer**: @ai-assistant