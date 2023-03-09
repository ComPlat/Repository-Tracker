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
} from '../../containerSpa';
import {
  PasswordChangeContext,
} from '../../contexts/PasswordChangeContext';
import {
  atLeastOneLowercaseLetter,
  atLeastOneNumber,
  atLeastOneSpecialCharacter,
  atLeastOneUppercaseLetter,
  atLeastSixCharactersLong,
  noWhitespaces,
} from '../../helpers/PasswordValidationHelper';

export const NewPasswordForm: React.FC = () => {
  const navigate = useNavigate();

  const [
    searchParameters,
  ] = useSearchParams();

  const resetPasswordToken = searchParameters.get('reset_password_token');

  const {
    setPasswordChange,
  } = useContext(PasswordChangeContext);

  const onFinish = async (values: { confirm: string, password: string, }): Promise<void> => {
    const response = await fetch('/users/password', {
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
    });

    switch (response.status) {
      case 200: return setPasswordChange('success');
      case 422: return setPasswordChange('error');
      default: throw new Error('Unexpected error');
    }
  };

  const onClick = () => {
    navigate('/');
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
          atLeastSixCharactersLong,
          atLeastOneNumber,
          atLeastOneUppercaseLetter,
          atLeastOneLowercaseLetter,
          atLeastOneSpecialCharacter,
          noWhitespaces,
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
  );
};
