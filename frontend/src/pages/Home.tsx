import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const Home: React.FC = () => {
  const { isAuthenticated, user } = useAuth();

  return (
    <div className="container">
      <h1>Welcome to Global Deals</h1>
      
      {isAuthenticated ? (
        <div>
          <p>Hello, {user?.username}! Welcome back.</p>
          <Link to="/dashboard" className="btn btn-primary">
            Go to Dashboard
          </Link>
        </div>
      ) : (
        <div>
          <p>Your marketplace for amazing deals worldwide.</p>
          <p>
            <Link to="/register" className="btn btn-primary" style={{ marginRight: '10px' }}>
              Get Started
            </Link>
            <Link to="/login" className="btn btn-secondary">
              Sign In
            </Link>
          </p>
        </div>
      )}
      
      <div style={{ marginTop: '50px' }}>
        <h2>Features</h2>
        <ul>
          <li>🔒 Secure user authentication with JWT</li>
          <li>📱 Responsive design</li>
          <li>⚡ Fast and modern React frontend</li>
          <li>🛡️ Spring Boot backend with security</li>
          <li>🗄️ PostgreSQL database</li>
          <li>🚀 Ready for deployment with Podman</li>
        </ul>
      </div>
    </div>
  );
};

export default Home;
