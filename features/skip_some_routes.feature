Feature: Skipping the check for some specific routes

  Scenario Outline: Skipping the check for some requests
    Given a rack with the anti-CSRF middleware and the :skip option
      | pair                 |
      | POST:/not_checking   |
      | PUT:/is_wrong        |
      | POST:/not_.*\.json   |
      | DELETE:/cars/.*\.xml |
    When it receives a <method> request for <path> without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method | path                            |
      | POST   | /not_checking                   |
      | PUT    | /is_wrong                       |
      | POST   | /not_checking.json              |
      | POST   | /not_again/params/whatever.json |
      | DELETE | /cars/abc123.xml                |

  Scenario Outline: Keep checking the requests for other method/path pairs
    Given a rack with the anti-CSRF middleware and the :skip option
      | pair                 |
      | POST:/not_checking   |
      | PUT:/is_wrong        |
      | POST:/not_.*\.json   |
      | DELETE:/cars/.*\.xml |
    When it receives a <method> request for <path> without the CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method | path                            |
      | PUT    | /not_checking                   |
      | DELETE | /not_checking                   |
      | POST   | /is_wrong                       |
      | DELETE | /is_wrong                       |
      | POST   | /                               |
      | PUT    | /not                            |
      | POST   | /is                             |
      | PUT    | /not_checking.json              |
      | DELETE | /not_checking.json              |
      | PUT    | /not_again/params/whatever.json |
      | DELETE | /not_again/params/whatever.json |
      | POST   | /cars/abc123.xml                |
      | PUT    | /cars/abc123.xml                |
