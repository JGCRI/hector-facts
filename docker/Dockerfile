FROM ubuntu:focal AS facts-core

ENV DEBIAN_FRONTEND="noninteractive"

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update &&\
    apt-get install -y \
        python3.9 \
        python3-pip \
        python3.8-venv \
        git \
        sudo \
        libhdf5-dev \
        libnetcdf-dev \
        gnupg \
        curl \
        apt-transport-https \
        dnsutils \
        iputils-ping

RUN python3 -m venv --system-site-packages /home/${NB_USER}/factsVe &&\
    source /home/${NB_USER}/factsVe/bin/activate

RUN pip install --no-cache-dir --upgrade \
        setuptools==69.0.2 pip==23.3.1 wheel==0.42.0

RUN pip install --no-cache-dir \
        radical.entk==1.52.0 \
        radical.gtod==1.52.0 \
        radical.pilot==1.52.1 \
        radical.saga==1.52.0 \
        radical.utils==1.52.0 \
        pyyaml==6.0.1 \
        xarray==2023.1.0 \
        numpy==1.24.4 \
        netcdf4==1.6.5 \
        h5py \
        dask

RUN apt-get update &&\
    apt-get install -y --no-install-recommends r-base \
        cmake \
        libopenblas-dev \
        gfortran

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root
RUN chown -R ${NB_UID}:${NB_UID} /home/${NB_USER}
USER ${NB_USER}

RUN mkdir -p /home/${NB_USER}/radical.pilot.sandbox

ENV RP_PILOT_SANDBOX=/home/${NB_USER}/radical.pilot.sandbox

RUN echo 'source /home/${NB_USER}/factsVe/bin/activate' >> /home/${NB_USER}/.bashrc

RUN mkdir -p /home/${NB_USER}/.radical/pilot/configs
RUN printf '{\n\
    "local": {\n\
        "rp_version"    : "installed",\n\
        "virtenv_mode"  : "use"\n\
    }\n\
}' > /home/${NB_USER}/.radical/pilot/configs/resource_local.json

CMD ["/bin/bash", "-c", "source /home/${NB_USER}/factsVe/bin/activate && exec /bin/bash"]

FROM facts-core AS facts-jupyter

USER root
RUN pip install --no-cache-dir \
	matplotlib==3.7.4 \
	notebook==7.0.6 \
	jupyterlab==4.0.9 \
	jupyter==1.0.0

EXPOSE 8888
USER ${NB_USER}

ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]
