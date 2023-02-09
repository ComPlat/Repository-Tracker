import {
  Button,
  Col,
  Form,
  Input,
  Row,
  Space,
} from 'antd';
import React, {
  useContext,
} from 'react';
import {
  useNavigate,
  useSearchParams,
} from 'react-router-dom';
import {
  csrfToken,
} from '../../container';
import {
  PasswordChangeContext,
} from '../../contexts/PasswordChangeContext';

export const NewPasswordForm: React.FC = () => {
  const navigate = useNavigate();

  const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&-])[A-Za-z\d@$!%*?&-]{6,}$/u;

  const [
    searchParameters,
  ] = useSearchParams();

  const resetPasswordToken = searchParameters.get('reset_password_token');

  const {
    setPasswordChange,
  } = useContext(PasswordChangeContext);

  const onFinish = async (values: { confirm: string, password: string, }) => {
    await fetch('/users/password', {
      body: JSON.stringify({
        authenticity_token: csrfToken,
        user: {
          password: values.password,
          password_confirmation: values.confirm,
          reset_password_token: resetPasswordToken,
        },
      }),
      headers: {
        'Content-Type': 'application/json',
      },
      method: 'PUT',
    }).then((response) => {
      if (response.status === 200) {
        setPasswordChange('success');
      } else if (response.status === 422) {
        setPasswordChange('error');
      }
    });
  };

  return (
    <Form
      layout='vertical'
      name='nest-messages'
      onFinish={onFinish} style={{
        marginTop: '48px',
      }}
    >
      <Form.Item
        hasFeedback
        label='Password'
        name='password'
        rules={[
          {
            message: 'Password must be at least 6 characters long, have at least 1 number, 1 uppercase letter and 1 special character (@$!%*?&-)',
            pattern: passwordPattern,
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
              <Button
                htmlType='button' key='button-navigate-to-root' onClick={() => {
                  navigate('/');
                }}
                type='default'
              >
                Back Home
              </Button>
            </Col>
          </Space>
        </Row>
      </Form.Item>
    </Form>
  );
};
