import React from 'react'

function FollowButtons({ isFollowing, handleFollow, handleUnfollow }) {
  return (
    isFollowing ? (
      <button className="btn btn--small btn--joy" onClick={handleUnfollow}>
        Unfollow
      </button>
    ) : (
      <button className="btn btn--small btn--joy" onClick={handleFollow}>
        Follow
      </button>
    )
  )
}

export default FollowButtons
