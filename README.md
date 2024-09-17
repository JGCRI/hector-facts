# Hector-FACTS

## Framework for Assessing Changes To Sea-level (FACTS)

[![DOI](https://zenodo.org/badge/151614681.svg)](https://zenodo.org/badge/latestdoi/151614681)

The Framework for Assessing Changes To Sea-level (FACTS) is an open-source modular, scalable, and extensive framework for global mean, regional, and extreme sea level projection that is designed to support the characterization of ambiguity in sea-level projections. It is designed so users can easily explore deep uncertainty by investigating the implications on GMSL, RSL, and ESL of different choices for different processes. Its modularity allows components to be represented by either simple or complex model. Because it is built upon the Radical-PILOT computing stack, different modules can be dispatched for execution on resources appropriate to their computational complexity.

FACTS is being developed by the [Earth System Science & Policy Lab](https://www.earthscipol.net) and the [RADICAL Research Group](https://radical.rutgers.edu) at Rutgers University. FACTS is released under the MIT License.

See [fact-sealevel.readthedocs.io](https://fact-sealevel.readthedocs.io) for documentation.

For model description, see [Kopp, R. E., Garner, G. G., Hermans, T. H. J., Jha, S., Kumar, P., Reedy, A., Slangen, A. B. A., Turilli, M., Edwards, T. L., Gregory, J. M., Koubbe, G., Levermann, A., Merzky, A., Nowicki, S., Palmer, M. D., & Smith, C. (2023). The Framework for Assessing Changes To Sea-Level (FACTS) v1.0: A platform for characterizing parametric and structural uncertainty in future global, relative, and extreme sea-level change. Geoscientific Model Development, 16, 7461–7489.](https://doi.org/10.5194/gmd-16-7461-2023)

## Hector 

[![DOI](https://zenodo.org/badge/22892935.svg)](https://zenodo.org/badge/latestdoi/22892935)

**Hector** is an open source, object-oriented, simple global climate carbon-cycle model that runs very quickly while still representing the most critical global scale earth system processes. Hector is a simple climate model (SCM, also known as a reduced-complexity climate model), a class of models that are extremely versatile with a wide range of applications. Due to their computational efficiency, SCMs can easily be coupled to other models and used to design scenarios, emulate more complex climate models, and conduct uncertainty analyses.

## Hector-FACTS

This is a forked repository of the FACTS project which has been modified to use simple cliamte model [Hector](https://github.com/JGCRI/hector) in addition to Fair in its run. Integrating Hector into FACTS was done by Hector team members Kalyn Dorheim and Ciara Donegan. 


### Installing Hector-FACTS on Your Machine

Prerequisites: git and docker 

#### 1. Install git (if not already installed)

To install git, open your terminal and use the appropriate command for your operating system:

**On Ubuntu or Debian-based systems:**

```
sudo apt-get update
sudo apt-get install git
```

**On macOS:** 

```
brew install git
```

**On Windows:**

Install git via the [Git for Windows installer.](https://gitforwindows.org/)

To verify git is installed, run:
```
git --version
```

#### 2. Install docker (if not already installed)

To install docker, follow the instructions for your operating system:

**On Ubuntu or Debian-based systems:**

```
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

**On macOS or Windows:**

Download and install Docker from the official Docker website.

To verify docker is installed, run:

```
docker --version
```

#### 3. Clone the Hector-FACTS repository

Once git is installed, clone the Hector-FACTS repository:

```
git clone https://github.com/JGCRI/hector-facts.git
```

Navigate to the Hector-FACTS directory this will be project working direcotry (PROJ_DIR) for the rest of the instructions. 


#### 4. Install Project Data 

From the PROJ_DIR navigate to the modules-data folder and run the following to install the large data files that are stored on zenodo too large to save to github and has to be hosted on zenodo. 

```
cd modules-data
wget -i modules-data.urls.txt
```


#### 5. Docker Setup 

Unless you are on a Linux machine, the best way to run FACTS is using Docker. If you are new to Docker, we recommend visiting [the the offical docker documentaion](https://docs.docker.com/get-started/) for examples and reference materials. Here, we provide minimal instructions for getting Hector-FACTS running.

From the PROJ_DIR, build the Docker image. This process installs the dependencies and sets up the Hector-FACTS environment, which can be time-consuming but only needs to be done once (or after updating the Dockerfile or shutting down the image). 

```
cd docker
sh develop.sh
```

Build the container where Hector-FACTS (and FACTS) experiments can be run. Note: Replace PROJ_DIR with the full path to the Hector-FACTS repository. After launching, navigate to the /opt folder. Running `ls` here should show the contents of the Hector-FACTS repository.

```
docker run --rm -it -v PROJ_DIR:/opt facts
cd opt
```

