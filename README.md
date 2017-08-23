# Doorkeeper Devise Client

**Rails webapp acting as a Client application for interacting with another Rails webapp acting as a Doorkeeper-based OAuth Provider**

This app can be used to test a Doorkeeper-based OAuth Provider.
For e.g. the [doorkeeper provider example](http://doorkeeper-provider.herokuapp.com/).

This application is built on [Rails 5](http://github.com/rails/rails) and [Ruby 2.3.2](http://ruby-doc.org/core-2.3.2/) and uses following additional components:

* Authentication Library

  [Devise](http://github.com/plataformatec/devise)

* Omniauth Libraries:

    [omniauth](http://github.com/intridea/omniauth)
    [omniauth-oauth2]((https://github.com/intridea/omniauth-oauth2))

## About Doorkeeper Gem

Please refer the [doorkeeper gem documentation](https://github.com/doorkeeper-gem/doorkeeper) for details

## Installation & Configuration

If you want to run the application by yourself here are the steps for you.


### Clone the repo

1. Open a terminal

2. Change the current directory to a desired location where you would like to place the application. For e.g.
   `~/jignesh/ror_applications`. In the instructions below we would refer to it APP_ROOT_PARENT.

3. `APP_ROOT_PARENT$ mkdir doorkeeper-devise-client`

4. Change directory to the newly created folder

  ```
    APP_ROOT_PARENT$ cd doorkeeper-devise-client
    doorkeeper-devise-client$
  ```

5. Now clone the repo in the current directory `doorkeeper-devise-client`. In the instructions below we would refer to it APP_ROOT.

  ```
    APP_ROOT$ git clone https://github.com/jiggneshhgohel/doorkeeper-devise-client.git .
  ```

  *Note the `.` at the end. It indicates that clone the repo in current directory.*


6. Now change directory in following manner so that gemset wrappers gets created

  ```
    APP_ROOT$ cd ../<APP_ROOT>
  ```

  Relevant files `.ruby-gemset` and `.ruby-version` can be located under the
  APP_ROOT


### Install bundler


1. Assuming the current directory is APP_ROOT, run following command:

  ```
    APP_ROOT$ gem install bundler
  ```

  to install the `bundler` gem in the newly created gemset.


### Install Gems

1. Assuming the current directory is APP_ROOT, run following command:

  ```
    APP_ROOT$ bundle install
  ```

  to install all the gems defined in `Gemfile` under the
  APP_ROOT


### Setup Database

1. Assuming the current directory is APP_ROOT, run following command:

  ```
    APP_ROOT$ rake db:migrate
  ```

  That should create an SQLite DB file named `development.sqlite3`
  under location `<APP_ROOT>/db`

### Setup Doorkeeper-Provider-App URL and Credentials

1. Open up `<APP_ROOT>/config/initializers/01_doorkeeper_app_settings.rb`
   for editing and set the values, in your context, for following constants:

   * DOORKEEPER_APP_ID
   * DOORKEEPER_APP_SECRET
   * DOORKEEPER_PROVIDER_URL
   * DOORKEEPER_PROTECTED_ENDPOINT_PREFIX


  `DOORKEEPER_PROVIDER_URL` should point to the web-application which acts
  as Doorkeeper-based OAuth Provider. For e.g. let's say it is
  `doorkeeper-provider-app` and it is running on `localhost` at port `3000`.
  The `DOORKEEPER_PROVIDER_URL` should be set to `http://localhost:3000`

  `DOORKEEPER_APP_ID` and `DOORKEEPER_APP_SECRET` values can be obtained
  from the `doorkeeper-provider-app` by creating a new application on its end
  by navigating to `http://localhost:3000/oauth/applications` and then
  following the steps for creating a new application.

  `DOORKEEPER_PROTECTED_ENDPOINT_PREFIX` is the prefix for oauth protected
  routes in your `doorkeeper-provider-app`. For e.g. let's assume
  you have defined following routes in your `config/routes.rb` in
  `doorkeeper-provider-app` then

    ```
      namespace :oauth_protected, path: 'oauthorized' do
        defaults format: :json do
          get :me, to: 'users#me', as: :me
        end
      end
    ```

  then those routes should look like when using `rake routes` to list the
  available routes:

  ```
    oauth_protected_me GET    /oauthorized/me(.:format)     oauth_protected/users#me {:format=>:json}
  ```

  These constants are used in following files:

  ```
    <APP_ROOT>/app/utils/omniauth/strategies/doorkeeper.rb
    <APP_ROOT>/config/initializers/devise.rb
    <APP_ROOT>/app/controllers/api_controller.rb
  ```



### Start the application

Assuming the current directory is APP_ROOT, run following command:

  ```
    APP_ROOT$ rails s -p 5000
  ```
 
That should start your Rails application on port `5000`.

### Use the application

**Assumptions**

* Your `doorkeeper-provider-app` is running on `http://localhost:3000`

* In your `doorkeeper-provider-app` you have created a Doorkeeper application
with the Redirect URI in it set as `http://localhost:5000/users/auth/doorkeeper/callback`. This URI should point to the host of this application.

  * `doorkeeper-provider-app` has some users setup for e.g. say `admin@example.com` with password `password`

**Steps**

1. Open up a browser and type in `http://localhost:5000` and you should be see
an index page on which you should see a link `Sign in with OAuth 2 provider`.

2. Let's assume the user `admin@example.com` on `doorkeeper-provider-app` wants to connect his account in this client-application. For that he should click the 
`Sign in with OAuth 2 provider` link which should trigger the OAuth Authorization and Access Token workflow.

3. Assuming that the user `admin@example.com` has not already signed-in on `doorkeeper-provider-app` the user should see the Sign-in page of `doorkeeper-provider-app`. Filling in correct credentials should show a page asking for Authorizing the Doorkeeper-App whose credentials are configured in this client-application. This page should display two buttons namely **Authorize** and **Deny** buttons.

4. Clicking on **Authorize** button should make the `doorkeeper-provider-app` generate an Access Token for the user and redirect the user to the client-application.

5. At this point user should be able to see two links:

     * My Credentials 
     * Sign out 

     Clicking **My Credentials** should display a JSON in the browser
     containing basic data pulled from `doorkeeper-provider-app` for the
     user `admin@example.com` who connected his `doorkeeper-provider-app`'s
     account on this client-application.
 








