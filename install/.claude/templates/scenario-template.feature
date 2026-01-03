# Template for Gherkin Feature Files
# Copy and customize for your features

@[layer] @[feature]
Feature: [Feature Name]
  As a [persona]
  I want [action/capability]
  So that [business value]

  # Shared setup for all scenarios
  Background:
    Given [shared precondition]
    And [another shared precondition]

  # ===========================================
  # HAPPY PATH SCENARIOS
  # ===========================================

  @smoke @positive
  Scenario: [Primary success case]
    Given [initial state]
    And [additional context]
    When [user action]
    Then [expected outcome]
    And [additional verification]

  @positive
  Scenario: [Secondary success case]
    Given [initial state]
    When [user action]
    Then [expected outcome]

  # ===========================================
  # VALIDATION SCENARIOS
  # ===========================================

  @negative @validation
  Scenario: [Validation failure case]
    Given [initial state]
    When [user action with invalid data]
    Then [error message]
    And [form state preserved]

  @negative @validation
  Scenario Outline: Reject invalid [field] values
    Given [initial state]
    When I enter "<invalid_value>" in "[field]"
    And I submit the form
    Then I should see "<error_message>"

    Examples:
      | invalid_value | error_message |
      | [value_1]     | [message_1]   |
      | [value_2]     | [message_2]   |
      | [value_3]     | [message_3]   |

  # ===========================================
  # AUTHORIZATION SCENARIOS
  # ===========================================

  @security @authorization
  Scenario: [Authorized access]
    Given I am logged in as "[authorized_role]"
    When [action]
    Then [success outcome]

  @security @authorization
  Scenario: [Unauthorized access denied]
    Given I am logged in as "[unauthorized_role]"
    When [action]
    Then I should see "You don't have permission"
    And [action should not occur]

  # ===========================================
  # EDGE CASE SCENARIOS
  # ===========================================

  @edge-case
  Scenario: [Boundary condition]
    Given [setup at boundary]
    When [action at limit]
    Then [expected behavior at boundary]

  @edge-case
  Scenario: [Empty state handling]
    Given [no data exists]
    When [action]
    Then [empty state message]

  @edge-case
  Scenario: [Concurrent operation]
    Given [entity] was modified by another user
    When I try to [action]
    Then I should see "This item was updated"
    And I should be able to refresh and retry

  # ===========================================
  # ERROR HANDLING SCENARIOS
  # ===========================================

  @negative @error-handling
  Scenario: [Network error recovery]
    Given the server is unavailable
    When [action]
    Then I should see "Unable to complete action"
    And I should see a retry option

  @negative @error-handling
  Scenario: [Server error handling]
    Given the server returns an error
    When [action]
    Then I should see a user-friendly error message
    And the error should be logged

# ===========================================
# TAGGING CONVENTIONS
# ===========================================
#
# Required tags (every scenario):
#   @api | @ui | @e2e         - Test layer
#   @smoke | @regression      - Priority
#
# Feature tags:
#   @auth                     - Authentication
#   @crud                     - CRUD operations
#   @[entity]                 - Entity-specific
#
# Type tags:
#   @positive                 - Happy path
#   @negative                 - Error cases
#   @edge-case                - Boundaries
#   @security                 - Security tests
#   @validation               - Input validation
#
# ===========================================
