const sequence = require('run-sequence');
const gulp = require('gulp');
const postcss = require('gulp-postcss');


gulp.task('copy:html', () =>
  gulp.src('public/**/*.html')
    .pipe(gulp.dest('dist'))
);

gulp.task('copy:assets', () =>
  gulp.src(['public/**/*', '!**/*.html'])
    .pipe(gulp.dest('dist/assets'))
);

gulp.task('styles', () =>
  gulp.src('styles/*.css')
    .pipe(postcss([
      require('postcss-easy-import')(), // eslint-disable-line
      require('postcss-cssnext')(), // eslint-disable-line
      require('postcss-nested')() // eslint-disable-line
    ]))
    .pipe(gulp.dest('dist/assets'))
);

// entries

gulp.task('build', (done) => {
  sequence(['copy:html', 'copy:assets', 'styles'], done);
});

gulp.task('dev', (done) => {
  gulp.watch('public/**/*.html', ['copy:html']);
  gulp.watch(['public/**/*', '!**/*.html'], ['copy:assets']);
  gulp.watch('styles/**/*', ['styles']);

  sequence('build', done);
});
