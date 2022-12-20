const convertIsoDateStringToDate = (isoDate: string) => {
  return new Date(isoDate.replace(' ', 'T'));
};

export const DateTime = (isoDate: string) => {
  return convertIsoDateStringToDate(isoDate).toLocaleString('de-DE');
};

