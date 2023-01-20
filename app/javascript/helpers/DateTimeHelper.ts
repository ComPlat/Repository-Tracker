const convertIsoDateStringToDate = (isoDate: string) => {
  return new Date(isoDate.replace(' ', 'T'));
};

export const DateTimeHelper = (isoDate: string) => {
  return convertIsoDateStringToDate(isoDate).toLocaleString('de-DE', {
    day: '2-digit',
    hour: '2-digit',
    hour12: false,
    minute: '2-digit',
    month: '2-digit',
    second: '2-digit',
    year: 'numeric',
  });
};

