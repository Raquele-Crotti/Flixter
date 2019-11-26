# Flixter - A Video Streaming Platform
A two sided video streaming marketplace platform, featuring credit card payment capabilities, user role management, complex user interfaces and advanced database relationships.  Integration of Javascript, JSON, Ajax requests and secure payment capabilities using Stride. HTML5, CSS, Ruby, Rails, Algorithms, Javascript 

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)
* [Status](#status)
* [Sources](#sources)
* [Contact](#contact)

## General info
Similar to the Udemy platform, this application hosts an array of lessons that students are able to enroll in, pay for and take as well as a place for instructors to host their courses. There is the landing page which lists courses available to take, registration pages, course detail pages, image and video uploading, enrollment pages, payment processing, student and instructor dashboards, about pages, contact and social media hyperlinks.


## Technologies 
Project is created with:
* [ruby '2.5.3'](https://github.com/university-bootcamp/coding-environment/blob/master/README.md#coding-environment-installation-guide)
* gem 'rails', '~> 5.2.1'
* [activerecord 6.0.1](https://rubygems.org/gems/activerecord/versions/5.0.0.1)
* [Heroku](https://signup.heroku.com/t/platform?c=70130000001xDpdAAE&gclid=CjwKCAiAzuPuBRAIEiwAkkmOSM8vVAtL7RKLqoIVrshH7VuxMysxD2e1555A3dwyDU4sOSOxy6zujxoCXBIQAvD_BwE* [gem 'bootstrap', '~> 4.3', '>= 4.3.1'](https://github.com/twbs/bootstrap-rubygem)
* [gem 'pg', '>= 0.18', '< 2.0'](https://www.ibm.com/cloud/databases-for-postgresql)
* [HTML5](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5)
* [CSS](https://www.w3schools.com/html/html_css.asp)
* [gem 'devise'](https://github.com/plataformatec/devise)
* [AWS](https://aws.amazon.com/)
* [Stripe](https://stripe.com/)
* [Javascript](https://www.tutorialspoint.com/javascript/javascript_overview.htm)
* [Bootstrap](https://github.com/twbs/bootstrap-rubygem)
* [gem simpleform](https://github.com/plataformatec/simple_form)
* [Devise gem](https://github.com/plataformatec/devise)
* [Carrierwave](https://github.com/carrierwaveuploader/carrierwave)
## Setup   
Set up a development environment and start a new project

**Getting Started**

Go to one of the terminals within your coding environment and type the following:
  ```
  $ cd /vagrant/src
  ```
Create a new application that uses postgres
  ```
  $ rails new flixter --database=postgresql
  ```
Open newly created Flixter application in your text editor
Go to database.yml file and edit:
  ```
  username: postgres
  password: password
  host: localhost
  ```
  comment out last two lines on file for username and password.
Change directory into your Flixter project
  ```
  $ cd /vagrant/src/flixter
  ```
Create your initial database
  ```
  $ rake db:create
  ```
Start the server:
  ```
  $ rails server -b 0.0.0.0 -p 3000
  ```
In the second terminal window, type following command to move into Flixter folder:
  ```
  $ cd /vagrant/src/flixter
  ```
Set up web development pipeline:
  
  create new Github repository

  create project in heroku and then deploy it to heroku


**Build the Landing Page**
  ```
  $ rails generate controller static_pages
  ```
Edit config/routes.rb and add following line:
  ```
  root 'static_pages#index'
  ```
Open app/controllers/static_pages_controller.rb and add index method:
  ```
  def index
  end
  ```
Create new view file for index page at app/views/static_pages/index.html.erb and add some HTML:
  ```
  <h1>Welcome to my Awesome Flixter Application</h1>
  ```


**Allow Course Creation**

Run the following in the terminal to create model for courses so we can store the data of a course in the database:
  ```
  $ rails generate model course
  ```
Go to migration file (db/migrate/XXXX_create_courseses.rb) and add these lines in the courses table:
  ```
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.decimal :cost
      t.integer :user_id
      t.timestamps
    end
    add_index :courses, :user_id
  end
  ```
Run line in terminal:
  ```
  $ rake db:migrate
  ```
Set up associations between users and courses. Add user relationship to app/models/course.rb:
```
class Course < ApplicationRecord
  belongs_to :user
end
```
Edit app/models/user.rb so that users has many courses:
```
 has_many :courses
 ```
We must split the course controllers into two different controllers-one for the student role and one for the instructor role so they have two different URLs. In order to support this, we're going to use a feature of Rails controllers known as namespaces. The URLs of things inside a namespaced controller are prefixed with the name of the namespace.
```
$ rails generate controller instructor/courses
```
Connect new controller in the static_pages#index method section of config/routes.rb:
```
  namespace :instructor do
    resources :courses, only: [:new, :create, :show]
  end
```
Add action into the app/controllers/instructor/courses_controller.rb:
```
  def new
  end
```
Ensure user authentication with the before_action:
```
 before_action :authenticate_user!
```

**Adding the Form to the Page**

Edit app/controllers/instructor/courses_controller.rb to look like this:
```
class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!

  def new
    @course = Course.new
  end
end
```
We can add the form on the app/views/instructor/courses/new.html.erb page, using SimpleForm:
```
<br />
<div class="booyah-box col-10 offset-1">
  <h1>Add a new course</h1>
  <%= simple_form_for @course, url: instructor_courses_path do |f| %>
    <%= f.input :title %>
    <%= f.input :description %>
    <%= f.input :cost %>
    <br />
    <%= f.submit "Create", class: 'btn btn-primary' %>
    <br />
  <% end %>
  <br />
</div>
```
Add link (in my case it was in the footer) to go to the instructor course creation page:
```
 <%= link_to 'Teach a Course', new_instructor_course_path %>
 ```
 **Hooking Up the Create Action**

When a user pushes the submit button on our new form, we want two things to happen:
- A course will be created in our database that is connected to the currently logged-in user.
- The user will be sent the instructor view on the course page.

Edit app/controllers/instructor/courses_controller.rb and add the entire create action with the following code:
```
  def create
    @course = current_user.courses.create(course_params)
    redirect_to instructor_course_path(@course)
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :cost)
  end
```

**Building a Simple Instructor Show Page**
Add the show action into our instructor/courses controller and load the correct course from our database. We will do this by looking up the course by its id.
```
  before_action :authenticate_user!

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    redirect_to instructor_course_path(@course)
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :cost)
  end
end
```
Create a simple view in order to ensure thigns are working:
Create a new file app/views/instructor/courses/show.html.erb and make it look like this:
```
<br />
<div class="booyah-box col-10 offset-1">
  <h1 class="text-center"><%= @course.title %></h1>
</div>
```

Be sure to take the same steps to push changes to Github and deploy to Heroku.

## Status
Project is fully-functioning, user-friendly and complete. You can find it deployed on heroku via: [Flixter Application](https://flixter-raquele-crotti.herokuapp.com/)


## Sources
This app was created during my time completing UC Berkeley Extension's  Coding Bootcamp Program.

## Contact 
* [Portfolio](https://www.raquelecrotti.com/)
* [LinkedIn](https://www.linkedin.com/in/raquele-crotti/)
* [Github](https://github.com/Raquele-Crotti)
