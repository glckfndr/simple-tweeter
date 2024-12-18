import React from 'react'
import { Link } from "react-router-dom";
import './Home.css';

function Home() {
  return (
    <div className="home">
      <h1 className="home__title">Tweeter Site</h1>

        <p className="home__description">
          Environment for comunication of creative peoples
        </p>
            <hr className="home__divider"/>
        <Link
          to="/tweets"
          className="home__link"
          role="button"
        >
          View Tweets
        </Link>
    </div>
  )
}

export default Home
