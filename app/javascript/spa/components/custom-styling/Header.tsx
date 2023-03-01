import React from 'react';

type Props = {
  children?: React.ReactNode,
  value?: string,
};

export const Header: React.FC<Props> = ({
  value = '3rem',
  children,
}) => {
  return (
    <div style={{
      marginBottom: value,
    }}
    >
      {children}
    </div>
  );
};
