<p align="center">
  <img src="docs/images/nf-neuro_logo_light.png#gh-light-mode-only" alt="Sublime's custom image"/>
</p> <!-- omit in toc -->
<p align="center">
  <img src="docs/images/nf-neuro_logo_dark.png#gh-dark-mode-only" alt="Sublime's custom image"/>
</p> <!-- omit in toc -->

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![Imports: nf-core](https://img.shields.io/badge/nf--core-nf?label=import&style=flat&labelColor=ef8336&color=24B064)](https://pycqa.github.io/nf-core/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
![Checks](https://github.com/scilus/nf-neuro/workflows/Merge%20to%20main%20checks/badge.svg)

Welcome to the `nf-neuro` project ! A **Nextflow** modules and workflows repository for neuroimaging
maintained by the [SCIL team](https://scil-documentation.readthedocs.io/en/latest/). The
primary focus of the library is to provide pre-built processes and processing sequences for
**neuroimaging**, optimized for _Nextflow DSL2_, based on open-source
technologies and made easily available to pipeline's developers through the `nf-core`
framework.

# WHY ? `nf-neuro`

**Let's say you develop a pipeline for neuroimaging**. You want to make it the more _efficient,_
_reliable, reproducible_ and also be able to _evaluate it_ and _control the quality_ of its outputs.
That's what `nf-neuro` provides to you, **all in one repository**, hosting **all dependencies** you
need to start developing and analyzing.

The only thing we ask of you is to develop in `Nextflow DSL2`. We use principle and standards
closely aligned with [nf-core](), but we'll make you adapt to them slowly as you go (we still
haven't finished complying to all of them ourselves). Using `nf-neuro` helps accelerate
development in **neuroimaging** and produces better research outcomes for all !

---

- [WHY ? `nf-neuro`](#why--nf-neuro)
- [Pipeline creation with `nf-neuro`](#pipeline-creation-with-nf-neuro)
  - [Prototyping using components from `nf-neuro`](#prototyping-using-components-from-nf-neuro)
    - [Environment setup](#environment-setup)
      - [Dependencies :](#dependencies-)
      - [Configuration :](#configuration-)
    - [Using components from `nf-neuro`](#using-components-from-nf-neuro)
      - [Using the information from the `info` command](#using-the-information-from-the-info-command)
    - [Basic prototype pipeline creation](#basic-prototype-pipeline-creation)
      - [`main.nf`](#mainnf)
      - [`main.nf` example:](#mainnf-example)
      - [`nextflow.config`](#nextflowconfig)
  - [Porting prototypes to `nf-` ready pipelines](#porting-prototypes-to-nf--ready-pipelines)
- [Developing within `nf-neuro`](#developing-within-nf-neuro)
  - [Manual configuration](#manual-configuration)
    - [Dependencies](#dependencies)
    - [Python environment](#python-environment)
    - [Loading the project's environment](#loading-the-projects-environment)
    - [Global environment](#global-environment)
    - [Working with VS Code](#working-with-vs-code)
  - [Configuration via the `devcontainer`](#configuration-via-the-devcontainer)
- [Contributing to the `nf-neuro` project](#contributing-to-the-nf-neuro-project)
- [Running tests](#running-tests)
- [Installing Prettier and editorconfig](#installing-prettier-and-editorconfig)

---

# Pipeline creation with `nf-neuro`

## Prototyping using components from `nf-neuro`

### Environment setup

We highly recommend using the integrated `development container` designed to streamline your installation
and support your development. To setup yourself, refer to [this section](./docs/DEVCONTAINER.md), then jump
straight to the [next section](#using-components-from-nf-neuro).

#### Dependencies :

- Python &geq; 3.8, < 3.13
- Docker &geq; 24 (we recommend using [Docker Desktop](https://www.docker.com/products/docker-desktop))
- Java Runtime &geq; 11, &leq; 17
  - On Ubuntu, install `openjdk-jre-<version>` packages
- Nextflow &geq; 23.04.0

> [!IMPORTANT]
> Nextflow might not detect the right `Java virtual machine` by default, more so if
> multiple versions of the runtime are installed. If so, you need to set the environment
> variable `JAVA_HOME` to target the right one.
>
> - Linux : look in `/usr/lib/jvm` for
>   a folder named `java-<version>-openjdk-<platform>` and use it as `JAVA_HOME`.
> - MacOS : if the `Java jvm` is the preferential one, use `JAVA_HOME=$(/usr/libexec/java_home)`.
>   Else, look into `/Library/Java/JavaVirtualMachines` for the folder with the correct
>   runtime version (named `jdk<inner version>_1<runtime version>.jdk`) and use the
>   following : `/Library/Java/JavaVirtualMachines/jdk<inner version>_1<runtime version>.jdk/Contents/Home`.

#### Configuration :

Install `nf-core` in your `python` environment (we recommend using a `virtual environment`) :

```bash
PYTHON_VERSION=3.10
virtualenv -p python${PYTHON_VERSION} venv && source venv/bin/activate
pip install nf-core==2.14.1
```

Configure your current environment so `nf-core` commands have access to `nf-neuro` modules :

```bash
export NFCORE_MODULES_GIT_REMOTE=https://github.com/scilus/nf-neuro.git
export NFCORE_MODULES_GIT_BRANCH=main
export NFCORE_SUBWORKFLOWS_GIT_REMOTE=https://github.com/scilus/nf-neuro.git
export NFCORE_SUBWORKFLOWS_GIT_BRANCH=main
```

### Using components from `nf-neuro`

With your environment ready, you can list `nf-neuro` modules and subworkflows with :

```bash
nf-core modules list remote
nf-core subworkflows list remote
```

To get more information on a module (say `denoising/nlmeans`) or a subworkflow (say `preproc_t1`), use :

```bash
nf-core modules info denoising/nlmeans
nf-core subworkflows info preproc_t1
```

You'll get a good description of the modules's or subworkflow's `behavior` and `dependencies`, as well as a
thorough description of its `inputs` and `outputs`. To use them in your own pipeline, you need first to
install them locally :

```bash
nf-core modules install denoising/nlmeans
nf-core subworkflows install preproc_t1
```

> [!WARNING]
> You need to be at the root of your `pipeline directory` when calling this command ! `nf-core` installs
> locally to your pipeline's `modules` and `subworkflows`, not in a special hidden place !

> [!NOTE]
> On the first run of the `install` command, select `pipeline` as an install setup. The interactive prompt
> will also ask you to create multiple files and directories. Say yes to everything !

> [!IMPORTANT]
> The installation procedure will provide you an `include` line to add to your pipeline's `main.nf`
> file, which will import the module or subworkflow at runtime.

#### Using the information from the `info` command

For a `module`, the list of `inputs` tell you the content to provide in `a single channel`, usually
as a list of lists, each starting with a `meta`, a map `[:]` of metadata containing a mandatory `id` :

```nextflow
// Example for denoising/nlmeans
input = Channel.of( [
    [ [id: "sub-1"], file("image1.nii.gz"), file("mask1.nii.gz") ],
    [ [id: "sub-2"], file("image2.nii.gz"), file("mask2.nii.gz") ]
] )

DENOSING_NLMEANS( input )
```

> [!WARNING]
> There are some exceptions here, due to limitations in current `nf-core` tools and standards.
>
> 1. some inputs could be associated to different channels. It's almost never the case, but it happens.
>    We are working hard at changing the behavior of those modules, and at improving the metadata to
>    help you better. For now, please refer to their implementation in the `modules/nf-neuro/`
>    directory as well, through the `main.nf` file.

For the `module's` list of `outputs`, each corresponds to its own `named channel` :

```nextflow
// Example for denoising/nlmeans
DENOISING_NLMEANS.out.image.view()            // [ [ [id: "sub-1"], "sub-1_denoised.nii.gz" ],
                                              //   [ [id: "sub-2"], "sub-2_denoised.nii.gz" ]  ]
DENOISING_NLMEANS.out.versions.first().view() // [ "versions.yml" ]
```

> [!WARNING]
> There are some exceptions here, due to limitations in current `nf-core` tools and standards.
>
> 1. `meta` output **is not a channel** but accompanies all files, produced by other channels.
> 2. `versions` is a channel, but its output is not accompanied by `meta`
> 3. Some other outputs are not accompanied by `meta` also. We are currently improving the metadata
>    files to make it apparent. For now, please refer to their implementation in the `modules/nf-neuro/`
>    directory, through the `main.nf` file.

For `subworkflows` there are no exceptions, nor differences between `inputs` and `outputs`; they are all
`named channels`. Each comes with a `Structure` description, telling you the content to put in the `list of lists`.
For `preproc_t1`, a simple example would be :

```nextflow
ch_image = Channel.of( [
    [ [id: "sub-1"], file("image1.nii.gz") ],
    [ [id: "sub-2"], file("image2.nii.gz") ]
] )

ch_template = Channel
    .of( [ [id: "sub-1"], [id: "sub-2"] ] )
    .combine( [ file("template.nii.gz") ] )
    .view()   // [ [ [id: "sub-1"], "template.nii.gz" ],
              //   [ [id: "sub-2"], "template.nii.gz" ]  ]

ch_probability_map = Channel
    .of( [ [id: "sub-1"], [id: "sub-2"] ] )
    .combine( [ file("probmap.nii.gz") ] )
    .view()   // [ [ [id: "sub-1"], "probmap.nii.gz" ],
              //   [ [id: "sub-2"], "probmap.nii.gz" ]  ]

PREPROC_T1(
    ch_image
    ch_template,
    ch_probability_map
)

PREPROC_T1.out.t1_final.view()          // [ [ [id: "sub-1"], "sub-1_t1_cropped.nii.gz" ],
                                        //   [ [id: "sub-2"], "sub-2_t1_cropped.nii.gz" ]  ]
PREPROC_T1.out.mask_final.view()        // [ [ [id: "sub-1"], "sub-1_t1_mask_cropped.nii.gz" ],
                                        //   [ [id: "sub-2"], "sub-2_t1_mask_cropped.nii.gz" ]  ]
PREPROC_T1.out.versions.first().view()  // [ "versions.yml" ]
```

### Basic prototype pipeline creation

To create a prototype pipeline (for personal use or testing), you will need to create a couple of files in addition to the `nf-neuro` modules/subworkflows. First, create those files at the root of your pipeline:
```
nextflow.config
main.nf
```
The `nextflow.config` file will contain your parameters for your pipeline execution that can be supplied as arguments when calling the pipeline (ex: `nextflow run main.nf --argument1 true`). The `main.nf` file will contain your pipeline. Let's take a look at this one first.

#### `main.nf`

As mentioned above, this file will be your main pipeline execution file, containing all the modules/subworkflows you want to run, and the channel definition between them. This is also where you will fetch your input files. This can be done using a workflow definition, here is an example for a basic usage:

```nextflow
workflow get_data {
    main:
        if ( !params.input ) {
            log.info "You must provide an input folder containing all images using:"
            log.info "        --input=/path/to/[input_folder]             Input folder containing multiple subjects for tracking"
            log.info ""
            log.info "                               [Input]"
            log.info "                               ├-- S1"
            log.info "                               |   ├-- *dwi.nii.gz"
            log.info "                               |   ├-- *dwi.bval"
            log.info "                               |   ├-- *dwi.bvec"
            log.info "                               |   ├-- *revb0.nii.gz"
            log.info "                               |   └-- *t1.nii.gz"
            log.info "                               └-- S2"
            log.info "                                    ├-- *dwi.nii.gz"
            log.info "                                    ├-- *bval"
            log.info "                                    ├-- *bvec"
            log.info "                                    ├-- *revb0.nii.gz"
            log.info "                                    └-- *t1.nii.gz"
            error "Please resubmit your command with the previous file structure."
        }

        input = file(params.input)

        // ** Loading all files. ** //
        dwi_channel = Channel.fromFilePairs("$input/**/*dwi.{nii.gz,bval,bvec}", size: 3, flat: true)
            { it.parent.name }
            .map{ sid, bvals, bvecs, dwi -> tuple(meta.id: sid, dwi, bvals, bvecs) } // Reordering the inputs.
        rev_channel = Channel.fromFilePairs("$input/**/*revb0.nii.gz", size: 1, flat: true)
            { it.parent.name }
            .map{ sid, rev -> tuple(meta.id: sid, rev) }
        t1_channel = Channel.fromFilePairs("$input/**/*t1.nii.gz", size: 1, flat: true)
            { it.parent.name }
            .map{ sid, t1 -> tuple(meta.id: sid, t1) }

    emit:
        dwi = dwi_channel
        rev = rev_channel
        t1 = t1_channel
}

// ** Now call your input workflow to fetch your files ** //
data = get_data()

data.dwi.view() // Contains your DWI data: [meta, [dwi, bval, bvec]]
data.rev.view() // Contains your reverse B0 data: [meta, [rev]]
data.t1.view() // Contains your anatomical data (T1 in this case): [meta, [t1]]
```

Now, you can install the modules you want to include in your pipeline. Let's import the `denoising/nlmeans` module for T1 denoising. To do so, simply install it using the `nf-core modules install` command.
```bash
nf-core modules install denoising/nlmeans
```
To use it in your pipeline, you need to import it at the top of your `main.nf` file. You can do it using the `include { YOUR_NAME } from ../path/main.nf` statement. Then, you can add it to your pipeline and feed your inputs to it! To have a look at which files are required to run the module, use the `nf-core modules info <your/module>` command. A complete example (e.g., fetching the inputs, importing the module, and supplying the inputs to the modules) can be seen below:
#### `main.nf` example:
```nextflow
include { DENOISING_NLMEANS } from './modules/nf-neuro/denoising/nlmeans/main.nf'

workflow get_data {
    main:
        if ( !params.input ) {
            log.info "You must provide an input folder containing all images using:"
            log.info "        --input=/path/to/[input_folder]             Input folder containing multiple subjects for tracking"
            log.info ""
            log.info "                               [Input]"
            log.info "                               ├-- S1"
            log.info "                               |   ├-- *dwi.nii.gz"
            log.info "                               |   ├-- *dwi.bval"
            log.info "                               |   ├-- *dwi.bvec"
            log.info "                               |   ├-- *revb0.nii.gz"
            log.info "                               |   └-- *t1.nii.gz"
            log.info "                               └-- S2"
            log.info "                                    ├-- *dwi.nii.gz"
            log.info "                                    ├-- *bval"
            log.info "                                    ├-- *bvec"
            log.info "                                    ├-- *revb0.nii.gz"
            log.info "                                    └-- *t1.nii.gz"
            error "Please resubmit your command with the previous file structure."
        }

        input = file(params.input)

        // ** Loading all files. ** //
        dwi_channel = Channel.fromFilePairs("$input/**/*dwi.{nii.gz,bval,bvec}", size: 3, flat: true)
            { it.parent.name }
            .map{ sid, bvals, bvecs, dwi -> tuple(meta.id: sid, dwi, bvals, bvecs) } // Reordering the inputs.
        rev_channel = Channel.fromFilePairs("$input/**/*revb0.nii.gz", size: 1, flat: true)
            { it.parent.name }
        anat_channel = Channel.fromFilePairs("$input/**/*t1.nii.gz", size: 1, flat: true)
            { it.parent.name }

    emit: // Those three lines below define your named output, use those labels to select which file you want.
        dwi = dwi_channel
        rev = rev_channel
        anat = anat_channel
}

inputs = get_data()

// ** Create the input channel for nlmeans. Note that it also can take a mask as input, but it is not required, replacing it by an empty list here. ** //
ch_denoising = inputs.t1
  .map{ it + [[]] } // This add one empty list to the channel, since we do not have a mask.

// ** Run DENOISING_NLMEANS ** //
DENOISING_NLMEANS( ch_denoising )

// ** You can then reuse the outputs and supply them to another module/subworkflow! ** //
ch_nextmodule = DENOISING_NLMEANS.out.image
  .join(ch_another_file)

NEXT_MODULE( ch_nextmodule )
```

#### `nextflow.config`

You now have a working `main.nf` file, but you did not specified any parameters to your pipeline yet. Let's do this using the `nextflow.config` file. First, you will want to define your publish directory options (where your files will be outputted). You can add those lines to the beginning of your `nextflow.config`:
```nextflow
process {
  publishDir = {"${params.output_dir}/$meta.id/${task.process.replaceAll(':', '-')}"}
}
```

Once this is done, you might want to supply parameters for some of your modules that could be modified when calling the pipeline, you can add them under the `params` flag. To know which parameters are accepted in your modules, refer to the `main.nf` of the specific `nf-neuro` module. `denoising/nlmeans` takes 1 possible parameter: `number_of_coils`. By defining it as below, we will be able to modify its value during the pipeline call using `--number_of_coils 1`.
```nextflow
params{
  input = false // This will be used to supply your input directory, using --input folder/

  // ** Denoising nlmeans parameters ** //
  number_of_coils = 1
}
```
The last step is to bind your parameters to the specific module they are meant for. This can be done by explicitly stating the modules, and attaching the parameters to the appropriate `task.ext`. To do this, add those lines for each of your modules in your `nextflow.config`:
```nextflow
withName: 'DENOISING_NLMEANS' {
  ext.number_of_coils = params.number_of_coils
}
```

That's it! Your `nextflow.config` should look something like this:
```
process {
  publishDir = {"${params.output_dir}/$sid/${task.process.replaceAll(':', '-')}"}
}

params{
  input = false // This will be used to supply your input directory, using --input folder/

  // ** Denoising nlmeans parameters ** //
  number_of_coils = 1
}

withName: 'DENOISING_NLMEANS' {
  ext.number_of_coils = params.number_of_coils
}
```

Once your pipeline is built, or when you want to test it, run `nextflow run main.nf --input <folder> --param1 true --param2 4 ...`.

## Porting prototypes to `nf-` ready pipelines

**SECTION TO COME**

# Developing within `nf-neuro`

The `nf-neuro` project requires some specific tools to be installed on your system so that the development environment runs correctly. You can [install them manually](#manual-configuration), but if you desire to streamline the process and start coding faster, we highly recommend using the [VS Code development container](./docs/DEVCONTAINER.md#development-environment) to get fully configured in a matter of minutes.

## Manual configuration

### Dependencies

- Python &geq; 3.8, < 3.13
- Docker &geq; 24 (we recommend using [Docker Desktop](https://www.docker.com/products/docker-desktop))
- Java Runtime &geq; 11, &leq; 17
  - On Ubuntu, install `openjdk-jre-<version>` packages
- Nextflow &geq; 23.04.0
- nf-test &geq; 0.9.0
- Node &geq; 14, `Prettier` and `editorconfig` (see [below](#installing-prettier-and-editorconfig))

> [!IMPORTANT]
> Nextflow might not detect the right `Java virtual machine` by default, more so if
> multiple versions of the runtime are installed. If so, you need to set the environment
> variable `JAVA_HOME` to target the right one.
>
> - Linux : look in `/usr/lib/jvm` for
>   a folder named `java-<version>-openjdk-<platform>` and use it as `JAVA_HOME`.
> - MacOS : if the `Java jvm` is the preferential one, use `JAVA_HOME=$(/usr/libexec/java_home)`.
>   Else, look into `/Library/Java/JavaVirtualMachines` for the folder with the correct
>   runtime version (named `jdk<inner version>_1<runtime version>.jdk`) and use the
>   following : `/Library/Java/JavaVirtualMachines/jdk<inner version>_1<runtime version>.jdk/Contents/Home`.

### Python environment

The project uses _poetry_ to manage python dependencies. To install it using pipx,
run the following commands :

```bash
pip install pipx
pipx ensurepath
pipx install poetry==1.8.-
```

> [!NOTE]
> If the second command above fails, `pipx` cannot be found in the path. Prepend the
> second command with `$(which python) -m` and rerun the whole block.

> [!WARNING]
> Poetry doesn't like when other python environments are activated around it. Make
> sure to deactivate any before calling `poetry` commands.

Once done, install the project with :

```bash
poetry install
```

### Loading the project's environment

> [!IMPORTANT]
> Make sure no python environment is activated before running commands !

The project scripts and dependencies can be accessed using :

```bash
poetry shell
```

which will activate the project's python environment in the current shell.

> [!NOTE]
> You will know the poetry environment is activated by looking at your shell. The
> input line should be prefixed by : `(nf-neuro-tools-py<version>)`, with `<version>`
> being the actual Python version used in the environment.

To exit the environment, simply enter the `exit` command in the shell.

> [!IMPORTANT]
> Do not use traditional deactivation (calling `deactivate`), since it does not relinquish
> the environment gracefully, making it so you won't be able to reactivate it without
> exiting the shell.

### Global environment

Set the following environment variables in your `.bashrc` (or whatever is the equivalent for your shell) :

```bash
export NFCORE_MODULES_GIT_REMOTE=https://github.com/scilus/nf-neuro.git
export NFCORE_MODULES_GIT_BRANCH=main
export NFCORE_SUBWORKFLOWS_GIT_REMOTE=https://github.com/scilus/nf-neuro.git
export NFCORE_SUBWORKFLOWS_GIT_BRANCH=main
```

This will make it so the `nf-core` commands target the right repository by default. Else, you'll need to add `--git-remote` and `--branch` options to pretty much all commands relating to `modules` and `subworkflows`.

### Working with VS Code

The `nf-neuro` project curates a bundle of useful extensions for Visual Studio Code, the `nf-neuro-extensions` package. You can find it easily on the [extension
marketplace](https://marketplace.visualstudio.com/items?itemName=nf-neuro.nf-neuro-extensionpack).

## Configuration via the `devcontainer`

Refer to [this section](./docs/DEVCONTAINER.md#development-environment).

# Contributing to the `nf-neuro` project

If you want to propose a new `module` to the repository, follow the guidelines in the [module creation](./docs/MODULE.md) documentation. The same goes for `subworkflows`, using [these guidelines](./docs/SUBWORKFLOWS.md) instead. We follow standards closely aligned with `nf-core`, with some exceptions on process atomicity and how test data is handled. Modules that don't abide to them won't be accepted and PR containing them will be closed automatically.

# Running tests

Tests are run through `nf-core`, using the command :

```bash
nf-core modules test <category/tool>
```

The tool can be omitted to run tests for all modules in a category.

# Installing Prettier and editorconfig

To install **Prettier** and **editorconfig** for the project, you need to have `node` and `npm` installed on your system to at least version 14. On Ubuntu, you can do it using snap :

```bash
sudo snap install node --classic
```

However, if you cannot install snap, or have another OS, refer to the [official documentation](https://nodejs.org/en/download/package-manager/) for the installation procedure.

Under the current configuration for the _Development Container_, for this project, we use the following procedure, considering `${NODE_MAJOR}` is at least 14 for Prettier :

```bash
curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - &&\
apt-get install -y nodejs

npm install --save-dev --save-exact prettier
npm install --save-dev --save-exact editorconfig-checker

echo "function prettier() { npm exec prettier $@; }" >> ~/.bashrc
echo "function editorconfig-checker() { npm exec editorconfig-checker $@; }" >> ~/.bashrc
```
