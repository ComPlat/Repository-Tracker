import React from 'react';

type Props = {
  children?: React.ReactNode,
  value?: string,
};

export const Padding: React.FC<Props> = ({
  value = '3rem',
  children,
}) => {
  return (
    <div style={{
      padding: value,
    }}
    >
      {children}
    </div>
  );
};
