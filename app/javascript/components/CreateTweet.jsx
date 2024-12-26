import React, { useState } from 'react';
import axios from '../utils/axiosConfig';
import './CreateTweet.css';

const CreateTweet = () => {
  const [content, setContent] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post('/tweets', { tweet: { content } })
      .then(response => {
        setContent(''); // Clear the textarea after successful tweet creation
      })
      .catch(error => {
        console.error('There was an error creating the tweet!', error);
      });
  };

  const handleContentChange = (e) => {
    if (e.target.value.length > 255) {
      return;
    }
    setContent(e.target.value);
  }

  return (
    <form onSubmit={handleSubmit}>
      <div className='create-tweet'>
        <h3 className="create-tweet__title">Tweets</h3>
        <textarea rows={4} cols={70}
          className='create-tweet__content'
          value={content}
          onChange={handleContentChange}
          placeholder="Comment tweet..." />
        <button className='btn btn--small' type="submit">Create Tweet</button>
      </div>
    </form>
  );
};

export default CreateTweet;
