class AddUniqueIndexToLikes < ActiveRecord::Migration[7.0]
  def change
    # Remove duplicate entries
    execute <<-SQL
      DELETE FROM likes
      WHERE id IN (
        SELECT id FROM (
          SELECT id,
                  ROW_NUMBER() OVER (PARTITION BY user_id, tweet_id ORDER BY id) AS rnum
          FROM likes
        ) t
        WHERE t.rnum > 1
      );
    SQL

    add_index :likes, [:user_id, :tweet_id], unique: true
  end
end
