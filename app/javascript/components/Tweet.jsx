// filepath: /home/obula/railsProjects/internship_test_glckfndr_2025/app/javascript/components/Tweet.jsx
import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import './Tweet.css';
import EditTweet from './EditTweet';
import { Link } from 'react-router-dom';

const Tweet = ({ tweet, onDelete, onUpdate, currentUser }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [likes, setLikes] = useState(tweet.likes ? tweet.likes.length : 0);
  const [isFollowing, setIsFollowing] = useState(false);

  useEffect(() => {
    axios.get(`/users/${tweet.user_id}`)
      .then(response => {
        setIsFollowing(response.data.followers.some(follower => follower.username === currentUser));
      })
      .catch(error => {
        console.error('There was an error fetching the user!', error);
      });
  }, [tweet.user_id, currentUser]);

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

  const handleFollow = () => {

    axios.post(`/users/${tweet.user_id}/follow`)
      .then(response => {
        setIsFollowing(true);
      })
      .catch(error => {
        console.error('There was an error following the user!', error);
      });
  };

  const handleUnfollow = () => {
    axios.delete(`/users/${tweet.user_id}/unfollow`)
      .then(response => {
        setIsFollowing(false);
      })
      .catch(error => {
        console.error('There was an error unfollowing the user!', error);
      });
  };

  return (
    <div className='tweet'>
      {isEditing ? (
        <EditTweet tweetId={tweet.id} onTweetUpdated={handleTweetUpdated} />
      ) : (
        <div>
           <p className='tweet__user'>
            posted by: {currentUser === tweet.user.username ? (
              tweet.user.username
            ) : (
              <Link to={`/users/${tweet.user_id}`}>{tweet.user.username}</Link>
            )}
          </p>
          <p className='tweet__content'>{tweet.content}</p>
          <p className='tweet__like'>Likes: {likes}</p>
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
            Dislike
          </button>
          {currentUser !== tweet.user.username && (
            isFollowing ? (
              <button className="btn btn-small btn--primary" onClick={handleUnfollow}>
                Unfollow
              </button>
            ) : (
              <button className="btn btn-small btn--primary" onClick={handleFollow}>
                Follow
              </button>
            )
          )}
        </div>
      )}
    </div>
  );
};

export default Tweet;
