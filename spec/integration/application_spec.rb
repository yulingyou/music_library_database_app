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

  context 'GET /albums/new' do
    it 'should return the form to add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context "GET /albums" do
    it 'should return the list of albums as HTML page with links' do
      # Assuming the post with id 1 exists.
      response = get('albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('Title: <a href="/albums/1"> Doolittle</a>')
      expect(response.body).to include('Released: 1989')
      expect(response.body).to include('Title: <a href="/albums/3"> Super Trouper</a>')
      expect(response.body).to include('Released: 1980')
    end
  end

  context "GET /artists" do
    it 'should return the list of artsits' do
      response = get('artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a>')
    end
  end

  context 'GET /albums/new' do
    it 'should return the form to add a new artist' do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" genre="genre" />')
    end
  end

    context "POST /albums" do
      it 'should validate album parameters' do
        response = post(
          '/albums',
        invalid_artist_title: 'OK Computer',
        another_invalid_thing: 123)

        expect(response.status).to eq(400)
      end
      it 'should create a new album' do
        response = post('albums', title: 'OK Computer', release_year: '1997', artist_id: '1')
        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        response = get('/albums')

        expect(response.body).to include('OK Computer')
      end
    end

    context "POST /artists" do 
      xit 'should create a new artist' do 
        response = post('artists', name: 'Wild nothing', genre: 'Indie')
        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        response = get('/artists')

        expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing'

        expect(response.body).to eq(expected_response)
      end
    end

    context "GET /albums/:id" do
      it "should return info about album 1" do
        response = get('/albums/1')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('Doolittle')
        expect(response.body).to include('Release year: 1989')
        expect(response.body).to include('Artist: Pixies')
      end
    end 

    context "GET /artists/:id" do
      it "should return info about artist 1" do
        response = get('/artists/1')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('Pixies')
        expect(response.body).to include('Genre: Rock')
      end
    end 

    context "GET /albums" do
      xit "should return info about list of albums" do
        response = get('/albums')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('Title: Doolittle')
        expect(response.body).to include('Title: Surfer Rosa')
        expect(response.body).to include('Title: Super Trouper')
      end
    end 
end
