module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :true_user
    identified_by :session_id
    impersonates :user

    def connect
      self.current_user = env["warden"].user
      self.session_id = request.session.id
      logger.add_tags "ActionCable", "User #{current_user.id}" if self.current_user
      reject_unauthorized_connection unless self.current_user || self.session_id
    end
  end
end
