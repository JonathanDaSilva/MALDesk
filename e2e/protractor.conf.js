exports.config = {
  seleniumServerJar: './selenium/selenium-server-standalone-2.35.0.jar',
  chromeDriver: './selenium/chromedriver',
  seleniumArgs: [],
  seleniumAddress: null,

  specs: [
    './spec/*.js',
  ],

  capabilities: {
    'browserName': 'chrome'
  },

  baseUrl: 'http://localhost:8000',

  rootElement: 'body',

  jasmineNodeOpts: {
    onComplete: null,
    isVerbose: false,
    showColors: true,
    includeStackTrace: true,
    defaultTimeoutInterval: 30000
  }
};
