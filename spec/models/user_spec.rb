require 'rails_helper'

describe User do
  it "is valid with a name, number, fpno, email, password and password_confirmation" do
    user = User.new(
      name: 'Test User',
      number: '0000000',
      fpno: '01234567',
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password')
    expect(user).to be_valid
  end

  it "is invalid without a email" do
    expect(User.new(email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid without a password" do
    expect(User.new(password: nil)).to have(1).errors_on(:password)
  end

  it "is invalid without a password_confirmation" do
    expect(User.new(password_confirmation: nil)).to have(1).errors_on(:password)
  end
end

