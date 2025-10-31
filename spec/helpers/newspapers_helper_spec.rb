# require 'rails_helper'

# RSpec.describe NewspapersHelper, type: :helper do
#   include ActiveSupport::Testing::TimeHelpers

#   let(:newspaper) { create(:newspaper) }
#   let(:newspaper_published_nil) { create(:newspaper, published_at: nil) }
#   let(:user) { create(:member) }

#   context "when user is guest or nil" do
#     it "user is nil" do
#       assert_equal false, check_newspaper_memberships(newspaper, nil)
#     end

#     it "user is a guest" do
#       assert_equal false, check_newspaper_memberships(newspaper, user)
#     end
#   end

#   context "when newspaper does not have a published_at date" do
#     it "published_at is nil" do
#       assert_equal false, check_newspaper_memberships(newspaper_published_nil, user)
#     end
#   end

#   context "when user has no memberships" do
#     it "user has no active memberships" do
#       assert_equal false, check_newspaper_memberships(newspaper, user)
#     end
#   end

#   context "when user has memberships" do
#     let!(:newspaper_30_days_ago) { travel_to(1.month.ago) { create(:newspaper) } }
#     let!(:newspaper_in_30_days) { travel_to(1.month.from_now) { create(:newspaper) } }
#     let!(:newspaper_in_5_months) { travel_to(5.months.from_now) { create(:newspaper) } }

#     before do
#       travel_to(Date.today) { create(:subscription, member: user) }
#       travel_to(1.month.ago) { create(:subscription, member: user) }
#       travel_to(1.month.from_now) { create(:subscription, member: user) }
#     end

#     it "when membership covers the newspaper's publication date" do
#       assert_equal true, check_newspaper_memberships(newspaper, user)
#     end

#     it "when membership covers a newspaper published 30 days ago" do
#       assert_equal true, check_newspaper_memberships(newspaper_30_days_ago, user)
#     end

#     it "when membership covers a newspaper published 30 days in the future" do
#       assert_equal true, check_newspaper_memberships(newspaper_in_30_days, user)
#     end

#     it "when membership does not cover a newspaper published 5 months in the future" do
#       assert_equal false, check_newspaper_memberships(newspaper_in_5_months, user)
#     end
#   end
# end
