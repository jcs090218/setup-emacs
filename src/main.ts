import * as core from "@actions/core";
import * as installNix from "./installNix";
import * as windows from "./windows";

async function run() {
    try {
        core.startGroup("Installing Emacs");

        switch (process.platform) {
            case "win32": {
                await windows.run();
            } break;
            default: {
                const version = core.getInput("version");
                const emacsCIVersion = "emacs-" + version.replace(".", "-");
                await installNix.run(emacsCIVersion);
            } break;
        }

        core.endGroup();

        // show Emacs version
        await exec.exec('emacs', ['--version']);
    } catch (error) {
        let errorMsg = "Failed to do something exceptional";
        if (error instanceof Error) {
            errorMsg = error.message;
        }
        core.setFailed(errorMsg);
    }
}

run();
