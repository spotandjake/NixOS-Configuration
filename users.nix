{ apps, bundles }: {
  spotandjake = {
    darwinPrograms = [];
    linuxPrograms = [];
    sharedPrograms = [];
    bundles = bundles.minDevEnv;
  };
}