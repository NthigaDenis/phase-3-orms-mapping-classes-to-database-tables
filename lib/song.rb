class Song

  attr_accessor :name, :album , :id
  # DB[:conn]
  # id ==> attribute that has a default value of nil,, because they will be saved into the database and we know that each table row needs an id value which is the primary key
  def initialize(name:, album:, id:nil)
    @name = name
    @album = album
    @id = id
  end
  # class method
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL
    # insert the song
    DB[:conn].execute(sql, self.name, self.album)
    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self

  end
  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end