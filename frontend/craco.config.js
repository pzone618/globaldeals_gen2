module.exports = {
  devServer: {
    allowedHosts: 'all',
    host: 'localhost',
    port: 3000,
    hot: true,
    open: false, // 不自动打开浏览器
    historyApiFallback: true,
    client: {
      overlay: false, // 关闭错误覆盖层以避免配置冲突
    },
    setupMiddlewares: (middlewares, devServer) => {
      // 自定义中间件设置
      return middlewares;
    }
  },
  webpack: {
    configure: (webpackConfig, { env, paths }) => {
      // 修复 webpack dev server 配置
      if (env === 'development') {
        webpackConfig.infrastructureLogging = {
          level: 'error',
        };
      }
      return webpackConfig;
    },
  },
};
