import {
  SearchOutlined,
} from '@ant-design/icons';
import React from 'react';

export const CustomFilterIcon: React.FC<boolean> = (filtered: boolean) => {
  return <SearchOutlined style={{
    color: filtered ? '#1890ff' : undefined,
  }}
  />;
};
