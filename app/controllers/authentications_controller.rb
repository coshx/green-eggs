class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    if user_signed_in?
      current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
      flash[:notice] = "Account added"
    else
      uid =  auth[:uid]
      authentication = Authentication.where(:uid => uid).first
      if authentication
        #user exists
        user = authentication.user
        sign_in(user)
      else
        #new user
        image_url = auth[:info][:image]
        name = auth[:info][:name]
        email = auth[:info][:email]
        password_length = 8
        password = Devise.friendly_token.first(password_length)
        user = User.new(:image_url => image_url, :name => name, :email => email, :password => password, :password_confirmation => password)
        user.save!
        sign_in(user)
        Authentication.create(provider:auth['provider'], uid:auth['uid'], user_id:user.id)
        flash[:notice] = "Account created"
      end
    end
    redirect_to :root

  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

end