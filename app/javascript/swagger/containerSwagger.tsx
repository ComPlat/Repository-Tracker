export const containerSwagger = (() => {
  // eslint-disable-next-line unicorn/prefer-query-selector
  const result = document.getElementById('swagger');

  if (result === null) {
    throw new Error('Unable to find DOM element #swagger');
  }

  return result;
})();

export const clientId = (() => {
  const result = containerSwagger.dataset['clientId'];

  if (result === undefined) {
    throw new Error(`Unable to find client-id on dataset of element #${containerSwagger.id}`);
  }

  return result;
})();
