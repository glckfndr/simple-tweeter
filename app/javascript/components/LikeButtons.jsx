import React from 'react'

function LikeButtons({ isLiked, handleLike, handleUnlike }) {
  return (
    !isLiked ?
      <button className="btn btn--small btn--like" onClick={handleLike}>
        Like
      </button> :
      <button className="btn btn--small btn--like" onClick={handleUnlike}>
        DisLike
      </button>
  )
}

export default LikeButtons
