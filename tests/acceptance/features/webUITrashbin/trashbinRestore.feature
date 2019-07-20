@files_trashbin-app-required
Feature: Restore deleted files/folders
  As a user
  I would like to restore files/folders
  So that I can recover accidentally deleted files/folders in ownCloud

  Background:
    Given user "user1" has been created with default attributes
    And user "user1" has logged in using the webUI
    And the user has browsed to the files page

  @smokeTest
  Scenario: Restore files
    When the user deletes file "data.zip" using the webUI
    And the user browses to the trashbin page
    Then file "data.zip" should be listed on the webUI
    When the user restores file "data.zip" from the trashbin using the webUI
    Then file "data.zip" should not be listed on the webUI
    When the user browses to the files page
    Then file "data.zip" should be listed on the webUI

  Scenario: Restore folder
    When the user deletes folder "folder with space" using the webUI
    And the user browses to the trashbin page
    Then folder "folder with space" should be listed in the trashbin on the webUI
    When the user restores folder "folder with space" from the trashbin using the webUI
    Then file "folder with space" should not be listed on the webUI
    When the user browses to the files page
    Then folder "folder with space" should be listed on the webUI

  @smokeTest
  @skip @yetToImplement
  Scenario: Select some trashbin files and restore them in a batch
    Given the following files have been deleted by user "user1"
      | name          |
      | data.zip      |
      | lorem.txt     |
      | lorem-big.txt |
      | simple-folder |
    And the user has browsed to the trashbin page
    When the user marks these files for batch action using the webUI
      | name          |
      | lorem.txt     |
      | lorem-big.txt |
    And the user batch restores the marked files using the webUI
    Then file "data.zip" should be listed on the webUI
    And folder "simple-folder" should be listed on the webUI
    But file "lorem.txt" should not be listed on the webUI
    And file "lorem-big.txt" should not be listed on the webUI
    And file "lorem.txt" should be listed in the files page on the webUI
    And file "lorem-big.txt" should be listed in the files page on the webUI
    But file "data.zip" should not be listed in the files page on the webUI
    And folder "simple-folder" should not be listed in the files page on the webUI

  @skip @yetToImplement
  Scenario: Select all except for some trashbin files and restore them in a batch
    Given the following files have been deleted by user "user1"
      | name          |
      | data.zip      |
      | lorem.txt     |
      | lorem-big.txt |
      | simple-folder |
    And the user has browsed to the trashbin page
    When the user marks all files for batch action using the webUI
    And the user unmarks these files for batch action using the webUI
      | name          |
      | lorem.txt     |
      | lorem-big.txt |
    And the user batch restores the marked files using the webUI
    Then file "lorem.txt" should be listed on the webUI
    And file "lorem-big.txt" should be listed on the webUI
    But file "data.zip" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    And file "data.zip" should be listed in the files page on the webUI
    And folder "simple-folder" should be listed in the files page on the webUI
    But file "lorem.txt" should not be listed in the files page on the webUI
    And file "lorem-big.txt" should not be listed in the files page on the webUI

  @skip @yetToImplement
  Scenario: Select all trashbin files and restore them in a batch
    Given the following files have been deleted by user "user1"
      | name          |
      | data.zip      |
      | lorem.txt     |
      | lorem-big.txt |
      | simple-folder |
    And the user has browsed to the trashbin page
    And the user marks all files for batch action using the webUI
    And the user batch restores the marked files using the webUI
    Then the folder should be empty on the webUI
    When the user browses to the files page
    Then file "lorem.txt" should be listed on the webUI
    And file "lorem-big.txt" should be listed on the webUI
    And file "data.zip" should be listed on the webUI
    And folder "simple-folder" should be listed on the webUI
