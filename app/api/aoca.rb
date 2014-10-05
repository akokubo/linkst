module Aoca
  class API < Grape::API
    version 'v1', using: :header, vendor: 'aoca'
    format :json

    helpers do
      def authenticate!
        error!('401 Unauthorized', 401) unless request.ip == '127.0.0.1'
      end
    end

    resource :users do
      desc "Users ranking."
      get '/' do
        users = User.limit(10).order('created_at DESC')
        hashes = []
        users.each do |user|
          hash = {
            name: user.name,
            total_experience: user.total_experience,
            average_level: user.average_level.value
          }
          hashes << hash
        end
        hashes
      end

      desc "Return a status."
      params do
        requires :idm, type: String, desc: "Your idm."
      end
      route_param :idm do
        get do
          user = User.find_by(idm: params[:idm])
          categories = Category.all
          hash = {
            number: user.number,
            role: user.role.japanese_name,
            name: user.name,
            email: user.email,
            idm: user.idm,
            average_level: user.average_level.value,
            total_experience: user.total_experience,
            next_average_level_required_experience: user.average_level.next.required_experience,
            statuses: [
            ],
            missions: [
            ]
          }
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
          user.assigns.each do |assign|
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
        histories = History.limit(10).order('created_at DESC')
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
        requires :idm, type: String, desc: "Your idm."
        requires :mission_id, type: Integer, desc: "Mission id."
      end
      post do
        authenticate!
        user = User.find_by(idm: params[:idm])

        if user
          history = History.new({user_id: user.id, mission_id: params[:mission_id]})
          mission = history.mission
          history.recent_experience = user.total_experience
          mission.acquisitions.each do |acquisition|
            category_id = acquisition.category_id
            status = user.statuses.find_by(category_id: category_id)
            status.experience += acquisition.experience
            status.save
          end
          history.experience = user.reload.total_experience
          user.reassign_missions
          history.save
          history
        end
      end

      desc "Return histories."
      params do
        requires :idm, type: String, desc: "Your idm."
      end
      route_param :idm do
        get do
          user = User.find_by(idm: params[:idm])
          histories = user.histories
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
  end
end