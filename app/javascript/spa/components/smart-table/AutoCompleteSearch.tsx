import {
  Card,
  Select,
  Space,
} from 'antd';
import React from 'react';
import {
  FilterObjectsHelper,
} from '../../helpers/FilterObjectsHelper';

export const AutoCompleteSearch: React.FC<string[]> = (data: string[], onChange: ((value: never[], option: Array<{ text: string, value: string, }> | { text: string, value: string, }) => void)) => {
  return (
    <Space>
      <Card
        bodyStyle={{
          padding: '16px',
        }}
      >
        <Select
          allowClear
          defaultValue={[]}
          mode='multiple'
          onChange={onChange}
          options={
            FilterObjectsHelper(data)
          }
          placeholder='Search...'
          style={{
            minWidth: '30vw',
            position: 'relative',
          }}
        />
      </Card>
    </Space>
  );
};
