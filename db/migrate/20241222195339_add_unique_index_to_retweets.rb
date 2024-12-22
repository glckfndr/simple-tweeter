class AddUniqueIndexToRetweets < ActiveRecord::Migration[7.0]
  def change
    # Remove duplicate entries
    execute <<-SQL
      DELETE FROM retweets
      WHERE id IN (
        SELECT id FROM (
          SELECT id,
                 ROW_NUMBER() OVER (PARTITION BY user_id, tweet_id ORDER BY id) AS rnum
          FROM retweets
        ) t
        WHERE t.rnum > 1
      );
    SQL

    # Add unique index
    add_index :retweets, [:user_id, :tweet_id], unique: true
  end
end
