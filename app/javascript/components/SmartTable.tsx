/* eslint-disable canonical/prefer-inline-type-import */
import {
  DownOutlined,
} from '@ant-design/icons';
import {
  Form,
  Radio,
  type RadioChangeEvent,
  Space,
  Switch,
  Table,
} from 'antd';
import type {
  SizeType,
} from 'antd/es/config-provider/SizeContext';
import type {
  ColumnsType,
  TableProps,
} from 'antd/es/table';
import type {
  TableRowSelection,
} from 'antd/es/table/interface';
import React, {
  useMemo,
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

type TablePaginationPosition =
    'bottomCenter' | 'bottomLeft' | 'bottomRight' | 'topCenter' | 'topLeft' | 'topRight';

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
        <a href='https://google.de'>Delete</a>
        <a href='https://google.de'>
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

const defaultExpandable = {
  expandedRowRender: (record: DataType) => {
    return <p>{record.data_metadata}</p>;
  },
};

const SmartTable: React.FC = () => {
  const [
    size,
    setSize,
  ] = useState<SizeType>('large');
  const [
    rowSelection,
    setRowSelection,
  ] = useState<TableRowSelection<DataType> | undefined>({});
  const [
    hasData,
    setHasData,
  ] = useState(true);
  const [
    tableLayout,
    setTableLayout,
  ] = useState(undefined);
  const top = useMemo(() => {
    return 'none';
  }, []);
  const bottom = useMemo(() => {
    return 'bottomCenter';
  }, []);
  const [
    ellipsis,
    setEllipsis,
  ] = useState(false);
  const [
    yScroll,
    setYScroll,
  ] = useState(false);

  const handleSizeChange = (event: RadioChangeEvent) => {
    setSize(event.target.value);
  };

  const handleTableLayoutChange = (event: RadioChangeEvent) => {
    setTableLayout(event.target.value);
  };

  const handleEllipsisChange = (enable: boolean) => {
    setEllipsis(enable);
  };

  const handleRowSelectionChange = (enable: boolean) => {
    setRowSelection(enable ? {} : undefined);
  };

  const handleYScrollChange = (enable: boolean) => {
    setYScroll(enable);
  };

  const handleDataChange = (newHasData: boolean) => {
    setHasData(newHasData);
  };

  const tableColumns = columns.map((item) => {
    return {
      ...item,
      ellipsis,
    };
  });

  const tableProps: TableProps<DataType> = {
    bordered: true,
    expandable: defaultExpandable,
    loading: false,
    rowSelection,
    showHeader: true,
    size,
    tableLayout,
  };

  return (
    <>
      <Form
        className='repository-tracker-smart-table'
        layout='inline'
      >
        <div className='p-2 flex'>
          <Form.Item label='Choose Items'>
            <Switch checked={Boolean(rowSelection)} onChange={handleRowSelectionChange} />
          </Form.Item>
          <Form.Item label='Fixed Header'>
            <Switch checked={Boolean(yScroll)} onChange={handleYScrollChange} />
          </Form.Item>
          <Form.Item label='Has Data'>
            <Switch checked={Boolean(hasData)} onChange={handleDataChange} />
          </Form.Item>
          <Form.Item label='Ellipsis'>
            <Switch checked={Boolean(ellipsis)} onChange={handleEllipsisChange} />
          </Form.Item>
        </div>
        <div className='p-2 flex'>
          <div className='p-2'>
            <Form.Item label='Size'>
              <Radio.Group onChange={handleSizeChange} value={size}>
                <Radio.Button value='large'>Large</Radio.Button>
                <Radio.Button value='middle'>Middle</Radio.Button>
                <Radio.Button value='small'>Small</Radio.Button>
              </Radio.Group>
            </Form.Item>
          </div>
          <div className='p-2'>
            <Form.Item label='Table Layout'>
              <Radio.Group onChange={handleTableLayoutChange} value={tableLayout}>
                <Radio.Button value={undefined}>Unset</Radio.Button>
                <Radio.Button value='fixed'>Fixed</Radio.Button>
              </Radio.Group>
            </Form.Item>
          </div>
        </div>
      </Form>
      <Table
        {...tableProps}
        columns={tableColumns}
        dataSource={hasData ? data : []}
        pagination={{
          position: [
            top as TablePaginationPosition,
            bottom as TablePaginationPosition,
          ],
        }}
      />
    </>
  );
};

export default SmartTable;
