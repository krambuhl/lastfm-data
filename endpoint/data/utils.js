const promisify = (fn, context) => (config) =>
  new Promise((res, rej) => {
    fn.call(context, config, (err, data) => {
      if (err) rej(err);
      else res(data);
    });
  });

module.exports = {
  promisify
};
