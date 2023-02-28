import {
  Button,
  Col,
  Form,
  Input,
  notification,
  Row,
  Space,
} from 'antd';
import type {
  NotificationPlacement,
} from 'antd/es/notification/interface';
import React, {
  useCallback,
} from 'react';
import {
  useNavigate,
} from 'react-router-dom';
import {
  csrfToken,
} from '../../containerSpa';

export const PasswordResetForm: React.FC = () => {
  const navigate = useNavigate();

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

  const onFinish = async (values: { email: string, }): Promise<void> => {
    const response = await fetch('/users/password', {
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

    switch (response.status) {
      case 200: return Notification('bottomRight', 'Password reset instructions sent', 'Please check your email mailbox and follow the instructions.');
      default: return Notification('bottomRight', 'Sending password reset instructions failed', 'Try again.');
    }
  };

  const onClick = () => {
    navigate('/');
  };

  return (
    <div>
      {contextHolder}
      <Form
        layout='vertical'
        name='nest-messages'
        onFinish={onFinish} style={{
          marginTop: '48px',
        }}
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
        <Form.Item >
          <Row justify='space-between'>
            <Space>
              <Col span={4}>
                <Button htmlType='submit' type='primary'>
                  Submit
                </Button>
              </Col>
              <Col span={4}>
                <Button htmlType='button' key='button-navigate-to-root' onClick={onClick} type='default'>
                  Back Home
                </Button>
              </Col>
            </Space>
          </Row>
        </Form.Item>
      </Form>
    </div>
  );
};
