json.session do
  json.(@user, :id, :nickname, :admin?)
  json.token @user.authentication_token
end
