// Based on https://github.com/cachix/install-nix-action
import { execFileSync } from 'child_process';
import fs from 'fs';

export function run(emacsCIVersion : string) {
    fs.chmodSync(`${__dirname}/install-nix.sh`, 0o755);
    execFileSync(`${__dirname}/install-nix.sh`, [emacsCIVersion], { stdio: 'inherit' });
}
