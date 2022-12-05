import {
  DownOutlined,
} from '@ant-design/icons';
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
  ColumnsType,
  TableProps,
} from 'antd/es/table';
import React, {
  useState,
} from 'react';

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
const dataOwner: string[] = [
  'John Doe',
  'Jane Doe',
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

const columns: ColumnsType<DataType> = [
  {
    dataIndex: 'id',
    key: 'id',
    sorter: (a, b) => {
      return a.id - b.id;
    },
    title: 'ID',
  },
  {
    dataIndex: 'from',
    filters: [
      {
        text: dataFrom[0],
        value: 'ELN',
      },
      {
        text: dataFrom[1],
        value: 'RADAR4Kit',
      },
      {
        text: dataFrom[2],
        value: 'REPO',
      },
    ],
    key: 'from',
    onFilter: (value, record) => {
      return record.from.startsWith(value as string);
    },
    sorter: (a, b) => {
      return a.from.localeCompare(b.from, 'en', {
        sensitivity: 'base',
      });
    },
    title: 'From',
  },
  {
    dataIndex: 'to',
    filters: [
      {
        text: dataTo[0],
        value: 'RADAR4Kit',
      },
      {
        text: dataTo[1],
        value: 'RADAR4Chem',
      },
      {
        text: dataTo[2],
        value: 'REPO',
      },
      {
        text: dataTo[3],
        value: 'nmrXiv',
      },
    ],
    key: 'to',
    onFilter: (value, record) => {
      return record.to.startsWith(value as string);
    },
    sorter: (a, b) => {
      return a.to.localeCompare(b.to, 'en', {
        sensitivity: 'base',
      });
    },
    title: 'To',
  },
  {
    dataIndex: 'date_time',
    key: 'date_time',
    sorter: true,
    title: 'Date/Time',
  },
  {
    dataIndex: 'status',
    filters: [
      {
        text: dataStatus[0],
        value: 'DRAFT',
      },
      {
        text: dataStatus[1],
        value: 'PUBLISHED',
      },
      {
        text: dataStatus[2],
        value: 'SUBMITTED',
      },
    ],
    key: 'status',
    onFilter: (value, record) => {
      return record.status.startsWith(value as string);
    },
    sorter: (a, b) => {
      return a.status.localeCompare(b.status, 'en', {
        sensitivity: 'base',
      });
    },
    title: 'Status',
  },
  {
    dataIndex: 'data_metadata',
    key: 'data_metadata',
    sorter: true,
    title: 'Data/Metadata',
  },
  {
    dataIndex: 'tracker_number',
    key: 'tracker_number',
    sorter: true,
    title: 'Tracker Number',
  },
  {
    dataIndex: 'owner',
    filters: [
      {
        text: dataOwner[0],
        value: 'John Doe',
      },
      {
        text: dataOwner[1],
        value: 'Jane Doe',
      },
    ],
    key: 'owner',
    onFilter: (value, record) => {
      return record.owner.startsWith(value as string);
    },
    sorter: (a, b) => {
      return a.owner.localeCompare(b.owner, 'en', {
        sensitivity: 'base',
      });
    },
    title: 'Owner',
  },
  {
    key: 'action',
    render: () => {
      return <Space size='middle'>
        <a href='/'>Delete</a>
        <a href='/'>
          <Space>
            More actions
            <DownOutlined />
          </Space>
        </a>
      </Space>;
    },
    sorter: true,
    title: 'Action'
    ,
  },
];

const data: DataType[] = [];
for (let index = 1; index <= 10_000; index++) {
  data.push({
    data_metadata: `id: ${index}, data: metadata for some data`,
    date_time: '01.01.1970 12:30.00',
    from: dataFrom[Math.floor(Math.random() * dataFrom.length)] ?? '',
    id: index,
    owner: dataOwner[Math.floor(Math.random() * dataOwner.length)] ?? '',
    status: dataStatus[Math.floor(Math.random() * dataStatus.length)] ?? '',
    to: dataTo[Math.floor(Math.random() * dataTo.length)] ?? '',
    tracker_number: `T221001-ERC-0${index}`,
  });
}

const SmartTable: React.FC = () => {
  const [
    size,
    setSize,
  ] = useState<SizeType>('large');

  const handleSizeChange = (event: RadioChangeEvent) => {
    setSize(event.target.value);
  };

  const tableColumns = columns.map((item) => {
    return {
      ...item,
    };
  });

  const tableProps: TableProps<DataType> = {
    bordered: true,
    loading: false,
    showHeader: true,
    size,
    tableLayout: 'fixed',
  };

  return (
    <>
      <Form layout='inline'>
        <div className='py-2'>
          <Form.Item label='Size'>
            <Radio.Group onChange={handleSizeChange} value={size}>
              <Radio.Button value='large'>Large</Radio.Button>
              <Radio.Button value='middle'>Middle</Radio.Button>
              <Radio.Button value='small'>Small</Radio.Button>
            </Radio.Group>
          </Form.Item>
        </div>
      </Form>
      <div className='py-4'>
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
      </div>
    </>
  );
};

export default SmartTable;
