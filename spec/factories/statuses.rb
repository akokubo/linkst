# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    user nil
    category nil
    experience 1
  end
end
