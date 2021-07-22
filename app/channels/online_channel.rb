class OnlineChannel < ApplicationCable::Channel
  def subscribed
    return unless current_user

    ActionCable.server.pubsub.redis_connection_for_subscriptions.sadd "online", current_user.id

    stream_from "online:users"

    broadcast_to "users", { id: current_user.id, status: "online" }
  end

  def unsubscribed
    return unless current_user

    ActionCable.server.pubsub.redis_connection_for_subscriptions.srem "online", current_user.id

    broadcast_to "users", { id: current_user.id, status: "offline" }
  end
end
