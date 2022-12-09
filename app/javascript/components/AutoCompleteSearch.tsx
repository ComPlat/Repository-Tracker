import {
  Card,
  Select,
} from 'antd';
import React from 'react';

export const AutoCompleteSearch = (data: string[], onChange: ((value: never[], option: Array<{ text: string, value: string, }> | { text: string, value: string, }) => void)) => {
  return <Card
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
        data.map((item: string) => {
          return {
            text: item,
            value: item,
          };
        })
      }
      placeholder='Search...'
      style={{
        minWidth: '30vw',
        position: 'relative',
      }}
    />
  </Card>;
};
