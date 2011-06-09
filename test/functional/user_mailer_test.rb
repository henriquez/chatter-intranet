require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # replace this with your real tests
  test "reply notification email" do
    user = User.new :email => 'logan@henriquez.net', :name => 'logan'
    reply = 'That was the dumbest questions ever..'
    email = UserMailer.notification(user, reply).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
end
