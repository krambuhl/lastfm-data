require('whatwg-fetch');

const appEl = document.querySelector('.app');

const setup = (template, data, transform) => {
  appEl.innerHTML =
    data
      .map(transform)
      .slice(0, 100)
      .map(template)
      .join('');

  [].slice.call(document.querySelectorAll('.object'))
    .forEach((el) => {
      let timer;

      el.addEventListener('mouseenter', () => {
        clearTimeout(timer);
        timer = setTimeout(() => {
          el.classList.add('is-active');
          el.classList.add('is-focused');
        }, 200);
      });

      el.addEventListener('mouseleave', () => {
        clearTimeout(timer);
        el.classList.remove('is-active');
        timer = setTimeout(() => el.classList.remove('is-focused'), 300);
      });

      el.addEventListener('focus', () => {
        clearTimeout(timer);
        el.classList.add('is-active');
        el.classList.add('is-focused');
      });

      el.addEventListener('blur', () => {
        clearTimeout(timer);
        el.classList.remove('is-active');
        timer = setTimeout(() => el.classList.remove('is-focused'), 300);
      });
    });
};

// albums logic

// const albums = require('../dist/data/albums.json');
const albumTemplate = require('./templates/album.hbs');

fetch('http://localhost:5001/albums')
  .then((response) => response.json())
  .then((data) => {
    setup(albumTemplate, data, (album) => ({
      name: album.name,
      url: album.url,
      playcount: album.playcount,
      artist: album.artist.name,
      image: album.image[album.image.length - 1]['#text'], // album.image.length - 1
      rank: album['@attr'].rank
    }));
  });
