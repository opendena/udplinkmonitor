development =
  HOST: "vh105.denaroo.com" 
  PORT: 33333 

production =
  HOST: "Here put the ulms.coffee adress"
  PORT: 33333

module.exports = (if global.process.env.NODE_ENV is "production" then production else development)


