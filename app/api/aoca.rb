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
        User.limit(10).order('created_at DESC')
      end

      desc "Return a status."
      params do
        requires :idm, type: String, desc: "Your idm."
      end
      route_param :idm do
        get do
          User.find_by(idm: params[:idm])
        end
      end

    end

    resource :histories do
      desc "Return a public timeline."
      get '/' do
        History.limit(10).order('created_at DESC')
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
    end
  end
end
