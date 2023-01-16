import {
  Button,
  Form,
  Input,
  notification,
} from 'antd';
import type {
  NotificationPlacement,
} from 'antd/es/notification/interface';
import Title from 'antd/es/typography/Title';
import React, {
  useCallback,
} from 'react';
import {
  Register,
} from '../../helpers/Registration';

const layout = {
  labelCol: {
    span: 16,
  },
  wrapperCol: {
    span: 16,
  },
};

export const SignUpForm = () => {
  const [
    api,
    contextHolder,
  ] = notification.useNotification();

  const Notification = useCallback((placement: NotificationPlacement, message: string, description: string) => {
    api.info({
      description,
      message,
      placement,
    });
  }, [
    api,
  ]);

  const onFinish = async (values: { confirm: string, email: string, password: string, }) => {
    if (values.password === values.confirm) {
      await Register(values.email, values.password).then((response) => {
        if (response.email[0] === 'has already been taken') {
          Notification('bottomRight', 'Registration unsuccessful', 'E-Mail has already been taken.');
        } else {
          Notification('bottomRight', 'Registration successful', 'You have successfully signed up.');
        }
      });
    }
  };

  return (
    <div>
      <Title level={3}>Sign up</Title>
      {contextHolder}
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
  );
};
