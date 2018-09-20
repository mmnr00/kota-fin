require 'test_helper'

class TaskasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @taska = taskas(:one)
  end

  test "should get index" do
    get taskas_url
    assert_response :success
  end

  test "should get new" do
    get new_taska_url
    assert_response :success
  end

  test "should create taska" do
    assert_difference('Taska.count') do
      post taskas_url, params: { taska: {  } }
    end

    assert_redirected_to taska_url(Taska.last)
  end

  test "should show taska" do
    get taska_url(@taska)
    assert_response :success
  end

  test "should get edit" do
    get edit_taska_url(@taska)
    assert_response :success
  end

  test "should update taska" do
    patch taska_url(@taska), params: { taska: {  } }
    assert_redirected_to taska_url(@taska)
  end

  test "should destroy taska" do
    assert_difference('Taska.count', -1) do
      delete taska_url(@taska)
    end

    assert_redirected_to taskas_url
  end
end
