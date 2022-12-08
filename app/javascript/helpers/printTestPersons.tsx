const concatName = (item: { firstname: string, lastname: string, }) => {
  return `${item.firstname} ${item.lastname}`;
};

const getResponseFromApi = async (url: string) => {
  return await fetch(url).then(async (response) => {
    return await response.json();
  }).then((json) => {
    return json.data.map((item: { firstname: string, lastname: string, }) => {
      return concatName(item);
    });
  }).catch((error) => {
    return error;
  });
};

export const printTestPersons = async (url: string) => {
  return await getResponseFromApi(url).then(async (response) => {
    return response;
  });
};
