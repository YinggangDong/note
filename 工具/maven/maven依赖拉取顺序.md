# [Maven 项目中依赖的搜索顺序](https://my.oschina.net/polly/blog/2120650)

网上有很多关于maven项目中mirror、profile、repository的搜索顺序的文章，说法不一。官方文档并没有找到相关的说明，鉴于此，我抽时间做了一个验证。

## 依赖仓库的配置方式

maven项目使用的仓库一共有如下几种方式：

1. 中央仓库，这是默认的仓库
2. 镜像仓库，通过 sttings.xml 中的 settings.mirrors.mirror 配置
3. 全局profile仓库，通过 settings.xml 中的 settings.repositories.repository 配置
4. 项目仓库，通过 pom.xml 中的 project.repositories.repository 配置
5. 项目profile仓库，通过 pom.xml 中的 project.profiles.profile.repositories.repository 配置
6. 本地仓库

如果所有配置都存在，依赖的搜索顺序就会变得异常复杂。

## 分析依赖搜索顺序

先从最简单开始，慢慢增加配置，查看有什么变化。

### 准备测试环境

安装jdk、maven。

使用如下命令创建测试项目：

```
yes | mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-webapp  -DinteractiveMode=true -DgroupId=com.pollyduan -DartifactId=myweb -Dversion=1.0 -Dpackage=com.pollyduan
```

创建完成后，为了避免后续测试干扰，先执行一次compile。

```
cd myweb
mvn compile
```

最后，修改 pom.xml 文件，将 junit版本号改为 4.12 。我们要使用这个jar来测试依赖的搜索顺序。

### 默认情况

首先确保junit4.12不存在：

```
rm -rf ~/.m2/repository/junit/junit/4.12
```

默认情况下没有配置任何仓库，也就是说，既没改 $M2_HOME/conf/settings.xml 也没有添加 ~/.m2/settings.xml

执行编译，查看日志中拉取junit的仓库。

```
mvn compile

...
Downloaded from central: https://repo.maven.apache.org/maven2/junit/junit/4.12/junit-4.12.pom (24 kB at 11 kB/s)
```

- 可以看出，默认是从 central 中央仓库拉取的jar.

### 配置镜像仓库 settings_mirror

创建 ~/.m2/setttings.xml ，内容如下：

```xml
<settings>
  <mirrors>
    <mirror>
      <id>settings_mirror</id>
      <url>https://maven.aliyun.com/repository/public</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```

重新测试：

```
rm -rf ~/.m2/repository/junit/junit/4.12
mvn compile
```

在日志中查看下载依赖的仓库：

```
Downloaded from settings_mirror: https://maven.aliyun.com/repository/public/junit/junit/4.12/junit-4.12.pom (24 kB at 35 kB/s)
```

- 可以看出，是从 settings_mirror 中下载的jar
- 结论：settings_mirror 的优先级高于 central

### 配置pom中的仓库 pom_repositories

在 project 中增加如下配置：

```xml
<repositories>
  <repository>
    <id>pom_repositories</id>
    <name>local</name>
    <url>http://10.18.29.128/nexus/content/groups/public/</url>
    <releases>
      <enabled>true</enabled>
    </releases>
    <snapshots>
      <enabled>true</enabled>
    </snapshots>
  </repository>
</repositories>
```

- 由于我们改变了id的名字，所以仓库地址无所谓，使用相同的地址也不影响测试。

执行测试：

```
rm -rf ~/.m2/repository/junit/junit/4.12
mvn compile
```

在日志中查看下载依赖的仓库：

```
Downloaded from pom_repositories: http://10.18.29.128/nexus/content/groups/public/junit/junit/4.12/junit-4.12.pom (24 kB at 95 kB/s)
```

从显示的仓库id可以看出：

- jar 是从 pom_repositories 中下载的。
- pom_repositories 优先级高于 settings_mirror

### 配置全局profile仓库 settings_profile_repo

在 ~/.m2/settings.xml 中 settings 的节点内增加：

```xml
<profiles>
  <profile>
  <id>s_profile</id>
  <repositories>
    <repository>
      <id>settings_profile_repo</id>
      <name>netease</name>
      <url>http://mirrors.163.com/maven/repository/maven-public/</url>
      <releases>
        <enabled>true</enabled>
      </releases>
      <snapshots>
        <enabled>true</enabled>
      </snapshots>
    </repository>
  </repositories>
  </profile>
</profiles>
```

执行测试：

```
rm -rf ~/.m2/repository/junit/junit/4.12
mvn compile -Ps_profile
```

在日志中查看下载依赖的仓库：

```
Downloaded from settings_profile_repo: http://mirrors.163.com/maven/repository/maven-public/junit/junit/4.12/junit-4.12.pom (24 kB at 63 kB/s)
```

从显示的仓库id可以看出：

- jar 是从 settings_profile_repo 中下载的。
- settings_profile_repo 优先级高于 settings_mirror。
- settings_profile_repo 优先级高于 pom_repositories 。

### 配置项目profile仓库 pom_profile_repo

```xml
<profiles>
  <profile>
    <id>p_profile</id>
    <repositories>
      <repository>
        <id>pom_profile_repo</id>
        <name>local</name>
        <url>http://10.18.29.128/nexus/content/groups/public/</url>
        <releases>
          <enabled>true</enabled>
        </releases>
        <snapshots>
          <enabled>true</enabled>
        </snapshots>
      </repository>
    </repositories>
  </profile>
</profiles>
```

执行测试：

```
rm -rf ~/.m2/repository/junit/junit/4.12
mvn compile -Ps_profile,p_profile
mvn compile -Pp_profile,s_profile
```

在日志中查看下载依赖的仓库：

```
Downloaded from settings_profile_repo: http://mirrors.163.com/maven/repository/maven-public/junit/junit/4.12/junit-4.12.pom (24 kB at 68 kB/s)
```

从显示的仓库id可以看出：

- jar 是从 settings_profile_repo 中下载的
- settings_profile_repo 优先级高于 pom_profile_repo

进一步测试：

```
rm -rf ~/.m2/repository/junit/junit/4.12
mvn compile -Pp_profile
```

在日志中查看下载依赖的仓库：

```
Downloaded from pom_profile_repo: http://10.18.29.128/nexus/content/groups/public/junit/junit/4.12/junit-4.12.pom (24 kB at 106 kB/s)
```

从显示的仓库id可以看出：

- jar 是从 settings_profile_repo 中下载的
- pom_profile_repo 优先级高于 pom_repositories

### 最后确认 local_repo 本地仓库 ~/.m2/repository

这不算测试了，只是一个结论，可以任意测试。

- 只要 `~/.m2/repository` 中包含依赖，无论怎么配置，都会优先使用local本地仓库中的jar.

### 最终结论

- settings_mirror 的优先级高于 central
- settings_profile_repo 优先级高于 settings_mirror
- settings_profile_repo 优先级高于 pom_repositories
- settings_profile_repo 优先级高于 pom_profile_repo
- pom_profile_repo 优先级高于 pom_repositories
- pom_repositories 优先级高于 settings_mirror

通过上面的比较得出完整的搜索链：

local_repo > settings_profile_repo > pom_profile_repo > pom_repositories > settings_mirror > central



