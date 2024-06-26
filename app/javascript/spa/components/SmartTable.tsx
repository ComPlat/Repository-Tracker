import {
  Form,
  Radio,
  type RadioChangeEvent,
  Space,
  Table,
} from 'antd';
import type {
  SizeType,
} from 'antd/es/config-provider/SizeContext';
import type {
  ColumnGroupType,
  ColumnsType,
  ColumnType,
  TableProps,
} from 'antd/es/table';
import React, {
  useContext,
  useEffect,
  useState,
} from 'react';
import {
  UserContext,
} from '../contexts/UserContext';
import {
  hasTokenExpired,
  RefreshToken,
} from '../helpers/AuthenticationHelper';
import {
  FilterObjectsHelper,
} from '../helpers/FilterObjectsHelper';
import {
  getTokenFromLocalStorage,
  storeUserInLocalStorage,
} from '../helpers/LocalStorageHelper';
import type {
  Tracking,
} from '../helpers/TrackingItemsHelper';
import {
  TrackingItemsHelper,
} from '../helpers/TrackingItemsHelper';
import {
  AutoCompleteSearch,
} from './smart-table/AutoCompleteSearch';
import {
  CustomFilterIcon,
} from './smart-table/CustomFilterIcon';

// Types
type DataType = {
  date_time: string,
  from_trackable_system_name: string,
  id: number,
  metadata: string,
  owner_name: string,
  status: string,
  to_trackable_system_name: string,
  tracking_item_name: string,
};

