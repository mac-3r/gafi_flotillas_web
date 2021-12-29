class OneSignalDevice < ApplicationRecord
    belongs_to :user
    def self.crear(user_params, user)
        if user_params[:player_id] != nil
            one_signal = self.new(
                token: user_params[:token],
                player_id: user_params[:player_id],
                api_token_expires_at: DateTime.now + 1.month,
                user_id: user.id
            )
            if one_signal.save
            return one_signal
            end
        end
    end
    
    def self.verificar_player_id(players_registrados, user_params)      
        onesignal = self.find_by(user_id: players_registrados[0].user_id)
        if onesignal != nil
            onesignal.update(player_id: user_params[:player_id])
        end
        # if ! players_registrados.map{|x| x.player_id}.include?(user_params[:player_id])  
        #     OneSignalDevice.crear(user_params,players_registrados[0].user_id)
        # end
    
    end
    
end