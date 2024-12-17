import React, { useEffect, useState } from 'react';
import axios from 'axios';
import './Tweets.css';
import TweetItem from './TweetItem';

function Tweets() {
  const [tweets, setTweets] = useState([]);

  useEffect(() => {
    axios.get('api/v1/tweets/index', {headers: { "Content-Type": "application/json" }})
      .then(response => {
        console.log(response.data);
        setTweets(response.data);
      })
      .catch(error => {
        console.error('There was an error fetching the tweets!', error);
      });
  }, []);

  return (
    <div className='tweets'>
      <h2>All Tweets</h2>
      <ul className='tweets__list'>
        {tweets.map(tweet => (
            <TweetItem key={tweet.id} tweet={tweet} />
        ))}
      </ul>
    </div>
  );
}

export default Tweets;
