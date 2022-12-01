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
  address: string,
  age: number,
  description: string,
  key: number,
  name: string,
};

type TablePaginationPosition =
    'bottomCenter' | 'bottomLeft' | 'bottomRight' | 'topCenter' | 'topLeft' | 'topRight';

const columns: ColumnsType<DataType> = [
  {
    dataIndex: 'name',
    title: 'Name',
  },
  {
    dataIndex: 'age',
    sorter: (a, b) => {
      return a.age - b.age;
    },
    title: 'Age',
  },
  {
    dataIndex: 'address',
    filters: [
      {
        text: 'London',
        value: 'London',
      },
      {
        text: 'New York',
        value: 'New York',
      },
    ],
    onFilter: (value, record) => {
      return record.address.startsWith(value as string);
    },
    title: 'Address',
  },
  {
    key: 'action',
    render: () => {
      return <Space size='middle'>
        <a>Delete</a>
        <a>
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
for (let index = 1; index <= 10; index++) {
  data.push({
    address: `New York No. ${index} Lake Park`,
    age: Number(`${index}2`),
    description: `My name is John Brown, I am ${index}2 years old, living in New York No. ${index} Lake Park.`,
    key: index,
    name: 'John Brown',
  });
}

const defaultExpandable = {
  expandedRowRender: (record: DataType) => {
    return <p>{record.description}</p>;
  },
};
const defaultTitle = () => {
  return 'Here is title';
};

const defaultFooter = () => {
  return 'Here is footer';
};

const SmartTable: React.FC = () => {
  const bordered = useMemo(() => {
    return true;
  }, []);
  const loading = useMemo(() => {
    return false;
  }, []);
  const [
    size,
    setSize,
  ] = useState<SizeType>('large');
  const expandable = useMemo(() => {
    return defaultExpandable;
  }, []);
  const showTitle = useMemo(() => {
    return false;
  }, []);
  const showHeader = useMemo(() => {
    return true;
  }, []);
  const showfooter = useMemo(() => {
    return false;
  }, []);
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
  const [
    xScroll,
    setXScroll,
  ] = useState<string | undefined>(undefined);

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

  const handleXScrollChange = (event: RadioChangeEvent) => {
    setXScroll(event.target.value);
  };

  const handleDataChange = (newHasData: boolean) => {
    setHasData(newHasData);
  };

  const scroll: { x?: number | string, y?: number | string, } = {};
  if (yScroll) {
    scroll.y = 240;
  }

  if (xScroll) {
    scroll.x = '100vw';
  }

  const tableColumns = columns.map((item) => {
    return {
      ...item,
      ellipsis,
    };
  });
  if (xScroll === 'fixed') {
    tableColumns[0].fixed = true;
    tableColumns[tableColumns.length - 1].fixed = 'right';
  }

  const tableProps: TableProps<DataType> = {
    bordered,
    expandable,
    footer: showfooter ? defaultFooter : undefined,
    loading,
    rowSelection,
    scroll,
    showHeader,
    size,
    tableLayout,
    title: showTitle ? defaultTitle : undefined,
  };

  return (
    <>
      <div className='py-8'><h1>Repository-Tracker</h1></div>
      <Form
        className='repository-tracker-smart-table'
        layout='inline'
        style={{
          marginBottom: 24,
        }}
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
            <Form.Item label='Table Scroll'>
              <Radio.Group onChange={handleXScrollChange} value={xScroll}>
                <Radio.Button value={undefined}>Unset</Radio.Button>
                <Radio.Button value='scroll'>Scroll</Radio.Button>
                <Radio.Button value='fixed'>Fixed Columns</Radio.Button>
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
        scroll={scroll}
      />
    </>
  );
};

export default SmartTable;
