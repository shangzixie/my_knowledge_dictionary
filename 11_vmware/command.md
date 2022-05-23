# some command

* open docker: `sudo systemctl start docker`
* compile all: `make dev.dockerbuild`
* enter container: `cd docker/cli` and `./hijack.sh gpcc-main`
* compile path: `ccsrc`
* restart gpdb: `gpstop -air`
* if gpcc not in command: `source ~/usr/local/greenplum-cc/gpcc_path.sh`
* restart gpcc: `gpcc start`
* enter gpperfmon: `psql gpperfmon`
* change schema: `set search_path to gpmetrics;`
* agent.log path: `cclog`
* `10.117.190.86`
* remote docker network: `docker network rm centos7-gpcc-gpdb_nw`