import React, { useState, useEffect } from 'react';
import axios from '../utils/axiosConfig';
import { useParams } from 'react-router-dom';

const UserProfile = () => {
  const { id: userId } = useParams();
  const [user, setUser] = useState(null);
  const [isFollowing, setIsFollowing] = useState(false);

  useEffect(() => {
    axios.get(`/users/${userId}`)
      .then(response => {
        setUser(response.data);
        setIsFollowing(response.data.isFollowing);
      })
      .catch(error => {
        console.error('There was an error fetching the user!', error);
      });
  }, [userId]);

  const handleFollow = () => {
    axios.post(`/users/${userId}/follow`)
      .then(response => {
        setIsFollowing(true);
        setUser(prevUser => ({
          ...prevUser,
          followers: [...prevUser.followers, { username: response.data.currentUser }]
        }));
      })
      .catch(error => {
        console.error('There was an error following the user!', error);
      });
  };

  const handleUnfollow = () => {
    axios.delete(`/users/${userId}/unfollow`)
      .then(response => {
        setIsFollowing(false);
        setUser(prevUser => ({
          ...prevUser,
          followers: prevUser.followers.filter(follower => follower.username !== response.data.currentUser)
        }));
      })
      .catch(error => {
        console.error('There was an error unfollowing the user!', error);
      });
  };

  if (!user) return <div>Loading...</div>;

  return (
    <div className="user-profile">
      <h1>{user.username}</h1>
      <p>Followers: {user.followers.length}</p>
      <p>Following: {user.followees.length}</p>
      {isFollowing ? (
        <button onClick={handleUnfollow}>Unfollow</button>
      ) : (
        <button onClick={handleFollow}>Follow</button>
      )}
    </div>
  );
};

export default UserProfile;
