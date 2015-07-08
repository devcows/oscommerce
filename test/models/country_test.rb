# == Schema Information
#
# Table name: countries
#
#  code       :string
#  created_at :datetime         not null
#  enabled    :boolean          default(FALSE), not null
#  id         :integer          not null, primary key
#  iso        :string
#  name       :string
#  updated_at :datetime         not null
#  zone_id    :integer
#
# Indexes
#
#  index_countries_on_zone_id  (zone_id)
#

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
