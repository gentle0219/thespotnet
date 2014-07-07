module Endpoints
  class Spots < Grape::API

    resource :spots do
      
      desc "Send new message"
      post :messages do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          receiver = User.find(params[:receiver_id])
          subject = params[:level] + "Message"
          message = Message.new(subject:subject, body:params[:body], sender:user, receiver:receiver, level:params[:level])
          #Conversation::add_message(receiver, user, message)
          if message.save
            {success: "Sent message"}
          else
            {failed: message.errors.messages.to_json}
          end          
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      post :read_message do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          messages = Message.find(params[message_id])
          message.update_attribute(:read, true)
          {success: "Checked message"}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      get :messages do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          messages = user.received_messages
          {success: messages.map{|m| {id:m.id.to_s, body:m.body, level:m.level_of_number}}}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

    end
  end
end
