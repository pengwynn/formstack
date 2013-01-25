# Formstack

Simple Ruby wrapper for the [Formstack](http://formstack.com) API. 

## Installation

    sudo gem install formstack

### Using Bundler

    gem "formstack", :git => "git://github.com/TinderBox/formstack.git"


    
## Usage

You'll to [register your application](https://www.formstack.com/developers/applications/) and make note of your Client ID and Client Secret, and set up a Redirect URI.

    require 'formstack'
    
    FormStack.configure do |c| 
      c.client_id = < client_id >
      c.client_secret = < client_secret >
      c.return_url = < return_url >
      c.access_token = < access_token >
    end

The Access Token doesn't need to be set, as you won't have it until after the Oauth dance. 
To performe the authentication precedure, you could do the following if you are using something like rails:

### First Create the Connection

Have a method where you can create the FormStack connection

    def create_connection(access_token = false)
      FormStack.configure do |c|
        c.client_id = client_id
        c.client_secret = client_secret
        c.return_url = return_url
        c.access_token = (!!access_token ? access_token]: nil)
      end
      @connection = FormStack.connection
    end

Then begin the dance!

    create_connection()
    redirect_to @connection.connect()

You'll then be asked to allow your application to use FormStack's API

### Finish the Dance

At your redirect location, you'll want to do something like:

    create_connection()
    access_token = @connection.identify(params)
    if (not access_token.nil?)
      current_user.integrations[Integration::FORMSTACK] = {
        :access_token => access_token
      }

      flash[:notice] = "You have successfully connected to your application!"
    else
      flash[:error] = "There was an error while connecting to your application!"
    end
    
### Listing your forms

    forms = FormStack::Form.all
    
### Getting details for a single form

    form = FormStack::Form.find(1234)
    
### Getting submission data for a form

    submission = form.submission(form_id)
    
### Submitting data

    form.create_submission(data = {})
    


## TODO:

* Handle file uploads for submissions
* Handle updating of objects
* Handle deletion of objects
    

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### License

http://opensource.org/licenses/MIT
