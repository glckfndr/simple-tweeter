import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import Tweet from './Tweet';
import CreateTweet from './CreateTweet';
import './Tweets.css';

const Tweets = () => {
  const [tweets, setTweets] = useState([]);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [currentUserId, setCurrentUserId] = useState(null);
  const [filter, setFilter] = useState('all'); // 'all' or 'followees'
  const [followees, setFollowees] = useState([]);

  useEffect(() => {
    axios.get('/tweets')
      .then(response => {
        setTweets(JSON.parse(response.data.tweets));
        setIsLoggedIn(response.data.isLoggedIn);
        setCurrentUser(response.data.currentUser);
        setCurrentUserId(response.data.currentUserId);
      })
      .catch(error => {
        console.error("There was an error fetching the tweets!", error);
      });

    axios.get(`/users/${currentUserId}/followees`)
      .then(response => {
        setFollowees(response.data.followees);
      })
      .catch(error => {
        console.error("There was an error fetching the followees!", error);
      });
  }, [currentUserId]);

  const handleDelete = (id) => {
    setTweets(tweets.filter(tweet => tweet.id !== id));
  };

  const handleTweetCreated = (newTweet) => {
    setTweets([newTweet, ...tweets]);
  };

  const filteredTweets = filter === 'all' ? tweets :
      tweets.filter(tweet => followees.some(followee => followee.id === tweet.user_id));

  return (
    <div className="tweets">
      {isLoggedIn && <CreateTweet onTweetCreated={handleTweetCreated} />}
      <div className="tweets__filter">
        <button onClick={() => setFilter('all')} className={"btn " + (filter === 'all' ? 'active' : '')}>
          All Tweets
        </button>
        <button onClick={() => setFilter('followees')} className={"btn " +  (filter === 'followees' ? 'active' : '')}>
          Followees Tweets
          </button>
      </div>
      <ul className="tweets__list">
        {filteredTweets.map(tweet => (
          <Tweet
            key={tweet.id}
            tweet={tweet}
            onDelete={handleDelete}
            onUpdate={handleTweetCreated}
            currentUser={currentUser}
          />
        ))}
      </ul>
    </div>
  );
};

export default Tweets;
