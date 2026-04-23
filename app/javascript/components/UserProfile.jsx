import React, { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import axios from '../utils/axiosConfig';
import FollowButtons from './FollowButtons';

const UserProfile = () => {
  const { id } = useParams();
  const [profile, setProfile] = useState(null);
  const [isFollowing, setIsFollowing] = useState(false);
  const [currentUser, setCurrentUser] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    // Why: prevent state updates after unmount while async profile fetch is in flight.
    let isMounted = true;

    const fetchProfile = async () => {
      try {
        setLoading(true);
        setError('');

        const response = await axios.get(`/users/${id}`);
        if (!isMounted) return;

        setProfile(response.data);
        setIsFollowing(Boolean(response.data.isFollowing));
        setCurrentUser(response.data.currentUser || '');
      } catch (err) {
        if (!isMounted) return;

        if (err.response?.status === 404) {
          setError('User not found.');
        } else {
          setError('Could not load user profile.');
        }
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    };

    fetchProfile();
    return () => {
      isMounted = false;
    };
  }, [id]);

  const handleFollow = async () => {
    try {
      await axios.post(`/users/${id}/follow`);
      // Why: optimistic update keeps follow UI responsive without a full refetch.
      setIsFollowing(true);
      setProfile((prev) => {
        if (!prev) return prev;
        return {
          ...prev,
          followers: [...(prev.followers || []), { username: currentUser }],
        };
      });
    } catch (err) {
      setError('Could not follow user.');
    }
  };

  const handleUnfollow = async () => {
    try {
      await axios.delete(`/users/${id}/unfollow`);
      setIsFollowing(false);
      setProfile((prev) => {
        if (!prev) return prev;
        return {
          ...prev,
          followers: (prev.followers || []).filter((follower) => follower.username !== currentUser),
        };
      });
    } catch (err) {
      setError('Could not unfollow user.');
    }
  };

  if (loading) {
    return <div className="tweets tweets--center">Loading profile...</div>;
  }

  if (error) {
    return (
      <div className="tweets tweets--center">
        <p>{error}</p>
        <Link className="btn btn--small" to="/tweets">Back to Tweets</Link>
      </div>
    );
  }

  if (!profile) {
    return null;
  }

  const isCurrentUser = profile.username === currentUser;

  return (
    <div className="tweets tweets--center">
      <div className="tweet" style={{ width: '100%', maxWidth: '640px' }}>
        <p className="tweet__user">@{profile.username}</p>
        <p className="tweet__content">Followers: {(profile.followers || []).length}</p>
        <p className="tweet__content">Following: {(profile.followees || []).length}</p>

        {!isCurrentUser && (
          <FollowButtons
            isFollowing={isFollowing}
            handleFollow={handleFollow}
            handleUnfollow={handleUnfollow}
          />
        )}

        <div style={{ marginTop: '12px' }}>
          <Link className="btn btn--small" to="/tweets">Back to Tweets</Link>
        </div>
      </div>
    </div>
  );
};

export default UserProfile;
