# == Schema Information
#
# Table name: users_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_users_roles_on_role_id  (role_id)
#  index_users_roles_on_user_id  (user_id)
#

require 'test_helper'

class UsersRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
