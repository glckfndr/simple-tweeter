import React, { useState, useEffect, use } from 'react';
import axios from '../utils/axiosConfig';
import createTweetChannel from '../channels/tweets_channel';
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

    const subscription = createTweetChannel((data) => {
      if (data.tweet) {
        setTweets((prevTweets) => [data.tweet, ...prevTweets]);
      } else if (data.delete) {
        setTweets((prevTweets) => prevTweets.filter(tweet => tweet.id !== data.delete));
      }
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [currentUserId, filter]);

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
      {isLoggedIn && <CreateTweet />}
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
            currentUser={currentUser}
            currentUserId={currentUserId}
            isLoggedIn={isLoggedIn}
          />
        ))}
      </ul>
    </div>
  );
};

export default Tweets;
