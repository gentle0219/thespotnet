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
          destination = [receiver.device_id]
          data = {key:"#{user.name} sent you message '#{params[:body]}'"}
          notif = GCM.send_notification( destination, data )
          if message.save
            Conversation.add_message(receiver, user, message)
            {success: "Your message has been sent successfully."}
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
          message = Message.find(params[:message_id])
          message.update_attribute(:read, true)
          {success: "Checked message"}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      get :messages do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          messages = user.received_messages.order_by('created_at DESC')
          {success: messages.map{|m| {id:m.id.to_s, body:m.body, level:m.level_of_number, sender_id:m.sender.id.to_s, sender_name:m.sender.name}}}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      get :staff_list do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          staffs = user.manager.members.reject{|u| u==user}
          {success: staffs.map{|st| {id:st.id.to_s, name:st.name, role:st.role_of_number}}}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      delete :messages do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          message_ids = params[:message_ids].split(',')
          messages = Message.in(id:message_ids)
          if messages.destroy_all
            {success: "This messages has been deleted"}
          else
            {failed: "Can't delete this message"}
          end          
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

    end
  end
end
