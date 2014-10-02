module Aoca
  class API < Grape::API
    version 'v1', using: :header, vendor: 'aoca'
    format :json

    resource :users do
    end

    resource :histories do
    end
  end
end
