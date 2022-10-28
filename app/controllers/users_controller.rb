class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_confirm_password")


    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", {:notice => "Welcome #{user.username}!"})
    else
      #.to_sentence to convert it to a more human readable sentence
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

  def sign_up_form
    render ({:template => "/users/signup_form.html.erb"})
  end

  def sign_in_form
    render ({:template => "/users/signin_form.html.erb"})
  end

  def authenticate

    # get the username from params
    # get the password from params
    username=params["input_username"]
    password=params["input_password"]

    # look up the user in the DB by matching on username
    user=User.where({:username => username})[0]

    
    # if there is a user in DB with that username, check if the passwords match
   
   

    if user != nil
      if user.authenticate(password)
         # if passwords match, set the cookie + redirect to homepage
        session.store(:user_id, user.id)
        redirect_to("/", {:notice => "Welcome back, #{username}!"})
      else 
        # if passwords don't match, redirect to sign in page
        redirect_to("/user_sign_in", {:alert => "Nice try, sucker!"})
      end

    else
      # if no user is found with that username, redirect back to sign in form
      redirect_to("/user_sign_in", {:alert => "No one by that name 'round these parts"})
    end

  end

  def destroy_cookies
    reset_session
    redirect_to("/", :notice => "See ya later!")
  end
end
