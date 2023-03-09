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
import Title from 'antd/es/typography/Title';
import React, {
  useCallback,
  useContext,
} from 'react';
import {
  RegisterContext,
} from '../../contexts/RegisterContext';
import {
  Register,
} from '../../helpers/RegistrationHelper';

export const RegisterForm: React.FC = () => {
  const [
    api,
    contextHolder,
  ] = notification.useNotification();

  const {
    setRegister,
  } = useContext(RegisterContext);

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
          Notification('bottomRight', 'Confirmation required', 'Please check your email mailbox and confirm your account.');
          setInterval(() => {
            setRegister(false);
          }, 3_000);
        }
      });
    }
  };

  const numberPattern = /(?=.*\d)/u;
  const upcasePattern = /(?=.*[A-Z])/u;
  const specialCharacterPattern = /[^\w\s]/u;

  const onClick = () => {
    setRegister(false);
  };

  return (
    <div>
      <Title
        level={3} style={{
          alignItems: 'center',
          display: 'flex',
          justifyContent: 'center',
        }}
      >Sign up</Title>
      {contextHolder}
      <Form
        layout='vertical'
        name='nest-messages'
        onFinish={onFinish} style={{
          marginTop: '48px',
        }}
      >
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
          <Input
            placeholder='Name'
            style={{
              minWidth: '300px',
            }}
          />
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
          <Input
            placeholder='E-Mail'
            style={{
              minWidth: '300px',
            }}
          />
        </Form.Item>
        <Form.Item
          hasFeedback
          label='Password'
          name='password'
          rules={[
            {
              message: 'Password must be at least 6 characters long',
              min: 6,
            },
            {
              message: 'Password must have at least 1 number',
              pattern: numberPattern,
            },
            {
              message: 'Password must have at least 1 uppercase letter',
              pattern: upcasePattern,
            },
            {
              message: 'Password must have at least 1 special character',
              pattern: specialCharacterPattern,
            },
            {
              required: true,
              type: 'regexp',
            },
          ]}
        >
          <Input
            placeholder='Password'
            style={{
              minWidth: '300px',
            }}
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
            style={{
              minWidth: '300px',
            }}
            type='password'
          />
        </Form.Item>
        <Form.Item>
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
