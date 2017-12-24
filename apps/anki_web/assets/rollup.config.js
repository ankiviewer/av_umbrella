export default [
  'app', 'home', 'rules', 'search', 'settings'
].map((file) => {
  return {
    input: `js/${file}.js`,
    output: {
      file: `../priv/static/js/${file}.js`,
      format: 'cjs',
      sourcemap: true
    }
  };
});
