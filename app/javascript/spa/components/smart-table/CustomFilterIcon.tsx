import {
  SearchOutlined,
} from '@ant-design/icons';
import {
  Space,
} from 'antd';
import React from 'react';

export const CustomFilterIcon: React.FC<boolean> = (filtered: boolean) => {
  return (
    <Space>
      <SearchOutlined style={{
        color: filtered ? '#1890ff' : undefined,
      }}
      />
    </Space>
  );
};
