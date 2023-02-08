import {
  Button,
  Form,
  Input,
} from 'antd';
import React from 'react';
import {
  csrfToken,
} from '../../container';

const layout = {
  labelCol: {
    span: 16,
  },
  wrapperCol: {
    span: 16,
  },
};

const onFinish = async (values: { email: string, }) => {
  await fetch('/users/password', {
    body: JSON.stringify({
      authenticity_token: csrfToken,
      commit: 'Send me reset password instructions',
      user: {
        email: values.email,
      },
    }),
    headers: {
      'Content-Type': 'application/json',
    },
    method: 'POST',
  });
};

export const PasswordResetForm: React.FC = () => {
  return (
    <Form
      style={{
        left: '-50%',
        marginTop: '48px',
        position: 'relative',
      }}
      {...layout} name='nest-messages' onFinish={onFinish}
    >
      <Form.Item
        hasFeedback
        label='E-Mail'
        name='email'
        rules={[
          {
            message: 'Please enter a valid email address',
          },
          {
            required: true,
            type: 'email',
          },
        ]}
      >
        <Input
          placeholder='E-Mail'
          style={{
            minWidth: '300px',
          }}
          type='email'
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
  );
};
