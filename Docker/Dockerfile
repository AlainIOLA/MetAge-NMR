FROM python:3.9-slim@sha256:aeebfa2890da7819f1617ec9a5650669570ab0802e5f51063aa8b7499da1ed26

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

# Install only the strictly necessary system dependencies
RUN apt-get update && apt-get install -y \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the jovyan user and working directory
RUN useradd -ms /bin/bash -u 1000 jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan

# Switch to the jovyan user
USER jovyan
WORKDIR /home/jovyan/work

ENV PATH="/home/jovyan/.local/bin:$PATH"

# Create the output directory to ensure volume mounting works correctly
RUN mkdir -p /home/jovyan/work/output && chmod 777 /home/jovyan/work/output

# Copy the requirements.txt file and install dependencies
COPY --chown=jovyan:jovyan requirements.txt /tmp/
RUN pip install --no-cache-dir --user -r /tmp/requirements.txt

# Copy only the surviving models and reference files
COPY --chown=jovyan:jovyan dataPPMS_NOESY.csv dataPPMS_NOESY.csv
COPY --chown=jovyan:jovyan modelChol.bin modelChol.bin
COPY --chown=jovyan:jovyan modelHDL.bin modelHDL.bin
COPY --chown=jovyan:jovyan modelLDL.bin modelLDL.bin
COPY --chown=jovyan:jovyan modelTG.bin modelTG.bin
COPY --chown=jovyan:jovyan modelHemo.bin modelHemo.bin
COPY --chown=jovyan:jovyan modelCa.bin modelCa.bin
COPY --chown=jovyan:jovyan modelUrea.bin modelUrea.bin
COPY --chown=jovyan:jovyan modelUrate.bin modelUrate.bin
COPY --chown=jovyan:jovyan modelProt.bin modelProt.bin
COPY --chown=jovyan:jovyan modelAlbumin.bin modelAlbumin.bin
COPY --chown=jovyan:jovyan modelBili.bin modelBili.bin
COPY --chown=jovyan:jovyan modelCrp.bin modelCrp.bin
COPY --chown=jovyan:jovyan modelEgfr.bin modelEgfr.bin
COPY --chown=jovyan:jovyan modelEsr.bin modelEsr.bin
COPY --chown=jovyan:jovyan modelFe.bin modelFe.bin
COPY --chown=jovyan:jovyan modelFruc.bin modelFruc.bin
COPY --chown=jovyan:jovyan modelTransfe.bin modelTransfe.bin
COPY --chown=jovyan:jovyan modelLeuco.bin modelLeuco.bin
COPY --chown=jovyan:jovyan modelPlat.bin modelPlat.bin
COPY --chown=jovyan:jovyan modelEritro.bin modelEritro.bin
COPY --chown=jovyan:jovyan modelGlycA.bin modelGlycA.bin
COPY --chown=jovyan:jovyan modelGlycB.bin modelGlycB.bin
COPY --chown=jovyan:jovyan modelSPC.bin modelSPC.bin
COPY --chown=jovyan:jovyan modelApoB.bin modelApoB.bin
COPY --chown=jovyan:jovyan modelLPA.bin modelLPA.bin
COPY --chown=jovyan:jovyan ppmsLPA.txt ppmsLPA.txt

# Copy the startup script and notebook
COPY --chown=jovyan:jovyan start.sh .
RUN chmod +x start.sh
COPY --chown=jovyan:jovyan nmrhealthquant.ipynb nmrhealthquant.ipynb

EXPOSE 8888

# Command to run the custom startup script
CMD ["/home/jovyan/work/start.sh"]
