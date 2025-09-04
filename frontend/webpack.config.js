const path = require('path');

module.exports = {
  // 继承 react-scripts 的默认配置
  ...require('react-scripts/config/webpack.config.js'),
  
  devServer: {
    // 解决 allowedHosts 配置问题
    allowedHosts: 'all',
    // 其他开发服务器配置
    host: 'localhost',
    port: 3000,
    hot: true,
    open: true,
    historyApiFallback: true,
    // 代理 API 请求到后端
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      }
    }
  }
};
