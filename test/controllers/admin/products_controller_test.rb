require 'test_helper'

module Admin
  class ProductsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
      login_admin
    end

    test 'should get index/edit/show' do
      get :index
      assert_response :success

      object = products(:camera)
      get :edit, id: object.id
      assert_response :success

      get :show, id: object.id
      assert_response :success
    end

    test 'should get clone' do
      object = products(:camera)

      get :new, id: object.id
      assert_response :success
    end
  end
end
