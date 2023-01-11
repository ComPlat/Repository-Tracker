import {
  DateTime,
} from './DateTime';
import {
  getUserFromLocalStorage,
} from './LocalStorageHelper';

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
  const user = getUserFromLocalStorage();

  return await fetch('/api/v1/trackings', {
    headers: {
      Authorization: `Bearer ${user.token.access_token}`,
    },
    method: 'GET',
  }).then(async (response) => {
    return await response.json();
  }).catch((error) => {
    return error;
  });
};

const trackingItemAsObject = (tracking: Tracking): Tracking => {
  return Object.assign(tracking, {
    date_time: DateTime(tracking.date_time),
    metadata: JSON.stringify(tracking.metadata),
  });
};

export const TrackingItems = async () => {
  return await getTrackings().then(async (trackings: Tracking[]) => {
    return trackings.map(async (tracking) => {
      return trackingItemAsObject(tracking);
    });
  });
};