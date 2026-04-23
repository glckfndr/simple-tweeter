import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Tweets from './Tweets';
import UserProfile from './UserProfile';

// Why: explicit route list prevents broken navigation when links target deep pages.
const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Tweets />} />
        <Route path="/tweets" element={<Tweets />} />
        <Route path="/users/:id" element={<UserProfile />} />
      </Routes>
    </Router>
  )
}
export default App
