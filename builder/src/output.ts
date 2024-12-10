import { Eta } from '@eta-dev/eta';
import * as path from '@std/path';
import { ok, err, type Result } from './utils.ts';
import { type PlatformSchema, type Configuration } from './schemas.ts';
// Build Configurations
interface System {
  name: string;
  platform: PlatformSchema;
  darwin;
}
export const set_configurations = async (
  input_configurations: Configuration,
  outputPath: string
): Promise<Result<null, string>> => {
  // TODO: Resolve Mappings
  // Read Templates
  if (import.meta.dirname == undefined)
    return err('Cli Error Missing Meta Dirname');
  const eta = new Eta({
    views: path.join(import.meta.dirname, 'templates'),
    tags: ['{{', '}}'],
  });
  // TODO: Generate Templates
  // TODO: Render Files
  console.log(await eta.renderAsync('flake.nix', { test: 't' }));
  console.log(outputPath);
  return ok(null);
};
