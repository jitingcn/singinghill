class OnlineChannel < ApplicationCable::Channel
  def subscribed
    return unless current_user

    ActionCable.server.pubsub.redis_connection_for_subscriptions.zincrby "online", 1, current_user.id

    stream_from "online:users"

    broadcast_to "users", { user: current_user.name, status: "online", time: Time.current }
  end

  def unsubscribed
    return unless current_user

    count = ActionCable.server.pubsub.redis_connection_for_subscriptions.zincrby "online", -1, current_user.id
    if count.to_i == 0
      ActionCable.server.pubsub.redis_connection_for_subscriptions.zrem "online", current_user.id
    end

    broadcast_to "users", { user: current_user.name, status: "offline", time: Time.current }
  end

  def receive(data)
  end

  def appear(data)
    broadcast_to "users", { user: current_user.name, location: data["location"] }
  end

  def current_online
    broadcast_to "users", { current_online: User.online.map {_1.name} }
  end
end
