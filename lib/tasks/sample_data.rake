namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Role.create!([
      { name: '学生'},
      { name: '教員'},
      { name: '管理者'}
      ])

    Category.create!([
      { name: 'アクティビティ' },
      { name: 'ヘルス' },
      { name: 'モラル' }
      ])

    Level.create!([
      { value: 1, sufficiency: 2 },
      { value: 2, sufficiency: 4 },
      { value: 3, sufficiency: 8 },
      { value: 4, sufficiency: 16 },
      { value: 5, sufficiency: 32 },
      { value: 6, sufficiency: 64 },
      { value: 7, sufficiency: 128 },
      { value: 8, sufficiency: 256 },
      { value: 9, sufficiency: 512 }
      ])

    Faker::Config.locale = :ja
    random = Random.new
    1.upto(100) do |n|
      description = Faker::Lorem.sentence(3)
      category_id = rand(1..3)
      level_id = rand(1..9)
      Mission.create!(
        description: description,
        category_id: category_id,
        level_id: level_id
        )
      Acquisition.create!([
        {
          mission_id: n,
          category_id: 1,
          experience: rand(1..3)
        },
        {
          mission_id: n,
          category_id: 2,
          experience: rand(1..3)
        },
        {
          mission_id: n,
          category_id: 3,
          experience: rand(1..3)
        }
        ])
    end

    Faker::Config.locale = :en
    User.create!(
      number: "ソフトウェア情報学部教員",
      role_id: 3,
      name: "小久保 温",
      email: "kokubo@aomori-u.ac.jp",
      idm: Faker::Number.number(16),
      password: "password",
      password_confirmation: "password")

    faculties = %w{経営学部教員 経営学部教員 社会学部教員 社会学部教員 ソフトウェア情報学部教員 ソフトウェア情報学部教員 薬学部教員 薬学部教員}
    faculties.each do |faculty|
      number = faculty
      role_id = 2
      Faker::Config.locale = :ja
      name  = Faker::Name.name
      Faker::Config.locale = :en
      idm = Faker::Number.number(16)
      email = Faker::Internet.email
      password  = "password"
      User.create!(
        number: number,
        role_id: role_id,
        name: name,
        email: email,
        idm: idm,
        password: password,
        password_confirmation: password)
    end

    faculties_red = %w{経 社 ソ 薬}
    99.times do |n|
      number = faculties_red[n % 4] + Faker::Number.number(5)
      role_id = 1
      Faker::Config.locale = :ja
      name  = Faker::Name.name
      Faker::Config.locale = :en
      idm = Faker::Number.number(16)
      email = Faker::Internet.email
      password  = "password"
      User.create!(
        number: number,
        role_id: role_id,
        name: name,
        email: email,
        idm: idm,
        password: password,
        password_confirmation: password)
    end

  end
end