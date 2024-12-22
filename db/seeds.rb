# filepath: /home/obula/railsProjects/internship_test_glckfndr_2025/db/seeds.rb

# Clear existing data
User.destroy_all
Tweet.destroy_all
Retweet.destroy_all
Follow.destroy_all

# Create users
user1 = User.create!(email: 'user1@example.com', password: 'password', username: 'user1')
user2 = User.create!(email: 'user2@example.com', password: 'password', username: 'user2')
user3 = User.create!(email: 'user3@example.com', password: 'password', username: 'user3')

# Create tweets
tweet1 = Tweet.create!(content: 'This is the first tweet', user: user1)
tweet2 = Tweet.create!(content: 'This is the second tweet', user: user2)
tweet3 = Tweet.create!(content: 'This is the third tweet', user: user3)

# Create retweets
Retweet.create!(user: user2, tweet: tweet1)
Retweet.create!(user: user3, tweet: tweet1)
Retweet.create!(user: user1, tweet: tweet2)
Retweet.create!(user: user3, tweet: tweet2)
Retweet.create!(user: user1, tweet: tweet3)
Retweet.create!(user: user2, tweet: tweet3)

# Create followers
Follow.create!(follower: user1, followee: user2)
Follow.create!(follower: user1, followee: user3)
Follow.create!(follower: user2, followee: user1)
Follow.create!(follower: user2, followee: user3)
Follow.create!(follower: user3, followee: user1)
Follow.create!(follower: user3, followee: user2)

puts "Database has been seeded with users, tweets, retweets, and followers."
