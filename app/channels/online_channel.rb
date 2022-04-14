class OnlineChannel < ApplicationCable::Channel
  periodically :check_pings, every: 10.seconds

  def subscribed
    reject && return unless current_user

    @connection_token = generate_connection_token

    OnlineUser.store.update(
      @connection_token => { user_id: current_user.id, last_updated: DateTime.current.to_i, location: params[:location] }
    )

    stream_from "online:users"

    broadcast_to "users", { message: "[#{DateTime.current}] (#{current_user.name}) 上线了" }
  end

  def unsubscribed
    return unless current_user

    OnlineUser.delete(@connection_token)

    broadcast_to "users", { message: "[#{DateTime.current}] (#{current_user.name}) 下线了" }
  end

  def receive(data)
  end

  def appear(data)
    OnlineUser.update_location(@connection_token, data["location"])
    broadcast_to "users", { user: current_user.name, location: data["location"] }
  end

  def current_online
    broadcast_to "users", { current_online: OnlineUser.users.map(&:name) }
  end

  def ping
    OnlineUser.update_time(@connection_token)
  end

  private

  def check_pings
    OnlineUser.all.each do |connection_id, info|
      time_diff = DateTime.current.to_i - info["last_updated"]
      next unless time_diff > 300

      OnlineUser.get_connection_ids(info["user_id"]).each do |id|
        OnlineUser.delete(id)
      end
      broadcast_to "users", { message: "(#{User.find(info["user_id"]).name}) 大概是掉线了" }
    end
  end

  def generate_connection_token
    SecureRandom.hex(8)
  end
end
