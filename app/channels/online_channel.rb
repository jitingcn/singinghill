class OnlineChannel < ApplicationCable::Channel
  periodically :check_pings, every: 30.seconds

  def subscribed
    reject && return unless current_user

    @connection_token = generate_connection_token

    OnlineUser.store.update(
      @connection_token => { user_id: current_user.id,
                             last_updated: DateTime.current.to_i,
                             first_updated: DateTime.current.to_i,
                             location: "" }
    )

    stream_from "online:users"

    broadcast_to "users", { message: "[#{DateTime.current}] (#{current_user.name}) 上线了",
                            current_online: OnlineUser.current_online }
  end

  def unsubscribed
    return unless current_user

    OnlineUser.delete(@connection_token)

    broadcast_to "users", { message: "[#{DateTime.current}] (#{current_user.name}) 下线了",
                            drop: @connection_token }
  end

  def receive(data)
  end

  def appear(data)
    OnlineUser.update_location(@connection_token, data["location"])
    broadcast_to "users", { appear: [@connection_token, data["location"]] }
  end

  def current_online
    broadcast_to "users", { current_online: OnlineUser.current_online }
  end

  def ping
    OnlineUser.update_time(@connection_token)
  end

  private

  def check_pings
    OnlineUser.all.each do |connection_id, info|
      time_diff = DateTime.current.to_i - info["last_updated"]
      next unless time_diff > 300

      OnlineUser.delete(connection_id)
      # broadcast_to "users", { message: "(#{User.find(info["user_id"]).name}) 大概是掉线了" }
    end
  end

  def generate_connection_token
    SecureRandom.hex(4)
  end
end
