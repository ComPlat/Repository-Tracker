import {
  DateTime,
} from './DateTime';

export type Metadata = {
  [p: string]: Metadata | number | string | null,
};

export type Tracking = {
  date_time: string,
  from_trackable_system_name: string,
  id: number,
  metadata: Metadata,
  owner_name: string,
  status: string,
  to_trackable_system_name: string,
  tracking_item_name: string,
};

const getTrackings = async () => {
  return await fetch('/api/v1/trackings', {
    headers: {
      Authorization: `Bearer ${JSON.parse(localStorage.getItem('user') as string).token.access_token}`,
    },
    method: 'GET',
  }).then(async (response) => {
    return await response.json();
  });
};

const trackingItemAsObject = (tracking: Tracking): Tracking => {
  return Object.assign(tracking, {
    date_time: DateTime(tracking.date_time),
    metadata: JSON.stringify(tracking.metadata),
  });
};

export const getTrackingItems = async () => {
  return await getTrackings().then(async (trackings: Tracking[]) => {
    return trackings.map(async (tracking) => {
      return trackingItemAsObject(tracking);
    });
  });
};
