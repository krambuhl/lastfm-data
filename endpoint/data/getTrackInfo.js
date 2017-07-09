const pThrottle = require('p-throttle');

const api = require('./api');
const { promisify } = require('./utils');
const { transformRow } = require('./transforms');


const getTrackInfo = promisify(api.track.getInfo, api.track);


const getTrackData = pThrottle((track, i, all) => {
  console.log('[Last.fm]', `[${i}/${all.length}] getting track info for ${track.name}`);
  return getTrackInfo({
    mbid: track.mbid,
    artist: track.artist.name,
    track: track.name
  })
  .catch((err) => {
    console.log('[Last.fm]', `track info collection error (${track.name}): `, err, '\n');
    return Promise.resolve(track);
  })
  .then((res) => {
    const newTrack = Object.assign({}, track, {
      album: res.album ? transformRow(res.album) : null
    });

    return Promise.resolve(newTrack);
  });
}, 8, 200);


const getAllTrackData = (allData) =>
  Promise.all(allData.tracks.map(getTrackData))
    .then((newData) => (
      Promise.resolve(Object.assign({}, allData, {
        tracks: newData
      }))
    ));


module.exports = {
  getTrackData,
  getAllTrackData
};
