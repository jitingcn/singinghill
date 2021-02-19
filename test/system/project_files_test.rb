require "application_system_test_case"

class ProjectFilesTest < ApplicationSystemTestCase
  setup do
    @project_file = project_files(:one)
  end

  test "visiting the index" do
    visit project_files_url
    assert_selector "h1", text: "Project Files"
  end

  test "creating a Project file" do
    visit project_files_url
    click_on "New Project File"

    click_on "Create Project file"

    assert_text "Project file was successfully created"
    click_on "Back"
  end

  test "updating a Project file" do
    visit project_files_url
    click_on "Edit", match: :first

    click_on "Update Project file"

    assert_text "Project file was successfully updated"
    click_on "Back"
  end

  test "destroying a Project file" do
    visit project_files_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project file was successfully destroyed"
  end
end
