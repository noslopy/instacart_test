require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'POST /users' do
    let(:username) { 'username' }
    let(:avatar_filename) { 'avatar.jpg' }
    let(:avatar) { fixture_file_upload(avatar_filename) }
    let(:params) { { user: { username: username, avatar: avatar } } }

    before do
      post '/users', params: params
    end

    context 'when valid parameters are provided' do
      it 'returns status 201' do
        expect(response.status).to eq(201)
      end

      it 'returns persisted user information' do
        expected = {
          id: 1,
          username: username,
          avatar: avatar_filename
        }.stringify_keys

        expect(JSON.parse(response.body)).to eq(expected)
      end

      it 'creates a user' do
        get '/users'

        expected = [
          {
            id: 1,
            username: username,
            avatar: avatar_filename
          }
        ].map(&:stringify_keys)

        expect(JSON.parse(response.body)).to eq(expected)
      end

      it 'stores an image' do
        expect(ActiveStorage::Blob.count).to eq(1)
      end
    end

    context 'when username is missing' do
      let(:username) { '' }

      it 'returns status 422' do
        expect(response.status).to eq(422)
      end

      it 'returns an error message "can\'t be blank"' do
        expect(JSON.parse(response.body)).to eq('errors' => ["Username can't be blank"])
      end

      it 'does not create a user' do
        get '/users'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end

      it 'does not store an image' do
        expect(ActiveStorage::Blob.count).to eq(0)
      end
    end

    context 'when avatar is missing' do
      let(:avatar) { nil }

      it 'returns status 422' do
        expect(response.status).to eq(422)
      end

      it 'returns an error message "can\'t be blank"' do
        expect(JSON.parse(response.body)).to eq('errors' => ["Avatar can't be blank"])
      end

      it 'does not create a user' do
        get '/users'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end

      it 'does not store an image' do
        expect(ActiveStorage::Blob.count).to eq(0)
      end
    end

    context 'when uploaded avatar is not an image' do
      let(:avatar_filename) { 'invalid_format.rb' }

      it 'returns status 422' do
        expect(response.status).to eq(422)
      end

      it 'returns an error message "is not a JPG not PNG image"' do
        expect(JSON.parse(response.body)).to eq(
          'errors' => ['Uploaded image is neither a JPG nor PNG image']
        )
      end

      it 'does not create a user' do
        get '/users'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end

      it 'does not store an image' do
        expect(ActiveStorage::Blob.count).to eq(0)
      end
    end

    context 'when uploaded avatar is too big' do
      let(:avatar_filename) { '288kb.jpg' }

      it 'returns status 422' do
        expect(response.status).to eq(422)
      end

      it 'returns an error message "is too big"' do
        expect(JSON.parse(response.body)).to eq(
          'errors' => ['File too large. Maximum limit of 200KB exceeded']
        )
      end

      it 'does not create a user' do
        get '/users'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end

      it 'does not store an image' do
        expect(ActiveStorage::Blob.count).to eq(0)
      end
    end
  end

  describe 'GET /users' do
    context 'when there are not users in the system' do
      it 'returns empty list' do
        get '/users'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are users in the system' do
      let(:user1_params) do
        { user: { username: 'User 1', avatar: fixture_file_upload('avatar.jpg') } }
      end

      let(:user2_params) do
        { user: { username: 'User 2', avatar: fixture_file_upload('avatar.jpg') } }
      end

      before do
        post '/users', params: user1_params
        post '/users', params: user2_params
      end

      it 'returns users information ordered by ID' do
        get '/users'

        expected = [
          {
            id: 1,
            username: 'User 1',
            avatar: 'avatar.jpg'
          },
          {
            id: 2,
            username: 'User 2',
            avatar: 'avatar.jpg'
          }
        ].map(&:stringify_keys)

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(expected)
      end
    end
  end
end
