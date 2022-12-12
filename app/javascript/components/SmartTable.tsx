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
  useEffect,
  useState,
} from 'react';
import {
  FilterObjects,
} from '../helpers/FilterObjects';
import {
  TestPersons,
} from '../helpers/TestPersons';
import {
  AutoCompleteSearch,
} from './AutoCompleteSearch';
import {
  CustomFilterIcon,
} from './CustomFilterIcon';

// Types
type DataType = {
  data_metadata: string,
  date_time: string,
  from: string,
  id: number,
  owner: string,
  status: string,
  to: string,
  tracker_number: string,
};

const dataFrom: string[] = [
  'ELN',
  'RADAR4Kit',
  'REPO',
];
const dataStatus: string[] = [
  'DRAFT',
  'PUBLISHED',
  'SUBMITTED',
];
const dataTo: string[] = [
  'RADAR4Kit',
  'RADAR4Chem',
  'REPO',
  'nmrXiv',
];

const SmartTable: React.FC = () => {
  const [
    size,
    setSize,
  ] = useState<SizeType>('small');
  const [
    dataOwner,
    setDataOwner,
  ] = useState<string[]>([]);
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
    ownerSelection,
    setOwnerSelection,
  ] = useState<string[]>([]);

  useEffect(() => {
    const setPersonNamesToState = async () => {
      await TestPersons('https://fakerapi.it/api/v1/users?_quantity=100').then((person) => {
        setDataOwner(person);
      }).catch((error) => {
        return error;
      });
    };

    void setPersonNamesToState();
  }, []);

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
      dataIndex: 'from',
      filterDropdown: () => {
        return AutoCompleteSearch(dataFrom, (value) => {
          setFromSelection(value);
        });
      },
      filteredValue: fromSelection.length === 0 ? null : ownerSelection && fromSelection,
      filterIcon: CustomFilterIcon(fromSelection.length !== 0),
      filters: FilterObjects(dataFrom),
      key: 'from',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.from.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.from.localeCompare(second.from, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'From',
    },
    {
      dataIndex: 'to',
      filterDropdown: () => {
        return AutoCompleteSearch(dataTo, (value) => {
          setToSelection(value);
        });
      },
      filteredValue: toSelection.length === 0 ? null : ownerSelection && toSelection,
      filterIcon: CustomFilterIcon(toSelection.length !== 0),
      filters: FilterObjects(dataTo),
      key: 'to',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.to.startsWith(value as string);
      },
      sorter: (first: DataType, second: DataType) => {
        return first.to.localeCompare(second.to, 'en', {
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
        return AutoCompleteSearch(dataStatus, (value) => {
          setStatusSelection(value);
        });
      },
      filteredValue: statusSelection.length === 0 ? null : ownerSelection && statusSelection,
      filterIcon: CustomFilterIcon(statusSelection.length !== 0),
      filters: FilterObjects(dataStatus),
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
      dataIndex: 'data_metadata',
      filteredValue: null,
      key: 'data_metadata',
      sorter: (first: DataType, second: DataType) => {
        return first.data_metadata.localeCompare(second.data_metadata, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Data/Metadata',
    },
    {
      dataIndex: 'tracker_number',
      filteredValue: null,
      key: 'tracker_number',
      sorter: (first: DataType, second: DataType) => {
        return first.tracker_number.localeCompare(second.tracker_number, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Tracker Number',
    },
    {
      dataIndex: 'owner',
      filterDropdown: () => {
        return AutoCompleteSearch(dataOwner, (value) => {
          setOwnerSelection(value);
        });
      },
      filteredValue: ownerSelection,
      filterIcon: CustomFilterIcon(ownerSelection.length !== 0),
      key: 'owner',
      onFilter: (value: boolean | number | string, record: DataType) => {
        return record.owner.toLowerCase().includes(String(value).toLowerCase());
      },
      sorter: (first: DataType, second: DataType) => {
        return first.owner.localeCompare(second.owner, 'en', {
          sensitivity: 'base',
        });
      },
      title: 'Owner',
    },
  ];

  const data: DataType[] = [];
  for (let index = 0; index < 10_000; index++) {
    data.push({
      data_metadata: `id: ${index}, data: metadata for some data`,
      date_time: '01.01.1970 12:30.00',
      from: dataFrom[Math.floor(Math.random() * dataFrom.length)] ?? '',
      id: index + 1,
      owner: dataOwner[Math.floor(Math.random() * dataOwner.length)] ?? '',
      status: dataStatus[Math.floor(Math.random() * dataStatus.length)] ?? '',
      to: dataTo[Math.floor(Math.random() * dataTo.length)] ?? '',
      tracker_number: `T221001-ERC-0${index}`,
    });
  }

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
            dataSource={data}
            pagination={{
              position: [
                'bottomCenter',
              ],
            }}
          />
        </Space>
      </div>
    </div>
  );
};

export default SmartTable;
