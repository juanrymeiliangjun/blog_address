# Git 使用

### git 命令

#### git merge

#### git cherry-pick [commit-id]

#### git rebase --onto [branch-name] [from-commit-id] ~[to-commit-id]

> "git-rebase: Forward-port local commits to the updated upstream head - git doc"


【参考】[Git分支-变基](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%8F%98%E5%9F%BA)

#### git rev-parse

#### git submodule

##### git submodule init
##### git submodule update
**git submodule update --remote --merge**

**git push --recurse-submodules=on-demand**

**git push --recurse-submodules=check**

**git checkout --recurse-submodules master**


## git fork 代码工程和远程同步

__fork代码后，可以合并对应分支的代码，如果是原工程中添加的新分支，则可以checkout [new-branch-name] 然后再推送到自己的空间内(fork 的工程中)__

1. 查看fork项目的远程工程源
```
➜  senselink-platform git:(master) git remote -v
origin  git@gitlab.sz.sensetime.com:xuzhaohu/senselink-platform.git (fetch)
origin  git@gitlab.sz.sensetime.com:xuzhaohu/senselink-platform.git (push)
```
2. 如果远程工程源没有对应的fork工程原地址，则添加远程工程源
```
➜  senselink-platform git:(master) git remote add upstream git@gitlab.sz.sensetime.com:aiot/senselink-platform.git
➜  senselink-platform git:(master) git remote -v
origin  git@gitlab.sz.sensetime.com:xuzhaohu/senselink-platform.git (fetch)
origin  git@gitlab.sz.sensetime.com:xuzhaohu/senselink-platform.git (push)
upstream    git@gitlab.sz.sensetime.com:aiot/senselink-platform.git (fetch)
upstream    git@gitlab.sz.sensetime.com:aiot/senselink-platform.git (push)
```
3. 拉取远程工程源
```
➜  senselink-platform git:(master) git fetch upstream
remote: Enumerating objects: 13742, done.
remote: Counting objects: 100% (13742/13742), done.
remote: Compressing objects: 100% (3761/3761), done.
remote: Total 13742 (delta 5859), reused 13262 (delta 5435)
Receiving objects: 100% (13742/13742), 1.68 MiB | 8.44 MiB/s, done.
Resolving deltas: 100% (5859/5859), completed with 219 local objects.
From gitlab.sz.sensetime.com:aiot/senselink-platform
 * [new branch]        master               -> upstream/master
 * [new branch]        senselink-dev        -> upstream/senselink-dev
 * [new branch]        senselink-huarun     -> upstream/senselink-huarun
 * [new branch]        senselink-v2.2.0-dev -> upstream/senselink-v2.2.0-d
```
4. 合并远程工程源
```
➜  senselink-platform git:(master) git merge upstream/master
Updating 8540a187..c2a91b29
Fast-forward
 pom.xml                                            |  141 +-
 sl-discovery/pom.xml                               |  147 ++
 .../bi/discovery/DiscoveryApplication.java         |   15 +
 .../com/sensetime/bi/discovery/common/Code.java    |  124 +
 .../sensetime/bi/discovery/common/Constants.java   |   16 +
 .../sensetime/bi/discovery/config/CorsConfig.java  |   26 +
 .../sensetime/bi/discovery/config/DubboConfig.java |    9 +
 .../bi/discovery/config/JacksonConfig.java         |  204 ++
 .../sensetime/bi/discovery/config/MvcConfig.java   |   27 +
 .../sensetime/bi/discovery/config/RedisConfig.java |  122 +
```
5. 将远程工程源推送到fork分支
```
➜  senselink-platform git:(master) git push
Enumerating objects: 11063, done.
Counting objects: 100% (10762/10762), done.
Delta compression using up to 4 threads
Compressing objects: 100% (2818/2818), done.
Writing objects: 100% (10415/10415), 1.32 MiB | 22.50 MiB/s, done.
Total 10415 (delta 4612), reused 9959 (delta 4260)
remote: Resolving deltas: 100% (4612/4612), completed with 164 local objects.
To gitlab.sz.sensetime.com:xuzhaohu/senselink-platform.git
   8540a187..c2a91b29  master -> master
```