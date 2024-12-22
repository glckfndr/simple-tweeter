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
        setTweets(response.data.tweets);
        setIsLoggedIn(response.data.isLoggedIn);
        setCurrentUser(response.data.currentUser);
        setCurrentUserId(response.data.currentUserId);
      })
      .catch(error => {
        console.error("There was an error fetching the tweets!", error);
      });
    currentUserId &&
      axios.get(`/users/${currentUserId}/followees`)
        .then(response => {
          setFollowees(response.data.followees);
        })
        .catch(error => {
          console.error("There was an error fetching the followees!", error);
        });
  }, [currentUserId, filter]);

  const handleDelete = (id) => {
    setTweets(tweets.filter(tweet => tweet.id !== id));
  };

  const handleTweetCreated = (newTweet) => {
    setTweets([newTweet, ...tweets]);
  };

  function getFolloweesTweets() {
    return tweets.filter(tweet => followees.some(followee => followee.id === tweet.user_id));
  }

  const getFolloweeRetweets = () => {

    return tweets.filter(tweet => tweet.retweets &&
      tweet.retweets.some(retweet =>
        followees.some(followee => followee.id === retweet.user_id)));
  };

  const filteredTweets = filter === 'all' ? tweets :
    filter === 'followees' ? getFolloweesTweets() :
      getFolloweeRetweets();

  return (
    <div className="tweets">
      {isLoggedIn && <CreateTweet onTweetCreated={handleTweetCreated} />}
      <div className="tweets__filter">
        <button onClick={() => setFilter('all')} className={"btn " + (filter === 'all' ? 'active' : '')}>
          All Tweets
        </button>
        <button onClick={() => setFilter('followees')} className={"btn btn--joy " + (filter === 'followees' ? 'active' : '')}>
          Followees Tweets
        </button>
        <button onClick={() => setFilter('retweeted')} className={"btn btn--primary " + (filter === 'retweeted' ? 'active' : '')}>Retweeted Tweets</button>
      </div>
      <ul className="tweets__list">

        {filteredTweets.map(tweet => (
          <Tweet
            key={tweet.id}
            tweet={tweet}
            onDelete={handleDelete}
            onUpdate={handleTweetCreated}
            currentUser={currentUser}
            currentUserId={currentUserId}
          />
        ))}
      </ul>
    </div>
  );
};

export default Tweets;
