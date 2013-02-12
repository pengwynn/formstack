# Formstack

Simple Ruby wrapper for the [Formstack](http://formstack.com) API. 

## Disclaimer

You must use HTTPS with Oauth2, as there is no encryption or RSA-esque validation with Oauth2 requests. HTTPS is the onlything keeping Oauth2 access_tokens from being sniffed too easily.

## Installation

    sudo gem install formstack

### Using Bundler

    gem "formstack", :git => "git://github.com/TinderBox/formstack.git"


    
## Usage

You'll to [register your application](https://www.formstack.com/developers/applications/) and make note of your Client ID and Client Secret, and set up a Redirect URI.

To performe the authentication precedure, you could do the following if you are using something like rails:

### First Create the Connection

Begin the dance! / authorization process :-)

    def connect_to_formstack
      fs = FormStack::Oauth2Connection.new({
        :consumer_secret => client_secret,
        :consumer_key => client_id,
        :return_url => return_url # oauth_token_callback below
      })
      redirect_to fs.authorize()      
    end

You'll then be asked to allow your application to use FormStack's API

### Finish the Dance

At your redirect location, you'll want to do something like:

    def oauth_token_callback
      fs = FormStack::Oauth2Connection.new({
        :consumer_secret => client_secret,
        :consumer_key => client_id,
        :return_url => return_url,
        :use_ssl => Rails.env != "development"
      })
      access_token = fs.identify(params)
      if (not access_token.nil?)
        current_user.integrations[Integration::FORMSTACK] = {
          :access_token => access_token
        }

        flash[:notice] = "You have successfully connected to your formstack account!"
      else
        flash[:error] = "There was an error while connecting to your formstack account"
      end
    end
    

### Retreive your access token from wherever you saved it, and instantiate a FromStack::Connection object!

    @fs = FormStack::Connection.new({
      :access_token => "whatever-it-is"
    })

    You can now do everything through the gem that FormStack says you can do as in their API docs

### Listing your forms

    forms = @fs.forms.all
    
### Getting details for a single form

    form = @fs.forms.find(1234)
    
### Getting submission data for a form

    submission = form.submission(form_id)
    
### Submitting data

    form.create_submission(data = {})
    


## TODO:

* Handle file uploads for submissions
* Finish readme for all other calls
    

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
