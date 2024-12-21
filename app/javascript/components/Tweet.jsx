// filepath: /home/obula/railsProjects/internship_test_glckfndr_2025/app/javascript/components/Tweet.jsx
import React from 'react';
import axios from '../utils/axiosConfig';
import './Tweet.css';

const Tweet = ({ tweet, onDelete, currentUser }) => {
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

  return (
    <div className='tweet'>
      <div>
      <p className='tweet__user'>posted by: {tweet.user.username}</p>
      <p>{tweet.content}</p>
      </div>
      {currentUser === tweet.user.username && (
        <button className="btn btn-small btn--danger" onClick={handleDelete}>
          Delete
        </button>
      )}
    </div>
  );
};

export default Tweet;
