require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/seeds_albums.sql')
  if ENV["PG_password"] 
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test', password: ENV["PG_password"] })
  else
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test'})
  end
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  if ENV["PG_password"] 
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test', password: ENV["PG_password"] })
  else
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test'})
  end
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    xit 'should return the list of albums' do
      # Assuming the post with id 1 exists.
      response = get('albums')

      expected_response = 'Doolittle, Surfer Rosa, Super Trouper, Bossanova'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "GET /artists" do
    it 'should return the list of artsits' do
      response = get('artists')

      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

    context "POST /albums" do
      it 'should create a new album' do
        response = post('albums', title: 'OK Computer', release_year: '1997', artist_id: '1')
        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        response = get('/albums')

        expect(response.body).to include('OK Computer')
      end
    end

    context "POST /artists" do 
      it 'should create a new artist' do 
        response = post('artists', name: 'Wild nothing', genre: 'Indie')
        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        response = get('/artists')

        expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing'

        expect(response.body).to eq(expected_response)
      end
    end

    context "GET /album/:id" do
      it "should return info about album 1" do
        response = get('/albums/1')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('Doolittle')
        expect(response.body).to include('Release year: 1989')
        expect(response.body).to include('Artist: Pixies')
      end
    end 

    context "GET /album" do
      it "should return info about list of albums" do
        response = get('/albums')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('Title: Doolittle')
        expect(response.body).to include('Title: Surfer Rosa')
        expect(response.body).to include('Title: Super Trouper')
      end
    end 
end
