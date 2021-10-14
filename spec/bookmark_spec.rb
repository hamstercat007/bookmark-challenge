require 'bookmark'
require 'database_helpers'

describe Bookmark do

  let(:comment_class) { double(:comment_class) }

  describe '#comments' do
  it 'calls .where on the Comment class' do
    bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://makers.tech')
    expect(comment_class).to receive(:where).with(bookmark_id: bookmark.id)

    bookmark.comments(comment_class)
  end
end

  describe '.all' do
    it 'returns a list of bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')
   
      # Add the test data
      bookmark = Bookmark.create(url: "http://makers.tech", title: "Makers Academy")
      Bookmark.create(url: "http://www.destroyallsoftware.com", title: "Destroy All Software")
      Bookmark.create(url: "http://www.google.com", title: "Google")
      bookmarks = Bookmark.all
      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Makers Academy'
      expect(bookmarks.first.url).to eq 'http://makers.tech'
     end
   end

   describe '.create' do
    it 'does not create a new bookmark if the URL is not valid' do
      Bookmark.create(url: 'not a real bookmark', title: 'not a real bookmark')
      expect(Bookmark.all).to be_empty
    end
  end

  describe '.delete' do
    it 'deletes the given bookmark' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://makers.tech')
  
      Bookmark.delete(id: bookmark.id)
  
      expect(Bookmark.all.length).to eq 0
    end
  end


  describe '.update' do
    it 'updates the bookmark with the given data' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://makers.tech')
      updated_bookmark = Bookmark.update(id: bookmark.id, url: 'http://www.snakersacademy.com', title: 'Snakers Academy')

      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'Snakers Academy'
      expect(updated_bookmark.url).to eq 'http://www.snakersacademy.com'
    end
  end

  describe '.find' do
    it 'returns the requested bookmark object' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://makers.tech')

      result = Bookmark.find(id: bookmark.id)

      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'Makers Academy'
      expect(result.url).to eq 'http://makers.tech'
    end
  end

  describe '#comments' do
    it 'returns a list of comments on the bookmark' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://makers.tech')
      DatabaseConnection.query(
        "INSERT INTO comments (id, text, bookmark_id) VALUES(1, 'Test comment', $1)", [bookmark.id] 
      )
      comment = bookmark.comments.first

      expect(comment.text).to eq 'Test comment'
    end
  end
end 