import * as path from '@std/path';
import { colors } from '@cliffy/ansi/colors';

// Path
export const get_dir = (dir: string) => {
  const cwd = Deno.cwd();
  return path.join(cwd, dir);
};
// Cli Errors
export const error = (message: string) => {
  console.error(`[${colors.red.bold('Error')}]: ${message}`);
  return Deno.exit(1);
};
// Result
export type Result<Ok, Err> =
  | { ok: Ok; isErr: false }
  | { err: Err; isErr: true };
export const ok = <Ok, Err>(ok: Ok): Result<Ok, Err> => ({ ok, isErr: false });
export const err = <Ok, Err>(err: Err): Result<Ok, Err> => ({
  err,
  isErr: true,
});
