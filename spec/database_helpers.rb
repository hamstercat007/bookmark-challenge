require 'pg'
require './lib/database_connection'

def persisted_data(table:, id:)
  # connection = PG.connect(dbname: 'bookmark_manager_test')
  # result = connection.query("SELECT * FROM bookmarks WHERE id = $1;", [id])
  # result.first
  DatabaseConnection.query("SELECT * FROM #{table} WHERE id = $1;", [id])
end