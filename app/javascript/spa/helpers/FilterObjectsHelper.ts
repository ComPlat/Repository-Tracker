export const FilterObjectsHelper = (collection: string[]) => {
  return collection.map((item) => {
    return {
      text: item,
      value: item,
    };
  });
};
