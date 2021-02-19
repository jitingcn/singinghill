require "test_helper"

class ProjectFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_file = project_files(:one)
  end

  test "should get index" do
    get project_files_url
    assert_response :success
  end

  test "should get new" do
    get new_project_file_url
    assert_response :success
  end

  test "should create project_file" do
    assert_difference('ProjectFile.count') do
      post project_files_url, params: { project_file: {  } }
    end

    assert_redirected_to project_file_url(ProjectFile.last)
  end

  test "should show project_file" do
    get project_file_url(@project_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_file_url(@project_file)
    assert_response :success
  end

  test "should update project_file" do
    patch project_file_url(@project_file), params: { project_file: {  } }
    assert_redirected_to project_file_url(@project_file)
  end

  test "should destroy project_file" do
    assert_difference('ProjectFile.count', -1) do
      delete project_file_url(@project_file)
    end

    assert_redirected_to project_files_url
  end
end
