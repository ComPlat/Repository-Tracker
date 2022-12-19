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

const url = '/api/v1/trackings';

const getTrackings = async () => {
  return await fetch(url).then(async (response: Response) => {
    return await response.json();
  }).catch((error) => {
    return error;
  });
};

const trackingItemAsObject = (tracking: Tracking): Tracking => {
  return Object.assign(tracking, {
    date_time: DateTime(tracking.date_time),
  });
};

export const getTrackingItems = async () => {
  // TODO: Validate?!
  return await getTrackings().then(async (trackings: Tracking[]) => {
    return trackings.map(async (tracking) => {
      return trackingItemAsObject(tracking);
    });
  }).catch((error) => {
    return error;
  });
};
