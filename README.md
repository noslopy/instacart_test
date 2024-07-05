# Ruby on Rails: User Avatar Upload

## Project Specifications

**Read-Only Files**
- spec/*

**Environment**  

- Ruby version: 2.7.1
- Rails version: 6.0.2
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
```
- install: 
```bash
source ~/.rvm/scripts/rvm && rvm --default use 2.7.1 && bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

In this challenge, you are part of a team that is building a social network. One requirement is for a REST API service to register user profile pictures using the Ruby on Rails framework and ActiveStorage. You will be dealing with basic user information as well as image upload. The team has come up with a set of requirements including API format, response codes, and data validations.

The definitions and detailed requirements list follow. You will be graded on whether your application performs data persistence and retrieval based on given use cases exactly as described in the requirements.

Each user has the following structure:

- id: The unique ID of the user
- username: The username of the user
- avatar: The profile picture of the user

### Sample user JSON:

```
{
  "id": 1,
  "username": "username",
  "avatar": "avatar.png"
}
```

## Requirements:

`POST /users`:
* creates a new user record
* stores the uploaded image using ActiveStorage
* performs the following validations of the incoming parameters:
  * username should be present
  * avatar should be present
  * avatar should be a JPG or PNG image file
  * avatar size should be no more than 200 kilobytes
* adds the given object to the database and assigns a unique integer `id` to it
* the response code is `201`, and the response body is the JSON with the created user information
* if any of the validations above fail, return status code `422` and a corresponding error message. Please see the "Sample requests and responses" section for more details.


`GET /users`:
- the response code is 200
- the response body is an array of all users, ordered by their `id` in increasing order 

## Sample requests and responses

`POST /users`

* Example request:
  ```
  {
    "username": "username",
    "avatar": <UploadedFile filename="image.png">
  }
  ```

  Response:
  ```
  {
    "id": 1,
    "username": "username",
    "avatar": "image.png"
  }
  ```

* Example request:
  ```
  {
    "username": "",
    "avatar": <UploadedFile filename="image.png">
  }
  ```

  Response:
  ```
  {
    "errors": ["Username can't be blank"]
  }
  ```

* Example request:
  ```
  {
    "username": "username"
  }
  ```

  Response:
  ```
  {
    "errors": ["Avatar can't be blank"]
  }
  ```

* Example request:
  ```
  {
    "username": "username",
    "avatar": <UploadedFile filename="invalid_format.txt">
  }
  ```

  Response:
  ```
  {
    "errors": ["Uploaded image is neither a JPG nor PNG image"]
  }
  ```

* Example request:
  ```
  {
    "username": "username",
    "avatar": <UploadedFile filename="500-kilobytes.jpg">
  }
  ```

  Response:
  ```
  {
    "errors": ["File too large. Maximum limit of 200KB exceeded"]
  }
  ```

`GET /users`

* Example response:
  ```
  [
    {
      "id": 1,
      "username": "username1",
      "avatar": "portrait.png"
    },
    {
      "id": 2,
      "username": "username2",
      "avatar": "landscape.png"
    }
  ]
  ```
