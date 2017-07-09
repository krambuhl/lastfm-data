const path = require('path');
const fs = require('fs');
const mkdirp = require('mkdirp');

const cachePath = (filename) =>
  path.resolve(__dirname, '../.cache', filename);


const saveToCache = (filename) => (data) => (
  new Promise((resolve, reject) => {
    const filepath = cachePath(filename);
    mkdirp(path.dirname(filepath), (mkErr) => {
      if (mkErr) reject(mkErr);
      else {
        console.log('[Cache]', `saving ${filename} to cache.`);
        fs.writeFile(
          filepath,
          JSON.stringify(data, null, 2),
          (fileErr) => {
            if (fileErr) reject(fileErr);
            else resolve(data);
            console.log('[Cache]', `finished saving ${filename} to cache.`);
          }
        );
      }
    });
  })
);

const getFromCache = (filename) => (
  new Promise((resolve, reject) => {
    const filepath = cachePath(filename);
    fs.readFile(filepath, (err, data) => {
      if (err) resolve(null);
      else {
        try {
          const json = JSON.parse(data);
          resolve(json);
        } catch (e) {
          reject(e);
        }
      }
    });
  })
);

module.exports = {
  saveToCache,
  getFromCache
};
