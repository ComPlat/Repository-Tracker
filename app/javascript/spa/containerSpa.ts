export const containerSpa = (() => {
  // eslint-disable-next-line unicorn/prefer-query-selector
  const result = document.getElementById('spa');

  if (result === null) {
    throw new Error('Unable to find DOM element #spa');
  }

  return result;
})();

export const clientId = (() => {
  const result = containerSpa.dataset['clientId'];

  if (result === undefined) {
    throw new Error(`Unable to find client-id on dataset of element #${containerSpa.id}`);
  }

  return result;
})();

export const csrfToken = (() => {
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
