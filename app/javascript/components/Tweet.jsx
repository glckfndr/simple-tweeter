import React, { useState } from 'react';
import axios from '../utils/axiosConfig';
import './Tweet.css';
import EditTweet from './EditTweet';

const Tweet = ({ tweet, onDelete, onUpdate, currentUser }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [likes, setLikes] = useState(tweet.likes ? tweet.likes.length : 0);

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

  const handleLike = () => {
    axios.post(`/tweets/${tweet.id}/like`)
      .then(response => {
        setLikes(likes + 1);
      })
      .catch(error => {
        console.error('There was an error liking the tweet!', error);
      });
  };

  const handleUnlike = () => {
    axios.delete(`/tweets/${tweet.id}/unlike`)
      .then(response => {
        setLikes(likes - 1);
      })
      .catch(error => {
        console.error('There was an error unliking the tweet!', error);
      });
  };

  return (
    <div className='tweet'>
      {isEditing ? (
        <EditTweet tweetId={tweet.id} onTweetUpdated={handleTweetUpdated} />
      ) : (
        <div>
          <p className='tweet__user'>posted by: {tweet.user.username}</p>
          <p>{tweet.content}</p>
          <p>Likes: {likes}</p>
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
          <button className="btn btn-small btn--primary" onClick={handleLike}>
            Like
          </button>
          <button className="btn btn-small btn--primary" onClick={handleUnlike}>
            Unlike
          </button>
        </div>
      )}
    </div>
  );
};

export default Tweet;
