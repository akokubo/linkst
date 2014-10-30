module Aoca
  class API < Grape::API
    version 'v1', using: :header, vendor: 'aoca'
    format :json

    helpers do
      def authenticate!
        true
        # error!('401 Unauthorized', 401) unless request.ip == '127.0.0.1'
      end
    end

    resource :users do
      desc "Users ranking."
      get '/' do
        statuses = Status.group(:user_id)
          .select('user_id, SUM(experience) AS total_experience')
          .order('total_experience DESC').limit(10)
        ranking = []
        statuses.each do |status|
          user = User.find(status.user_id)
          hash = {
            name: user.name,
            total_experience: user.total_experience,
            average_level: user.average_level.value            
          }
          ranking << hash
        end
        ranking
      end

      desc "Return a status."
      params do
        requires :fpno, type: String, desc: "Your fpno."
      end
      route_param :fpno do
        get do
          user = User.find_by(fpno: params[:fpno])
          error!({error:"404 Not Found", detail:"user not found with fpno=#{params[:fpno]}"}, 404) unless user
          categories = Category.all.order('id ASC')
          hash = {
            number: user.number,
            role: user.role.japanese_name,
            name: user.name,
            email: user.email,
            fpno: user.fpno,
            card_number: user.card_number,
            average_level: user.average_level.value,
            total_experience: user.total_experience,
            next_average_level_required_experience: user.average_level.next.required_experience,
            statuses: [
            ],
            missions: [
            ]
          }
          if user.seminar
            hash["seminar"] = user.seminar.name
          else
            hash["seminar"] = ""
          end
          categories.each do |category|
            status = user.statuses.find_by(category_id: category.id)
            level = Level.get_level_from_experience(status.experience)
            hash[:statuses] << {
              name: category.name,
              experience: status.experience,
              level: level.value,
              next_level_required_experience: level.next.required_experience
            }
          end
          assigns = user.assigns.order('id ASC')
          assigns.each do |assign|
            mission = assign.mission
            hash[:missions] << {
              id: mission.id,
              name: mission.category.name,
              level: mission.level.value,
              description: mission.description
            }
          end
          hash
        end
      end

    end

    resource :histories do
      desc "Return a public timeline."
      get '/' do
        mission = Mission.find_by(description: 'Webサイトアクセスボーナス')
        histories = History.where('mission_id != ?', mission.id).order('created_at DESC').limit(10)
        hashes = []
        histories.each do |history|
          hashes << {
            user: history.user.name,
            category: history.mission.category.name,
            level: history.mission.level.value,
            mission: history.mission.description,
            created_at: history.created_at
          }
        end
        hashes
      end

      desc "Create a history."
      params do
        requires :fpno, type: String, desc: "Your fpno."
        requires :mission_ids, type: Array, desc: "Mission ids."
      end
      post do
        authenticate!
        user = User.find_by(fpno: params[:fpno])
        error!({error:"404 Not Found", detail:"user not found with fpno=#{params[:fpno]}"}, 404) unless user

        mission_ids = params[:mission_ids]
        histories = []
        mission_ids.each do |mission_id|
          assign = user.assigns.find_by(mission_id: mission_id)
          error!({error:"404 Not Found", detail:"mission_id=#{mission_id} dose not assigned with fpno=#{params[:fpno]}"}, 404) unless assign

          history = History.new(user_id: user.id, mission_id: mission_id)
          mission = Mission.find(mission_id)
          history.recent_experience = user.total_experience
          mission.acquisitions.each do |acquisition|
            category_id = acquisition.category_id
            status = user.statuses.find_by(category_id: category_id)
            status.experience += acquisition.experience
            status.save
          end
          history.experience = user.reload.total_experience
          histories << history

        end

        if histories.count > 0
          History.transaction do
            histories.each do |history|
              history.save
            end
            user.reassign_missions
          end
        end
        hash = {fpno: params[:fpno], mission_ids: params[:mission_ids]}
      end

      desc "Return histories."
      params do
        requires :fpno, type: String, desc: "Your fpno."
      end
      route_param :fpno do
        get do
          user = User.find_by(fpno: params[:fpno])
          error!({error:"404 Not Found", detail:"user not found with fpno=#{params[:fpno]}"}, 404) unless user

          mission = Mission.find_by(description: 'Webサイトアクセスボーナス')
          histories = user.histories.where('mission_id != ?', mission.id).order('created_at DESC')
          hashes = []
          histories.each do |history|
            hashes << {
              category: history.mission.category.name,
              level: history.mission.level.value,
              mission: history.mission.description,
              created_at: history.created_at
            }
          end
          hashes
        end
      end
    end
    route :any, '*path' do
      error!({error: "404 Not Found", detail:"routing error"}, 404)
    end
  end
end
