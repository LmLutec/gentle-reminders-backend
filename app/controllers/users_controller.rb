class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def loginattempt
    user = User.find_by(email: user_params[:email])

    if user && user.authenticate(user_params[:password])
        # token = encode_token({ user_id: user.id })
        # render json: { user: user, jwt: token }, status: :accepted
        render json: { user: user }, status: :accepted
    else 
 
        render json: {message: "Incorrect username/password"}
    end 
  end

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # POST /users
  def create
      @user = User.create(
        username: params[:username],
        password: params[:password],
        role: params[:role]
    )

    if @user.valid? 
        token = encode_token(user_id: @user.id)
        render json: { user: @user, jwt: token}, status: :created 
    else 
        render json: {message: @user.errors.messages} 
    end 
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
        @user.update(
            username: params[:username],
            password: params[:password],
            # favs: params[:favs],
            # hidden: params[:hidden],
            # read: params[:read]
        )
        render json: @user
  end

  # DELETE /users/1
  def destroy
    @users = User.all 
    @user = User.find(params[:id])
    @user.destroy
    render json: @user
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
