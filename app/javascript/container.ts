const container = (() => {
  // eslint-disable-next-line unicorn/prefer-query-selector
  const result = document.getElementById('spa');

  if (result === null) {
    throw new Error('Unable to find DOM element #spa');
  }

  return result;
})();

const clientId = (() => {
  const result = container.dataset['clientId'];

  if (result === undefined) {
    throw new Error('Unable to find client-id on dataset of element #spa');
  }

  return result;
})();

const csrfToken = (() => {
  const csrfTokenElement = document.querySelector('[name=csrf-token]');

  if (csrfTokenElement === null) {
    throw new Error('Unable to find Element with [name=csrf-token]');
  }

  const contentAttribute = csrfTokenElement.getAttribute('content');

  if (contentAttribute === null) {
    throw new Error('Unable to find attribute content on Element with [name=csrf-token]');
  }

  return contentAttribute;
})();

export {
  container,
  clientId,
  csrfToken,
};