const SmartTable: React.FC = () => {
  const [
    size,
    setSize,
  ] = useState<SizeType>('small');
  const [
    fromSelection,
    setFromSelection,
  ] = useState<string[]>([]);
  const [
    toSelection,
    setToSelection,
  ] = useState<string[]>([]);
  const [
    statusSelection,
    setStatusSelection,
  ] = useState<string[]>([]);
  const [
    trackingItemsSelection,
    setTrackingItemsSelection,
  ] = useState<string[]>([]);
  const [
    ownerSelection,
    setOwnerSelection,
  ] = useState<string[]>([]);
  const [
    trackingItems,
    setTrackingItems,
  ] = useState<Tracking[]>([]);

  const {
    user,
  } = useContext(UserContext);

  const setAllTrackingItems = async () => {
    await TrackingItemsHelper().then(async (item) => {
      setTrackingItems(await Promise.all(item));
    });
  };

  useEffect(() => {
    const setTrackingsToState = async () => {
      if (user === null) {
        setTrackingItems([]);
      } else if (hasTokenExpired()) {
        const token = getTokenFromLocalStorage();

        storeUserInLocalStorage({
          email: user.email,
          token: await RefreshToken(token),
        });

        await setAllTrackingItems();
      } else {
        await setAllTrackingItems();
      }
    };

    void setTrackingsToState();
  }, [
    user,
  ]);

  const handleSizeChange = (event: RadioChangeEvent) => {
    setSize(event.target.value);
  };

  const tableProps: TableProps<DataType> = {
    bordered: true,
    loading: false,
    showHeader: true,
    size,
    tableLayout: 'fixed',
  };

  const columns: ColumnsType<DataType> = [
    {
      dataIndex: 'id',
      filteredValue: null,
      key: 'id',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.id.toString().includes(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.id - second.id;
      },
      title: 'ID',
    },
    {
      dataIndex: 'from_trackable_system_name',
      filterDropdown: () => {
        return AutoCompleteSearch([
          ...new Set(trackingItems.map((item) => {
            return item.from_trackable_system_name;
          })),
        ], (value: React.SetStateAction<string[]>) => {
          setFromSelection(value);
        });
      },
      filteredValue: fromSelection.length === 0 ? null : fromSelection,
      filterIcon: CustomFilterIcon(fromSelection.length !== 0),
      filters: FilterObjectsHelper(trackingItems.map((item) => {
        return item.from_trackable_system_name;
      })),
      key: 'from',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.from_trackable_system_name.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.from_trackable_system_name.localeCompare(second.from_trackable_system_name, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'From',
    },
    {
      dataIndex: 'to_trackable_system_name',
      filterDropdown: () => {
        return AutoCompleteSearch([
          ...new Set(trackingItems.map((item) => {
            return item.to_trackable_system_name;
          })),
        ], (value: React.SetStateAction<string[]>) => {
          setToSelection(value);
        });
      },
      filteredValue: toSelection.length === 0 ? null : toSelection,
      filterIcon: CustomFilterIcon(toSelection.length !== 0),
      filters: FilterObjectsHelper(trackingItems.map((item) => {
        return item.to_trackable_system_name;
      })),
      key: 'to',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.to_trackable_system_name.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.to_trackable_system_name.localeCompare(second.to_trackable_system_name, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'To',
    },
    {
      dataIndex: 'date_time',
      key: 'date_time',
      sorter: (first: DataType, second: DataType) => {
        return first.date_time.localeCompare(second.date_time, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Date/Time',
    },
    {
      dataIndex: 'status',
      filterDropdown: () => {
        return AutoCompleteSearch([
          ...new Set(trackingItems.map((item) => {
            return item.status;
          })),
        ], (value: React.SetStateAction<string[]>) => {
          setStatusSelection(value);
        });
      },
      filteredValue: statusSelection.length === 0 ? null : statusSelection,
      filterIcon: CustomFilterIcon(statusSelection.length !== 0),
      filters: FilterObjectsHelper(trackingItems.map((item) => {
        return item.status;
      })),
      key: 'status',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.status.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.status.localeCompare(second.status, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Status',
    },
    {
      dataIndex: 'metadata',
      filteredValue: null,
      key: 'data_metadata',
      sorter: (first: DataType, second: DataType) => {
        return first.metadata.localeCompare(second.metadata, 'en', {
          numeric: true,
          sensitivity: 'base',
        });
      },
      title: 'Data/Metadata',
    },
    {
      dataIndex: 'tracking_item_name',
      filterDropdown: () => {
        return AutoCompleteSearch([
          ...new Set(trackingItems.map((item) => {
            return item.tracking_item_name;
          })),
        ], (value: React.SetStateAction<string[]>) => {
          setTrackingItemsSelection(value);
        });
      },
      filteredValue: trackingItemsSelection.length === 0 ? null : trackingItemsSelection,
      filterIcon: CustomFilterIcon(trackingItemsSelection.length !== 0),
      filters: FilterObjectsHelper(trackingItems.map((item) => {
        return item.tracking_item_name;
      })),
      key: 'tracker_number',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.tracking_item_name.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.tracking_item_name.localeCompare(second.tracking_item_name, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Tracker Number',
    },
    {
      dataIndex: 'owner_name',
      filterDropdown: () => {
        return AutoCompleteSearch([
          ...new Set(trackingItems.map((item) => {
            return item.owner_name;
          })),
        ], (value: React.SetStateAction<string[]>) => {
          setOwnerSelection(value);
        });
      },
      filteredValue: ownerSelection.length === 0 ? null : ownerSelection,
      filterIcon: CustomFilterIcon(ownerSelection.length !== 0),
      key: 'owner',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.owner_name.toLowerCase().includes(String(value).toLowerCase());
      },
      sorter: (first: DataType, second: DataType) => {
        return first.owner_name.localeCompare(second.owner_name, 'en', {
          numeric: true,
          sensitivity: 'base',
        });
      },
      title: 'Owner',
    },
  ];

  const tableColumns = columns.map((item: ColumnGroupType<DataType> | ColumnType<DataType>) => {
    return {
      ...item,
    };
  });

  return (
    <div>
      <Form layout='inline'>
        <div>
          <Form.Item label='Size'>
            <Radio.Group onChange={handleSizeChange} value={size}>
              <Radio.Button value='large'>Large</Radio.Button>
              <Radio.Button value='middle'>Middle</Radio.Button>
              <Radio.Button value='small'>Small</Radio.Button>
            </Radio.Group>
          </Form.Item>
        </div>
      </Form>
      <div>
        <Space size='large'>
          <Table
            {...tableProps}
            columns={tableColumns}
            dataSource={trackingItems as unknown as DataType[]}
            pagination={{
              position: [
                'bottomCenter',
              ],
            }}
            rowKey='id'
          />
        </Space>
      </div>
    </div>
  );
};

export default SmartTable;
