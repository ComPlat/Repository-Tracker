// HINT: https://mariusschulz.com/blog/assertion-functions-in-typescript
export default function assertNonNullish<TValue> (
  value: TValue,
  message: string,
): asserts value is NonNullable<TValue> {
  if (value === null || value === undefined) {
    throw new Error(message);
  }
}
