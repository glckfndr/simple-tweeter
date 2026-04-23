import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import './EditTweet.css';

const EditTweet = ({ tweetId, onTweetUpdated }) => {
  const [content, setContent] = useState('');

  useEffect(() => {
    axios.get(`/tweets/${tweetId}/edit`)
      .then(response => {
        setContent(response.data.content);
      })
      .catch(error => {
        console.error('There was an error fetching the tweet!', error);
      });
  }, [tweetId]);

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.put(`/tweets/${tweetId}`, { tweet: { content } })
      .then(response => {
        onTweetUpdated(response.data);
      })
      .catch(error => {
        console.error('There was an error updating the tweet!', error);
      });
  };

  const handleContentChange = (e) => {
    if (e.target.value.length > 255) {
      return;
    }
    setContent(e.target.value);
  }
  return (
    <form onSubmit={handleSubmit} >
      <div className='edit-tweet'>
        <textarea rows={4} cols={80} className='edit-tweet__content'
          value={content}
          onChange={handleContentChange}
        />
        <div>

          <button className='btn btn-small' type="submit">Update Tweet</button>
        </div>
      </div>
    </form>
  );
};

export default EditTweet;
