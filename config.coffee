development =
  HOST: 
  PORT: 

production =
  HOST:
  PORT: 

module.exports = (if global.process.env.NODE_ENV is "production" then production else development)


