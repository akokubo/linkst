namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    role_admin_id = Role.find_by(japanese_name: "管理者").id
    role_teacher_id = Role.find_by(japanese_name: "教員").id
    role_student_id = Role.find_by(japanese_name: "学生").id

    categories = Category.all

    level_required_experience_minimum = Level.minimum(:required_experience)
    level = Level.find_by(required_experience: level_required_experience_minimum)

    first_missions = []

    categories.each do |category|
      first_missions << Mission.find_by(category_id: category.id, level_id: level.id)
    end

    Faker::Config.locale = :en

    seminars = Seminar.all

    faculties_red = %w{経 社 ソ 薬}
    100.times do |n|
      number = sprintf("%s260%02d", faculties_red[n / 25], n % 25)
      role_id = 1
      Faker::Config.locale = :ja
      name  = Faker::Name.name
      Faker::Config.locale = :en
      fpno = SecureRandom.hex(5)
      email = Faker::Internet.email
      password  = "password"
      index = n % seminars.count
      user = User.create!(
        number: number,
        role_id: role_student_id,
        name: name,
        email: email,
        fpno: fpno,
        seminar_id: seminars[index].id,
        password: password,
        password_confirmation: password)
    end
  end
end
