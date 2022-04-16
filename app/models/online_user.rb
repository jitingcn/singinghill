class OnlineUser
  class << self
    def store
      @store ||= Kredis.hash(:online_users, typed: :json)
    end

    def all
      store.to_h
    end

    def update_time(connection_id)
      current = store[connection_id]
      return if current.nil?

      current[:last_updated] = DateTime.current.to_i
      store.update(connection_id => current)
    end

    def update_location(connection_id, location)
      current = store[connection_id]
      return if current.nil?

      current[:location] = location
      store.update(connection_id => current)
    end

    def delete(connection_id)
      store.delete(connection_id)
    end

    def clear
      store.remove
    end

    def last_updated(user_id)
      store.values.group_by { |u| u["user_id"] }[user_id].map { |u| u["last_updated"] }.max
    end

    def users
      ids = store.values.map { |u| u["user_id"] }.uniq
      User.where(id: ids)
    end

    def get_connection_ids(user_id)
      store.to_h.select { |_k, v| v["user_id"] == user_id }.keys
    end
  end
end
