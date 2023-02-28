export const containerSwagger = (() => {
  // eslint-disable-next-line unicorn/prefer-query-selector
  const result = document.getElementById('swagger');

  if (result === null) {
    throw new Error('Unable to find DOM element #swagger');
  }

  return result;
})();
