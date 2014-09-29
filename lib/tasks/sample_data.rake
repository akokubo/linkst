namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    role_admin_id = Role.find_by(name: "管理者").id
    role_teacher_id = Role.find_by(name: "教員").id
    role_student_id = Role.find_by(name: "学生").id

    categories = Category.all


    level_sufficiency_minimum = Level.minimum(:sufficiency)
    level = Level.find_by(sufficiency: level_sufficiency_minimum)

    first_missions = []

    categories.each do |category|
      first_missions << Mission.find_by(category_id: category.id, level_id: level.id)
    end

    Faker::Config.locale = :en
    user = User.create!(
      number: "ソフトウェア情報学部教員",
      role_id: role_admin_id,
      name: "小久保 温",
      email: "kokubo@aomori-u.ac.jp",
      idm: Faker::Number.number(16),
      password: "password",
      password_confirmation: "password")

    categories.each do |category|
      user.statuses.create(
        category_id: category.id,
        experience: 0)
    end

    first_missions.each do |mission|
      user.assigns.create(mission_id: mission.id)
    end

    faculties = %w{経営学部教員 経営学部教員 社会学部教員 社会学部教員 ソフトウェア情報学部教員 ソフトウェア情報学部教員 薬学部教員 薬学部教員}
    faculties.each do |faculty|
      number = faculty
      role_id = role_teacher_id
      Faker::Config.locale = :ja
      name  = Faker::Name.name
      Faker::Config.locale = :en
      idm = Faker::Number.number(16)
      email = Faker::Internet.email
      password  = "password"
      user = User.create!(
        number: number,
        role_id: role_id,
        name: name,
        email: email,
        idm: idm,
        password: password,
        password_confirmation: password)

      categories.each do |category|
        user.statuses.create(
          category_id: category.id,
          experience: 0)
      end

      first_missions.each do |mission|
        user.assigns.create(mission_id: mission.id)
      end
    end

    faculties_red = %w{経 社 ソ 薬}
    100.times do |n|
      number = sprintf("%s260%02d", faculties_red[n / 25], n % 25)
      role_id = 1
      Faker::Config.locale = :ja
      name  = Faker::Name.name
      Faker::Config.locale = :en
      idm = Faker::Number.number(16)
      email = Faker::Internet.email
      password  = "password"
      user = User.create!(
        number: number,
        role_id: role_student_id,
        name: name,
        email: email,
        idm: idm,
        password: password,
        password_confirmation: password)

      categories.each do |category|
        user.statuses.create(
          category_id: category.id,
          experience: 0)
      end

      first_missions.each do |mission|
        user.assigns.create(mission_id: mission.id)
      end
    end
  end
end