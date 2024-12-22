import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Tweets from './Tweets';
import UserProfile from './UserProfile';
const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Tweets />} />
        <Route path="users/:id" element={<UserProfile />} />
      </Routes>
    </Router>
  )
}
export default App
