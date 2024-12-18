import React from 'react'
import './TweetItem.css';

function TweetItem({tweet}) {
  return (
    <li key={tweet.id}  className="tweet">
      <div>
        <p className="tweet__author">{tweet.user.username}</p>
        <p className="tweet__content">{tweet.content}</p>
        <hr />
        <div className="tweet__info">
              <p className="tweet__date">created: {new Date(tweet.created_at).toLocaleString()}</p>
              <p className="tweet__date">updated: {new Date(tweet.updated_at).toLocaleString()}</p>
        </div>
      </div>
    </li>
  )
}

export default TweetItem
