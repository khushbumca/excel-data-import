require 'rails_helper'

RSpec.describe User, type: :model do
  it "should be valid with valid attributes" do
    user = User.new(
      first_name: "Sample",
      last_name: "User",
      email_id: "sampleuser@yopmail.com"
    )
    expect(user).to be_valid
  end

  it "should be invalid with invalid attributes" do
    user = User.new(
      first_name: nil,
      last_name: nil,
      email_id: nil
    )
    expect(user).not_to be_valid
  end

  it "should not be valid without a first name" do
    user = User.new(
      first_name: nil,
      last_name: "User",
      email_id: "sampleuser@yopmail.com"
    )
    expect(user).not_to be_valid
  end

  it "should not be valid without a last name" do
    user = User.new(
      first_name: "Sample",
      last_name: nil,
      email_id: "sampleuser@yopmail.com"
    )
    expect(user).not_to be_valid
  end

  it "should be invalid without a valid email address" do
    user = User.new(
      first_name: "Sample",
      last_name: "User",
      email_id: "sampleuser"
    )
    expect(user).not_to be_valid
  end

end
