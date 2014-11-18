require 'rails_helper'

describe User do
  it "Has unique email" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234"
    )

    user = User.new(
      first_name: "Joe",
      last_name: "Test",
      email: "joe@user.com",
      password: "1234"
    )

    user.valid?
    expect(user.errors[:email].present?).to eq(true)

    user.email = "JOE@USER.com"
    user.valid?
    expect(user.errors[:email].present?).to eq(true)

    user.email = "JOE@user.com     "
    user.valid?
    expect(user.errors[:email].present?).to eq(true)

    user.email = "joe@test.com"
    user.valid?
    expect(user.errors[:email].present?).to eq(false)
   end
end
