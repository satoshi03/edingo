class UsersController < ApplicationController
  require 'nokogiri'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    user = User.find_by_id(params[:id])
    (render_error(404, "Resource not found") and return) unless user
    respond_to do |format|
      format.xml { render :xml => create_xml(user) }
      format.json { render :json => create_json(user) }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name)
    end

    def create_xml(users)
      users = [users] unless users.class == Array
      xml = build_xml do |xml|
        xml.users {
          users.each do |user|
            xml.user(:id => user.id) {
              xml.name(user.name)
              xml.updated_at(user.updated_at)
              xml.created_at(user.created_at)
            }
          end
        }
      end
    end
  
    def create_json(users)
      users = [users] unless users.class == Array
      users = users.inject([]){ |array, user|
        array << {
         :id => user.id,
          :name => user.name,
          :updated_at => user.updated_at,
          :created_at => user.created_at
        }; array
      }
      { :users => users }.to_json
    end
  
    def build_xml(&block)
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml| yield(xml) }
      builder.to_xml
    end
  
    def render_error(status, msg)
      render :text => msg, :status => status
    end

end
