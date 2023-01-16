import {
  Button,
  Form,
  Input,
} from 'antd';
import Title from 'antd/es/typography/Title';
import React from 'react';

const layout = {
  labelCol: {
    span: 16,
  },
  wrapperCol: {
    span: 16,
  },
};

const onFinish = (values) => {
  console.log(values);
};

export const SignUpForm = () => {
  return (
    <div style={{
      display: 'flex',
      gap: '3rem',
      position: 'relative',
    }}
    >
      <Title level={3}>Sign up</Title>
      <div style={{
        justifyContent: 'center',
      }}
      >
        <Form {...layout} name='nest-messages' onFinish={onFinish}>
          <Form.Item
            label='Name'
            name='name'
            rules={[
              {
                message: 'Please input your name!',
                required: true,
              },
            ]}
          >
            <Input placeholder='Name' />
          </Form.Item>
          <Form.Item
            label='E-Mail'
            name='email'
            rules={[
              {
                message: 'Not a valid E-Mail address',
                type: 'email',
              },
              {
                message: 'Please input your E-Mail address!',
                required: true,
              },
            ]}
          >
            <Input placeholder='E-Mail' />
          </Form.Item>
          <Form.Item
            hasFeedback
            label='Password'
            name='password'
            rules={[
              {
                type: 'regexp',
              },
            ]}
          >
            <Input
              placeholder='Password'
              type='password'
            />
          </Form.Item>
          <Form.Item
            dependencies={[
              'password',
            ]}
            hasFeedback
            label='Confirm password'
            name='confirm'
            rules={[
              {
                message: 'Please confirm your password!',
                required: true,
              },
              ({
                getFieldValue,
              }) => {
                return {
                  async validator (_, value) {
                    if (!value || getFieldValue('password') === value) {
                      await Promise.resolve();
                      return;
                    }

                    throw new Error('The two passwords that you entered do not match!');
                  },
                };
              },
            ]}
          >
            <Input
              placeholder='Password'
              type='password'
            />
          </Form.Item>
          <Form.Item wrapperCol={{
            ...layout.wrapperCol,
            offset: 16,
          }}
          >
            <Button htmlType='submit' type='primary'>
              Submit
            </Button>
          </Form.Item>
        </Form>
      </div>
    </div>
  );
};
