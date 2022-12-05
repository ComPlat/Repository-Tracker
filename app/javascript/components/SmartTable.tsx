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
    key: 'from',
    sorter: true,
    title: 'From',
  },
  {
    dataIndex: 'to',
    key: 'to',
    sorter: true,
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
    key: 'status',
    sorter: true,
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
    key: 'owner',
    sorter: true,
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
    from: 'ELN',
    id: index,
    owner: 'John Doe',
    status: 'DRAFT',
    to: 'RADAR4Chem',
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
