import React from 'react';

const Dashboard: React.FC = () => {
  return (
    <div className="dashboard-container">
      <div className="dashboard-header">
        <h1>Dashboard</h1>
        <p>Welcome to Global Deals!</p>
      </div>
      
      <div className="dashboard-content">
        <div className="dashboard-section">
          <h2>Quick Stats</h2>
          <div className="stats-grid">
            <div className="stat-card">
              <h3>Active Deals</h3>
              <p className="stat-number">0</p>
            </div>
            <div className="stat-card">
              <h3>Total Users</h3>
              <p className="stat-number">0</p>
            </div>
            <div className="stat-card">
              <h3>Revenue</h3>
              <p className="stat-number">$0</p>
            </div>
          </div>
        </div>

        <div className="dashboard-section">
          <h2>Recent Activity</h2>
          <div className="activity-list">
            <p>No recent activity</p>
          </div>
        </div>

        <div className="dashboard-section">
          <h2>Quick Actions</h2>
          <div className="action-buttons">
            <button className="action-btn">Create New Deal</button>
            <button className="action-btn">View All Deals</button>
            <button className="action-btn">User Management</button>
            <button className="action-btn">Reports</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
