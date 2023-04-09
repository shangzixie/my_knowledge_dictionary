# some command

* open docker: `sudo systemctl start docker` `sudo snap start docker`
* enter container: `cd docker/cli` and `./hijack.sh gpcc-main`
  * root login: `/bin/bash ./hijack.sh root gpcc-main`
* root run container: `docker exec -it -u root gpcc-main /bin/bash`
* compile path: `ccsrc`
* if gpcc not in command: `source ~/usr/local/greenplum-cc/gpcc_path.sh`
* recompile: `gpcc stop && make dev.dockerbuild && gpcc start`
* stop gpcc: `gpcc stop`
* compile all: `make dev.dockerbuild`
* restart gpcc: `gpcc start`
* restart gpdb: `gpstop -air`
* enter gpperfmon: `psql gpperfmon`
* change schema: `set search_path to gpmetrics;`
* agent.log path: `cclog`
* `10.117.190.86`
* remote docker network: `docker network rm centos7-gpcc-gpdb_nw`
* gp_log: webserver.log
* beego_log: gpccws.log
* rerun frontend and backend: `make clean;pkill ccagent;pkill gpccws;make dev.backendrun`
* yarn mirror: `yarn config set registry https://registry.npm.taobao.org/`
* yarn mirror recover: `yarn config set registry https://registry.yarnpkg.com`
* frontend install: `cd frontend; npm config set registry https://registry.npm.taobao.org; npm install -g yarn ; yarn install; yarn upgrade file:../../pivotal-ui/dist`
* front-end test: `npm run test:tdd-remote frontend/test/spec/actions/recommendationActionTest.js`
* install gpcc: ![2](../Image/vmware/2.png)
* dlv path: `/workspace/gpcc_src/`
* go test with coverage: `go test -coverprofile coverage`, `go test --cover`
* go test to html: `go test -coverprofile=coverage.out; go tool cover -html=coverage.out; rm coverage.out`
  * then `cp xxx /workspace/gpcc_src/backend/tableinfo`
* run e2e on local
    `go test -mod=mod '-gcflags=all=-N -l' '-tags=GPDB5 VIP' -c -o e2e.test`
    `go test -mod=mod '-gcflags=all=-N -l' '-tags=GPDB6 VIP' -c -o e2e.test`
    `go test -mod=mod '-gcflags=all=-N -l' '-tags=GPDB7 VIP' -c -o e2e.test`
    `./e2e.test '-ginkgo.focus=VIP: Test accuracy2' -ginkgo.failFast -debug -pghost=127.0.0.1 -pgport=5432 -wshost=127.0.0.1 -wsport=28082 -skipInit=true`
    stop GPDB6 container: `docker kill $(docker ps -q)`
* docker start: `docker start $(docker ps -a -q)`
* run gpdb5 docker: `GPDB_VERSION=gpdb5 ./run.sh`
new vm:

* rerun: `r`
* if modify front-end: `cleanr`
* `go test` not work: `cc`, `cd build/dev`, `export GPCC_HOME=`pwd``
* if there is a change in database `make`, then `cc`, `r`
* cd `extension/metrics_collector`, `make clean`
* pg log location: `cd $MASTER_DATA_DIRECTORY/`

* diff in gpmetrics_dump.sql, need to modify: `tools/MS_script/gp6/gpcc_database_install-6.9.0.sh`

* setting gp:

    The `sysctl.conf` parameters listed in this topic are for performance, optimization, and consistency in a wide variety of environments. Change these settings according to your specific situation and setup.

    Set the parameters in the `/etc/sysctl.conf` file and reload with `sysctl -p`:

    ```

    # kernel.shmall = _PHYS_PAGES / 2 # See Shared Memory Pages
    kernel.shmall = 197951838
    # kernel.shmmax = kernel.shmall * PAGE_SIZE 
    kernel.shmmax = 810810728448
    kernel.shmmni = 4096
    vm.overcommit_memory = 2 # See Segment Host Memory
    vm.overcommit_ratio = 95 # See Segment Host Memory

    net.ipv4.ip_local_port_range = 10000 65535 # See Port Settings
    kernel.sem = 250 2048000 200 8192
    kernel.sysrq = 1
    kernel.core_uses_pid = 1
    kernel.msgmnb = 65536
    kernel.msgmax = 65536
    kernel.msgmni = 2048
    net.ipv4.tcp_syncookies = 1
    net.ipv4.conf.default.accept_source_route = 0
    net.ipv4.tcp_max_syn_backlog = 4096
    net.ipv4.conf.all.arp_filter = 1
    net.core.netdev_max_backlog = 10000
    net.core.rmem_max = 2097152
    net.core.wmem_max = 2097152
    vm.swappiness = 10
    vm.zone_reclaim_mode = 0
    vm.dirty_expire_centisecs = 500
    vm.dirty_writeback_centisecs = 100
    vm.dirty_background_ratio = 0 # See System Memory
    vm.dirty_ratio = 0
    vm.dirty_background_bytes = 1610612736
    vm.dirty_bytes = 4294967296
    ```
* restart docker:  `sudo systemctl restart docker`
* start all docker containers: `docker start $(docker ps -a -q)`
* jump to a specific machine in pipline: `fly -t gpcc hijack -u https://gpcc.ci.gpdb.pivotal.io/teams/main/pipelines/gpcc_pr/jobs/gpcc6/builds/520`
* install gpdb7 docker:

```shell
1. cd docker
2. docker pull gpccdocker/gpcc-gpdb-cluster-centos7:gpdb7
3. export GPDB_VERSION=gpdb7
4. source ./env.sh
5. clone gpdb7的github, 然后切到GPDB7分支, pwd拿到该git 仓库路径
6. cd docker/cli
7. GPDB_SRC=(4中的路径)  ./run.sh
```

* install go tools in vscode:
  * export GOPROXY=https://goproxy.cn,direct
  * gp-command-center git:(test-gp10-query) ✗ source ~/.profile

* build docker image:

```shell
1. `source ./env.sh`
2. `
```

* fly: `fly -t gpcc hijack -u xxx`

* gitproxy: `git config --global http.proxy http://proxy.vmware.com:3128/`
* upgrade go in docker `docker exec --privileged --user root gpcc-main chown -R "$(id -u):$(id -g)" /usr/local`, ` rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz`

* golps multiple packages, set in vscode:
```
"gopls": {
        "experimentalWorkspaceModule": true,
    }
```
