const { getUserData } = require('./data/getUserData');
const { getAllTrackData } = require('./data/getTrackInfo');
const { transformAll } = require('./data/transforms');
const {
  saveToCache,
  getFromCache
} = require('./data/cache');

// try cache first
Promise.resolve({})
  .then(() => {
    console.log('[UserData]', 'checking cache for Last.fm user data...');

    const filepath = 'caforna/1-user-data.json';
    return getFromCache(filepath)
      .then((cachedUserData) => {
        if (cachedUserData) {
          console.log('[UserData]', 'cached raw user data found');
          return Promise.resolve(cachedUserData);
        }

        console.log('[UserData]', 'no Last.fm user data found, requesting');
        return getUserData('caforna')
          .then((userData) => {
            console.log('[UserData]', 'user data collection complete');
            return saveToCache(filepath)(userData);
          });
      });
  })
  .then((userData) => {
    console.log('\n[TrackInfo]', 'checking cache for user track info...');

    const filepath = 'caforna/2-raw-data.json';
    return getFromCache(filepath)
      .then((cachedRawData) => {
        if (cachedRawData) {
          console.log('[TrackInfo]', 'cached user track info found');
          return Promise.resolve(cachedRawData);
        }

        console.log('[TrackInfo]', 'no Last.fm user track info found, requesting');
        return getAllTrackData(userData)
          .then((rawData) => {
            console.log('[TrackInfo]', 'user track info collection complete');
            return saveToCache(filepath)(rawData);
          });
      });
  })
  .then((rawData) => {
    console.log('\n[Transform]', 'checking cache for transformed data...');

    const filepath = 'caforna/3-transformed-data.json';
    return getFromCache(filepath)
      .then((cachedTransformedData) => {
        if (false && cachedTransformedData) {
          console.log('[Transform]', 'cached transformed data found');
          return Promise.resolve(cachedTransformedData);
        }

        console.log('[Transform]', 'no cached transformed data found, transforming');
        return Promise.resolve(rawData)
          .then(transformAll)
          .then((transformedData) => {
            console.log('[Transform]', 'transforming data complete');
            return saveToCache(filepath)(transformedData);
          });
      });
  })
  .then(() => {
    // .then((allData) => (
    //   Promise.resolve(transformAll(allData))
    // ))
    console.log('\n[Cache]', 'Data collection complete!');
  });
