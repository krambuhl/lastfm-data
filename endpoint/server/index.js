const jsonServer = require('json-server');
const path = require('path');
const fs = require('fs');
const { getAllData } = require('../data/getData');

const cachePath = (filename) =>
  path.resolve(__dirname, '../.cache', filename);

const saveToCache = (filename) => (data) => (
  new Promise((resolve, reject) => {
    fs.writeFile(
      cachePath(filename),
      JSON.stringify(data, null, 2),
      (err) => {
        if (err) reject(err);
        else resolve(data);

        console.log('[Cache]', `saving ${filename} to cache`);
      }
    );
  })
);

const getCachedData = () => {
  try {
    return require(cachePath('data.json')); // eslint-disable-line
  } catch (e) {
    return undefined;
  }
};

const getLastFmData = () => {
  const cachedData = getCachedData();

  if (cachedData) {
    console.log('[Server]', 'using cached Last.fm data\n');
    return Promise.resolve(cachedData);
  }

  console.log('[Server]', 'requesting new Last.fm data\n');
  return getAllData().then((data) => {
    saveToCache('data.json')(data);
    saveToCache('artists.json')(data.artists);
    saveToCache('albums.json')(data.albums);
    saveToCache('tracks.json')(data.tracks);
    return Promise.resolve(data);
  });
};

getLastFmData().then((data) => {
  const server = jsonServer.create();
  const router = jsonServer.router(data);
  const middlewares = jsonServer.defaults();

  server.use(middlewares);
  server.use(router);
  server.listen(5001, () => {
    console.log('[Server]', 'started at http://localhost:5001');
    console.log();
  });

  console.log('artists –', data.artists.length);
  console.log('albums  –', data.albums.length);
  console.log('tracks  –', data.tracks.length);
  console.log();
});
