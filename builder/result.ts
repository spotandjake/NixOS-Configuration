export type Result<Ok, Err> =
  | { ok: Ok; isErr: false }
  | { err: Err; isErr: true };
export const ok = <Ok, Err>(ok: Ok): Result<Ok, Err> => ({ ok, isErr: false });
export const err = <Ok, Err>(err: Err): Result<Ok, Err> => ({
  err,
  isErr: true,
});
