export default [
  'desktop', 'mobile'
].map((type) => {
  return {
    entry: `test/e2e/${type}/navbar.js`,
    output: {
      file: `test/e2e/bundle/${type}/navbar.js`,
      format: 'cjs'
    }
  };
});
