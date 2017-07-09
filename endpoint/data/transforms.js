const uniqueBy = require('unique-by');


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


const transformRow = (row) => {
  if (row['@attr']) {
    const attrs = transformProps(row['@attr']);
    if (attrs.rank) {
      row.playcountRank = transformProps(row['@attr']).rank;
    }
    delete row['@attr'];
  }

  if (row.image) {
    row.images = row.image.reduce((sum, image) => {
      sum[image.size] = image['#text'];
      return sum;
    }, { });
    delete row.image;
  }

  if (row.streamable) {
    delete row.streamable;
  }

  return transformProps(row);
};


const transform = (res) =>
  Promise.resolve(
    res.map(transformRow)
  );

const sortByKeyAndRank = (rows, key, rankName) =>
  rows
    .sort((a, b) => {
      if (a[key] < b[key]) return -1;
      if (a[key] > b[key]) return 1;
      return 0;
    })
    .reverse()
    .map((row, i) => {
      row[rankName] = i;
      return row;
    });

const getTopTracksByDuration = ({ tracks }) =>
  sortByKeyAndRank(tracks, 'duration', 'durationRank');

// const getNumberOfAlbumsPerArtist = ({ albums }) => {
//   return albums.map((album) => {
//     const matchingAlbums = getByArtist(albums, album.name);
//   });
//   // 1. find all albums for an artists
//   // 2. find unique rows per album
//   // 3. count
// };

// const getNumberOfTracksPerArtist = () => {
//   // 1. find all tracks for an artist
//   // 2. find unique rows
//   // 3. count
// };

// const getAlbumDuration = (album, tracks) => {
//   // 1. get tracks matching album
//   // 2. sum track duration
// };

// const getTotalAlbumPlaytime = () => {
//   // 1. getAlbumDuration
//   // 2. multiply by playcount
// };

// const getTotalTrackPlaytime = () => {
//   // multiply playcount by duration
// };

// const getTotalArtistPlaytime = () => {
//   // 1. get tracks matching artist
//   // 2. getTotalTrackPlaytime
//   // 3. sum
// };

const getStructuredData = (data) => {
  // const getAlbumTracks = (album) =>
  //   uniqueBy(
  //     data.tracks
  //       .filter((track) => {
  //         if (track.album) {
  //           return (
  //             track.album.mbid === album.mbid ||
  //             track.album.title === album.title
  //           );
  //         }

  //         return false;
  //       }),
  //     (track) => track.name
  //   );

  // const getArtistAlbums = (artist) =>
  //   uniqueBy(
  //     data.albums
  //       .filter((album) => {
  //         if (album.artist) {
  //           return (
  //             album.artist.mbid === artist.mbid ||
  //             album.artist.name === artist.name
  //           );
  //         }

  //         return false;
  //       }),
  //     (album) => album.name
  //   ).map((album) => Object.assign(album, {
  //     tracks: getAlbumTracks(album)
  //   }));


  return data.tracks
    .map((track) =>
      Object.assign(track, {
        albums: getArtistAlbums(artist)
      })
    );
};


const transformAll = (data) => {
  const res = {
    // topTracksByDuration: getTopTracksByDuration(data),
    structuredData: getStructuredData(data)
  };

  return res;
};
module.exports = {
  transformProps,
  transform,
  transformRow,
  transformAll
};
