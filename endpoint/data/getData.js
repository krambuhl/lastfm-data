const LastfmAPI = require('lastfmapi');

const {
  key: api_key,
  secret
} = require('../api.json');

const promisify = (fn, context) => (config) =>
  new Promise((res, rej) => {
    fn.call(context, config, (err, data) => {
      if (err) rej(err);
      else res(data);
    });
  });

const getAllFactory = (fn, key) =>
  new Promise((res, rej) => {
    const makeQuery = (q) => fn(Object.assign({ user: process.env.USER, limit: 1000 }, q));

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


const api = new LastfmAPI({ api_key, secret });

const getTopAlbums = promisify(api.user.getTopAlbums, api.user);
const getTopArtists = promisify(api.user.getTopArtists, api.user);
const getTopTracks = promisify(api.user.getTopTracks, api.user);

const getData = (env) => {
  switch (env) {
    case 'albums': return getAllFactory(getTopAlbums, 'album');
    case 'artists': return getAllFactory(getTopArtists, 'artist');
    case 'tracks': return getAllFactory(getTopTracks, 'track');
    default: return {};
  }
};

const transformProps = (row) =>
  Object.keys(row).reduce((memo, key) => {
    if (row[key] === '') {
      memo[key] = null;
    } else {
      switch (key) {
        case 'playcount':
        case 'duration':
        case 'rank':
          memo[key] = parseInt(row[key], 10);
          break;

        default:
          memo[key] = row[key];
      }
    }

    return memo;
  }, {});

const transform = (res) =>
  Promise.resolve(
    res.map((row) => {
      if (row['@attr']) {
        row.attributes = transformProps(row['@attr']);
        delete row['@attr'];
      }

      if (row.image) {
        row.images = row.image.map((img) => transformProps({
          text: img['#text'],
          size: img.size
        }));
        delete row.image;
      }

      if (row.streamable) {
        delete row.streamable;
      }

      return transformProps(row);
    })
  );

const getAllData = () => {
  const namedRequest = (name) =>
    getData(name)
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
  getData,
  getAllData
};
