// filepath: /home/obula/railsProjects/internship_test_glckfndr_2025/app/javascript/components/Tweet.jsx
import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import './Tweet.css';
import EditTweet from './EditTweet';
import { Link } from 'react-router-dom';

const Tweet = ({ tweet, currentUser, isLoggedIn }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [likes, setLikes] = useState(tweet.likes ? tweet.likes.length : 0);
  const [isFollowing, setIsFollowing] = useState(false);
  const [retweets, setRetweets] = useState(tweet.retweets ? tweet.retweets.length : 0);
  const [isRetweeted, setIsRetweeted] = useState(false);
  const [isLiked, setIsLiked] = useState(false);


  useEffect(() => {
    axios.get(`/users/${tweet.user_id}`)
      .then(response => {
        setIsFollowing(response.data.followers.some(follower => follower.username === currentUser.name));
      })
      .catch(error => {
        console.error('Tweet got an error fetching the user!', error);
      });

    if (tweet.retweets) {
      setIsRetweeted(tweet.retweets.some(retweet => retweet.user_id === currentUser.id));
    }

    if (tweet.likes) {
      setIsLiked(tweet.likes.some(like => like.user_id === currentUser.id));
    }
  }, [tweet.user_id, currentUser.name, tweet.retweets, tweet.likes]);

  const handleDelete = () => {
    axios.delete(`/tweets/${tweet.id}`)
      .then(response => {

      })
      .catch(error => {
        console.error('Tweet got an error deleting the tweet!', error);
      });
  };

  const handleEdit = () => {
    setIsEditing(true);
  };

  const handleTweetUpdated = (updatedTweet) => {
    setIsEditing(false);
  };

  const handleLike = () => {
    axios.post(`/tweets/${tweet.id}/like`)
      .then(response => {
        setLikes(prev => prev + 1);
        setIsLiked(true);
      })
      .catch(error => {
        console.error('Tweet got an error liking the tweet!', error);
      });
  };

  const handleUnlike = () => {
    axios.delete(`/tweets/${tweet.id}/unlike`)
      .then(response => {
        setLikes(prev => prev - 1);
        setIsLiked(false);
      })
      .catch(error => {
        console.error('Tweet got an error unliking the tweet!', error);
      });
  };

  const handleFollow = () => {
    axios.post(`/users/${tweet.user_id}/follow`)
      .then(response => {
        setIsFollowing(true);
      })
      .catch(error => {
        console.error('Tweet got an error an following the user!', error);
      });
  };

  const handleUnfollow = () => {
    axios.delete(`/users/${tweet.user_id}/unfollow`)
      .then(response => {
        setIsFollowing(false);
      })
      .catch(error => {
        console.error('Tweet got an error unfollowing the user!', error);
      });
  };

  const handleRetweet = () => {
    axios.post(`/tweets/${tweet.id}/retweet`)
      .then(response => {
        setRetweets(retweets + 1);
        setIsRetweeted(true);
      })
      .catch(error => {
        console.error('Tweet got an error retweeting the tweet!', error);
      });
  };

  const handleUnretweet = () => {
    axios.delete(`/tweets/${tweet.id}/unretweet`)
      .then(response => {
        setRetweets(retweets - 1);
        setIsRetweeted(false);
      })
      .catch(error => {
        console.error('Tweet got an error unretweeting the tweet!', error);
      });
  };

  return (
    <div className='tweet'>
      {isEditing ? (
        <EditTweet tweetId={tweet.id} onTweetUpdated={handleTweetUpdated} />
      ) : (
        <div>
          <div className='tweet__header'>
            <p className='tweet__user'>
              {currentUser.name === tweet.user.username ? (
                tweet.user.username
              ) : (
                <Link to={`/users/${tweet.user_id}`}>{tweet.user.username}</Link>
              )}
            </p>
            <p className='tweet__like'>Likes: {likes}</p>

          </div>
          <p className='tweet__content'>{tweet.content}</p>

          {currentUser.name === tweet.user.username && (
            <>
              <button className="btn btn--small btn--danger" onClick={handleDelete}>
                Delete
              </button>
              <button className="btn btn--small btn--primary" onClick={handleEdit}>
                Edit
              </button>
            </>
          )}
          {isLoggedIn && currentUser.name !== tweet.user.username && (
            !isLiked ? (
              <button className="btn btn--small btn--like" onClick={handleLike}>
                Like
              </button>) : (
              <button className="btn btn--small btn--like" onClick={handleUnlike}>
                DisLike
              </button>)
          )
          }
          {isLoggedIn && currentUser.name !== tweet.user.username && (
            isFollowing ? (
              <button className="btn btn--small btn--joy" onClick={handleUnfollow}>
                Unfollow
              </button>
            ) : (
              <button className="btn btn--small btn--joy" onClick={handleFollow}>
                Follow
              </button>
            )
          )}
          {isLoggedIn && currentUser.name !== tweet.user.username && (isRetweeted ? (
            <button className="btn btn--small btn--primary" onClick={handleUnretweet}>
              Unretweet
            </button>
          ) : (
            <button className="btn btn--small btn--primary" onClick={handleRetweet}>
              Retweet
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

export default Tweet;
