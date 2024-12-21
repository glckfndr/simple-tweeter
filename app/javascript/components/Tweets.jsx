import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import Tweet from './Tweet';
import CreateTweet from './CreateTweet';
import "./Tweets.css";

const Tweets = () => {
  const [tweets, setTweets] = useState([]);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);

  useEffect(() => {
    axios.get('/tweets')
      .then(response => {
        setTweets(JSON.parse(response.data.tweets));
        setIsLoggedIn(response.data.isLoggedIn);
        setCurrentUser(response.data.currentUser);
      })
      .catch(error => {
        console.error("There was an error fetching the tweets!", error);
      });
  }, []);

  const handleDelete = (id) => {
    setTweets(tweets.filter(tweet => tweet.id !== id));
  };

  const handleTweetCreated = (newTweet) => {
    setTweets([newTweet, ...tweets]);
  };

  return (
    <div className="tweets">
      {isLoggedIn && <CreateTweet onTweetCreated={handleTweetCreated} />}
      <ul className="tweets__list">
        {tweets.map(tweet => (
          <Tweet key={tweet.id}
          tweet={tweet}
          onDelete={handleDelete}
          currentUser={currentUser}/>
        ))}
      </ul>
    </div>
  );
};

export default Tweets;