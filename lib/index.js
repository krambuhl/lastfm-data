const LastfmAPI = require('lastfmapi')
const { 
	appName,
	key: api_key,
	secret
} = require('../api.json');

const promisify = (fn, context) => (config) =>
	new Promise((res, rej) => {
		fn.call(context, config, (err, data) => {
			if (err) return rej(err);
			else res(data);	
		});
	});

const getAll = (fn, key) =>
	new Promise((res, rej) => {
		const makeQuery = q => fn(Object.assign({ user: 'caforna', limit: 1000 }, q))

		makeQuery({})
			.then((data) => {
				const totalPages = parseInt(data['@attr'].totalPages, 10);
				
				if (totalPages > 1) {
					Promise.all([
						Promise.resolve(data),
						...Array(totalPages - 1)
							.fill()
							.map((_, i) => makeQuery({ page: i + 2 }))
					])
					.then(data => {
						res(
							data
								.map(d => d[key])
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


if (process.env.ACTION === 'album') {
	getAll(getTopAlbums, 'album').then(data => console.log(JSON.stringify(data, null, 2)))

} else if (process.env.ACTION === 'artist') {
	getAll(getTopArtists, 'artist').then(data => console.log(JSON.stringify(data, null, 2)))

} else {
	getAll(getTopTracks, 'track').then(data => console.log(JSON.stringify(data, null, 2)))
}
