require "application_system_test_case"

class TaskasTest < ApplicationSystemTestCase
  setup do
    @taska = taskas(:one)
  end

  test "visiting the index" do
    visit taskas_url
    assert_selector "h1", text: "Taskas"
  end

  test "creating a Taska" do
    visit taskas_url
    click_on "New Taska"

    click_on "Create Taska"

    assert_text "Taska was successfully created"
    click_on "Back"
  end

  test "updating a Taska" do
    visit taskas_url
    click_on "Edit", match: :first

    click_on "Update Taska"

    assert_text "Taska was successfully updated"
    click_on "Back"
  end

  test "destroying a Taska" do
    visit taskas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Taska was successfully destroyed"
  end
end
