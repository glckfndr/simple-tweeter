import React, { useState } from 'react';
import axios from '../utils/axiosConfig';
import './Tweet.css';
import EditTweet from './EditTweet';

const Tweet = ({ tweet, onDelete, onUpdate, currentUser }) => {
  const [isEditing, setIsEditing] = useState(false);

  const handleDelete = () => {
    axios.delete(`/tweets/${tweet.id}`)
      .then(response => {
        console.log('Tweet deleted');
        onDelete(tweet.id);
      })
      .catch(error => {
        console.error('There was an error deleting the tweet!', error);
      });
  };

  const handleEdit = () => {
    setIsEditing(true);
  };

  const handleTweetUpdated = (updatedTweet) => {
    setIsEditing(false);
    onUpdate(updatedTweet);
  };

  return (
    <div className='tweet'>
      {isEditing ? (
        <EditTweet tweetId={tweet.id} onTweetUpdated={handleTweetUpdated} />
      ) : (
        <div>
          <p className='tweet__user'>posted by: {tweet.user.username}</p>
          <p>{tweet.content}</p>
          {currentUser === tweet.user.username && (
            <>
              <button className="btn btn-small btn--danger" onClick={handleDelete}>
                Delete
              </button>
              <button className="btn btn-small btn--primary" onClick={handleEdit}>
                Edit
              </button>
            </>
          )}
        </div>
      )}
    </div>
  );
};

export default Tweet;
