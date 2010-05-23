# Formstack

Simple Ruby wrapper for the [Formstack](http://formstack.com) (née Formspring) API. 

## Installation

    sudo gem install formstack
    
## Usage

You'll need a Formstack [API key](https://www.formstack.com/admin/apiKey/main) with appropriate permissions.

    require 'formstack'
    
    client = Formstack::Client.new("your_api_key")
    
### Listing your forms

    forms = client.forms
    
### Getting details for a single form

    form = client.form(1234)
    
### Getting submission data for a form

    data = client.data(1234, :page => 2)
    
### Submitting data

Here's where we apply some Ruby magic. The API requires you to know the IDs of your custom form fields (e.g. `field_123=blue`). You're more than welcome to use IDs for your hash keys if you like, but you don't have to:
    
    # hash keys correspond to the value of the `name` key in `form.fields`
    
    answers = {
      :name => 'Wynn Netherland',
      :rating => 5
    }
    
    # submit answers to form 1234 - field IDs are looked up on-the-fly
    client.submit(1234, :data => answers)
    
### Editing data

    # hash keys correspond to the value of the `name` key in `form.fields`
    
    answers = {
      :name => 'Wynn Netherland',
      :rating => 5
    }
    
    # edit answers for submission 10001
    client.edit(10001, :data => answers)
    
### Deleting data

    client.delete(10001)
    


## TODO:

* Handle file uploads for submissions
* Intelligent permission handling for different API key access levels
    

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright (c) 2010 Wynn Netherland. See LICENSE for details.
