import React from 'react'

function RetweetButtons({ isRetweeted, handleRetweet, handleUnretweet }) {
  return (
    (isRetweeted ? (
      <button className="btn btn--small btn--primary" onClick={handleUnretweet}>
        Unretweet
      </button>
    ) : (
      <button className="btn btn--small btn--primary" onClick={handleRetweet}>
        Retweet
      </button>
    ))
  )
}

export default RetweetButtons
