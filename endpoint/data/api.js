const LastfmAPI = require('lastfmapi');

const {
  key: api_key,
  secret
} = require('../api.json');

const api = new LastfmAPI({ api_key, secret });

module.exports = api;
