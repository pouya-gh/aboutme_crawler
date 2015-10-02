module AboutmeCrawler
  DEFAULT_TIMEOUT = 180
  DEFAULT_STEP_DELAY = 3
  DEFAULT_SEARCH_QUERY = "john smith"
  DEFAULT_MAX_RESULTS = 3
  DEFAULT_SETTINGS = %q{{
  // Here you set the timeout (in seconds).
  // Only positive integers are valid, other values mean that
  // you have chosen the default value(180).
  "timeout": 0,

  // Set the account username here.
  "username": "",

  // Set the password associated with the username here.
  "password": "",

  // Step delay is the amount of time (in seconds) the program
  // waits after the response to a request is ready.
  // Only positive integers are valid, other values mean that
  // you have chosen the default value(3).
  "step_delay": 0,

  // This is the query you want to search for.
  // An empty string means that you have chosen the default
  // value('john smith').
  "search_query": "",

  // Here you specify the maximum number of results you are
  // interested, because there could be thousands of results.
  // Only positive integers are valid, other values mean that
  // you have chosen the default value(3).
  "max_results": 0,

  // Here you set the proxy for http. If you don't want to use
  // a proxy, just leave it empty.
  // example:
  //          "my.proxy.com:8080"
  "http_proxy": "",

  // Here you set the proxy for ssl. If you don't want to use
  // a proxy, just leave it empty.
  // example:
  //          "my.proxy.com:8080"
  "ssl_proxy": ""
}}
  PROJECT_STRUCTURE = {
    dirs: ['output'],
    files: ['settings.json']
  }
end
