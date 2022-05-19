# some command

* enter container: `cd docker/cli` and `./hijack.sh gpcc-main`
* compile path: `ccsrc`
* compile all: `make dev.dockerbuild`
* restart gpdb: `gpstop -air`
* if gpcc not in command: `source ~/usr/local/greenplum-cc/gpcc_path.sh`
* restart gpcc: `gpcc start`
* enter gpperfmon: `psql gpperfmon`
* change schema: `set search_path to gpmetrics;`
* agent.log path: `cclog`
* `10.117.190.12`
* open docker: `sudo systemctl start docker`
