const api = require('./api');
const { promisify } = require('./utils');
const { transform } = require('./transforms');

const getTopAlbums = promisify(api.user.getTopAlbums, api.user);
const getTopArtists = promisify(api.user.getTopArtists, api.user);
const getTopTracks = promisify(api.user.getTopTracks, api.user);


const getAllFactory = (user, fn, key) =>
  new Promise((res, rej) => {
    const makeQuery = (q) => fn(Object.assign({ user, limit: 1000 }, q));

    makeQuery({})
      .then((data) => {
        const totalPages = parseInt(data['@attr'].totalPages, 10);

        if (totalPages > 1) {
          Promise.all([
            Promise.resolve(data),
            ...Array(totalPages - 1)
              .fill()
              .map(($, i) => makeQuery({ page: i + 2 }))
          ])
          .then((pageData) => {
            res(
              pageData
                .map((d) => d[key])
                .reduce((all, d) => [...all, ...d], [])
            );
          })
          .catch(rej);
        } else {
          res(data[key]);
        }
      })
      .catch(rej);
  });


const getUserDataType = (user, env) => {
  const get = (fn, key) =>
    getAllFactory(user, fn, key)
      .then(transform);

  console.log('[Last.fm]', `getting ${env} data`);
  switch (env) {
    case 'albums': return get(getTopAlbums, 'album');
    case 'artists': return get(getTopArtists, 'artist');
    case 'tracks': return get(getTopTracks, 'track');
    default: return {};
  }
};


const getUserData = (user) => {
  const namedRequest = (name) =>
    getUserDataType(user, name)
      .then(transform)
      .then((res) => ({ name, res }));

  const sumRequests = (data) =>
    data.reduce((sum, d) => {
      sum[d.name] = d.res;
      return sum;
    }, { });

  console.log('[Last.fm]', 'data collection started...\n');
  return Promise.all([
    namedRequest('albums'),
    namedRequest('artists'),
    namedRequest('tracks')
  ])
  .then((allData) => {
    console.log('[Last.fm]', 'data collection complete\n');
    return Promise.resolve(sumRequests(allData));
  })
  .catch((err) => {
    console.log('[Last.fm]', 'data collection error: ', err, '\n');
  });
};


module.exports = {
  getUserDataType,
  getUserData
};
