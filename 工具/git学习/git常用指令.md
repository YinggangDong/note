# git常用指令

[toc]



## 1.git remote 远程分支管理

### 1.git remote 不带参数，列出已经存在的远程分支

```sh
$ git remote
origin
```

### 2.git remote -v | --verbose

列出详细信息，在每一个名字后面列出其远程url，此时， -v 选项(译注:此为 –verbose 的简写,取首字母),显示对应的克隆地址。

```sh
$ git remote -v
origin  https://github.com/YinggangDong/rabbitmq.git (fetch)
origin  https://github.com/YinggangDong/rabbitmq.git (push)
```

### 3.git remote add url 添加一个远程仓库

```sh
$ git remote add origin https://github.com/YinggangDong/Multiprocessor.git
```

### 4.解除本地项目和远程库的关联

```sh
git remote remove 远端仓库名称(origin)


dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git remote rm origin

```

### 5.延伸—github的push总是要求输入用户名密码

我们将github上的工程clone到本地后，修改完代码后想要push到github，但总时不时的会有提示输入用户名及密码。

**原因分析**

出现这种情况的原因是我们使用了http的方式clone代码到本地，相应的，也是使用http的方式将代码push到服务器。

通过 git remote -v 命令就可以看到自己连接github仓库的方式：

```sh
输入用户名密码失败导致的错误

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git push origin master
fatal: HttpRequestException encountered.
   ▒▒▒▒▒▒▒▒ʱ▒▒▒▒
fatal: HttpRequestException encountered.
   ▒▒▒▒▒▒▒▒ʱ▒▒▒▒
remote: Invalid username or password.
fatal: Authentication failed for 'https://github.com/YinggangDong/note.git/'

查看连接仓库的方式
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git remote -v
origin  https://github.com/YinggangDong/note.git (fetch)
origin  https://github.com/YinggangDong/note.git (push)


```

可以发现确实是通过https方式进行的连接。

**解决方案**

通过ssh方式连接github仓库就可以规避掉该问题。

通过本节的学习，就可以完成更换远程仓库连接。步骤如下：

1.移除远端地址

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git remote rm origin	
```

2.增加新的ssh方式的远端地址。

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git remote add origin git@github.com:YinggangDong/note.git
```

3.尝试push代码

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git push
fatal: The current branch master has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin master
```

会发现出现了问题，提示当前分支没有设置上传的远端分支，需要先进行远端分支的指定，才能够正常完成push操作。并且提示中还给了我们需要执行的命令：

```sh
git push --set-upstream origin master
```

其中，远程分支若不是master，可以进行修改，例如远程是个开发分支，名称为dev1.4，则将master修改为dev1.4即可，如下：

```sh
git push --set-upstream origin dev1.4
```

需要注意的是，该指定远端分支的指令会自动执行一次git push，也就是说执行完该指令后不需要再另外执行git push了，改动已经完成推送到远端的操作。

ps：这是已经在本地生成ssh文件并配置到github但依然要求输入用户名密码的情况下的解决方案，如果还没有做ssh的配置的话，请参考[GitHub如何配置SSH Key](https://blog.csdn.net/u013778905/article/details/83501204) 进行配置。

## 2.git branch 分支管理

### 分支是什么？

git 上的分支是什么，是 branch ，是用来区分开发阶段的常用方式。通常在成熟的生产级开发过程中，主干仅作为上线时的依据来使用，而不会作为开发的分支使用。

分支通常会以版本号来命名，来标识所属项目的开发进度，随着版本更迭，版本号不断变高的同时，分支数也不断增加。

当版本的开发任务完成，测试通过，最后一个bug被关闭的时候，当前版本分支上的所有修改会被合并至主干，这也就保证了每当面临上线的时刻，主干上的代码都会是最新的。

此时，就会从主干上打出标签。作为上线源代码的一个存档。

**分支就是开发过程中伴随开发者最长的一个产物，活跃在上迭代上线结束到本迭代预演环境验证完成前的每个阶段。**

### 1.查看当前分支列表

```sh
$ git branch
* dev0.1
  dev0.2
  dev0.3
  master
  
```

其中带“*”号标识的是当前分支。

### 2.分支创建

共两种方式，通过 git branch [分支名] 或者 git checkout -b [分支名] 来进行分支的新建

```sh
1.git branch [分支名]
$ git branch dev0.4

2.git checkout -b [分支名]
$ git checkout -b dev0.5
Switched to a new branch 'dev0.5'

```

### 3.分支的切换

通过 git checkout 进行分支的切换

```sh
git checkout [分支名]

$ git checkout dev0.2
Switched to branch 'dev0.2'
```

### 4.分支的删除

通过 git branch -d [分支名] 进行分支的删除

```sh
$ git branch -d dev0.5
Deleted branch dev0.5 (was c4085d0).
```

### 5.设置项目的默认pull 和 push的远程分支

通过 git branch --set-upstream-to 属性的设置，可以设置项目的默认pull和push的远程分支

```sh
$ git branch --set-upstream-to=origin/master master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

### 6.将分支推送至远程

通过 git push origin [branch] 可以将分支推送至远端的仓库，若不推送，则该分支是仅自己可见的，别人不可见。推送至远端后，所有人都可见。 

```sh
$ git push origin dev0.4
Total 0 (delta 0), reused 0 (delta 0)
remote:
remote: Create a pull request for 'dev0.4' on GitHub by visiting:
remote:      https://github.com/YinggangDong/security/pull/new/dev0.4
remote:
To https://github.com/YinggangDong/security.git
 * [new branch]      dev0.4 -> dev0.4

```

## 3.git tag 标签管理

### 标签是什么？

标签的概念在SVN盛行时就已经存在，通常是作为软件发布的一部分。能够记录项目的重要阶段，并且记录最近一次提交后的代码的快照。

### 1.查看标签

通过 git tag 命令可以查看当前项目的所有标签信息。

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag
sv1.0.1
v1.0
```

### 2.展示当前分支最近的tag

```sh
git describe --tags --abbrev=0
```



### 3.查看标签的详细信息

```sh
git tag -ln

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -ln
sv1.0.1         标签
sv1.0.2         v1.0版本第二次提测
v1.0            标签
```

默认 tag 是打在最近的一次 commit 上，如果需要指定 commit 打 tag

### 4.本地创建标签

通过命令 git tag <version-number> 可以创建一个本地标签，默认tag是打在最近一次的 commit 上

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag sv1.0.3

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag
sv1.0.1
sv1.0.2
sv1.0.3
v1.0

```

若要添加描述或者指定 commit 打 tag，则需要如下的命令：

```sh
$ git tag -a <version-number> -m "v1.0 发布(描述)" <commit-id>

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git log --oneline
0d1b579 (HEAD -> master, tag: sv1.0.3) 标签命令内容
8496ca4 git 标签内容
b7b23e2 标签创建
efc4c8e (tag: v1.0, tag: sv1.0.2, tag: sv1.0.1, origin/master, dev1.0.1) 标签
b17003d 补充内容
9f37cdb 增加github总是需要输入用户密码的解决方案
fda9789 commit和push命令
4eb97d7 增加springboot项目搭建的笔记
d775dbd 提交OSS的相关内容
91db4f5 git笔记上传
325516c style:git笔记提交
545c8f7 增加git命令记录内容
ae19407 增加git相关笔记内容
d8e1fde feat:git笔记提交
c7e8223 Merge branch 'master' of https://github.com/YinggangDong/note
55cc63b doc:修复文件夹名称
8e772df Update README.md
ff3d93e feat:增加加密相关笔记
e62627e style:统一文件命名
3b75e1a style:修改格式
385163d feat:命令模式部分内容修改
3e1d78b feat: Optional 的实际应用的内容
d120d2a Merge branch 'master' of https://github.com/YinggangDong/note

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -a sv1.0.4 -m "第四次提测标签" 9f37cdb

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag
sv1.0.1
sv1.0.2
sv1.0.3
sv1.0.4
v1.0

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -ln
sv1.0.1         标签
sv1.0.2         v1.0版本第二次提测
sv1.0.3         标签命令内容
sv1.0.4         第四次提测标签
v1.0            标签

```

### 5.推送标签到远程仓库

通过 git push origin [标签名] 能够将本地标签推送至远程仓库，如下：

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git push origin sv1.0.1
Total 0 (delta 0), reused 0 (delta 0)
To github.com:YinggangDong/note.git
 * [new tag]         sv1.0.1 -> sv1.0.1

```

若想将所有的标签都推送至远端，则通过 git push origin --tags 进行推送。

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git push origin --tags
Enumerating objects: 21, done.
Counting objects: 100% (21/21), done.
Delta compression using up to 4 threads
Compressing objects: 100% (16/16), done.
Writing objects: 100% (16/16), 2.00 KiB | 256.00 KiB/s, done.
Total 16 (delta 9), reused 0 (delta 0)
remote: Resolving deltas: 100% (9/9), completed with 4 local objects.
To github.com:YinggangDong/note.git
 * [new tag]         sv1.0.2 -> sv1.0.2
 * [new tag]         sv1.0.3 -> sv1.0.3
 * [new tag]         sv1.0.4 -> sv1.0.4
 * [new tag]         v1.0 -> v1.0

```

### 6.删除本地标签

通过 git tag -d <tag-name> 可以删除本地标签

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -a sv1.0.5 -m "测试本地删除"

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag
sv1.0.1
sv1.0.2
sv1.0.3
sv1.0.4
sv1.0.5
v1.0

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -d sv1.0.5
Deleted tag 'sv1.0.5' (was 1dc49ef)

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)

```

### 7.删除远程标签

通过 git push origin --delete tag <tagname> 可以删除远程的标签

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag
sv1.0.1
sv1.0.2
sv1.0.3
sv1.0.4
v1.0

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git push origin --delete tag sv1.0.4
To github.com:YinggangDong/note.git
 - [deleted]         sv1.0.4

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git tag -ln
sv1.0.1         标签
sv1.0.2         v1.0版本第二次提测
sv1.0.3         标签命令内容
sv1.0.4         第四次提测标签
v1.0            标签
```

可以发现本地的标签没有被删除，仅仅是远程标签被删除了，本地不受影响。

### 8.切回到某个标签

一般上线之前都会打 tag，就是为了防止上线后出现问题，方便快速回退到上一版本。下面的命令是回到某一标签下的状态：

```sh
git checkout -b branch_name tag_name

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记 (master)
$ git checkout -b dev1.0.2 sv1.0.4
Switched to a new branch 'dev1.0.2'
```

创建并捡出新的分支 dev1.0.2 。

### 9.查看远程标签

查看远程的标签列表。git pull 可以将远程的标签信息拉取到本地，所以该命令使用场景不多。

```
git ls-remote --tags origin
```

## 4.git pull 更新与合并

### 1.更新并合并当前分支的最新改动

要更新本地仓库的代码至本分支的最新，需要执行 git pull 命令。git pull 命令是 **获取（fetch）**并 **合并（merge）**远端的改动。

```sh
$ git pull
Already up to date.
```

### 2.合并其他分支改动至当前分支

想要将其他分支的改动拉取到当前分支时，可以通过 git merge 指令完成，git 会尝试自动合并改动，成功则如下显示：

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git checkout dev0.1
Switched to branch 'dev0.1'

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (dev0.1)
$ git merge master
Updating c4085d0..198706a
Fast-forward
 com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java | 1 +
 1 file changed, 1 insertion(+)
	
```

### 3.处理冲突

在团队合作开发中，1和2的操作并非每次都会成功，若存在两个或更多人编辑了同一段代码，就会出现**冲突（conflicts）**。这时候就需要手动合并这些冲突了。

如下模拟了2中出现冲突的情况。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git merge dev0.1
Auto-merging com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
CONFLICT (content): Merge conflict in com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
Automatic merge failed; fix conflicts and then commit the result.
```

提示自动合并过程发现DH.java文件中存在冲突，因此自动合并失败，需要修复冲突然后提交修复结果。

这时候，回到文件中就可以发现，冲突的地方出现了两个分支中的不同内容，分别是当前分支的 HEAD 版本和要合并过来的 dev0.1 分支对这段注释的修改内容。

```java
/**
 * DH:密钥交换协议/算法(Diffie-Hellman Key Exchange/Agreement Algorithm)
 *
 * @author Lee Xiang
 * @date 2020/10/21 13:36
<<<<<<< HEAD
 * master分支
=======
 * master分支  
>>>>>>> dev0.1
 **/
 public class DH {
 }
```

根据实际情况，进行该段内容的修复，我这里保留自己的最新改动，将 dev0.1 分支的改动拒绝掉。<font color='red'>实际开发过程中不能够如此粗暴的处理，而应该是根据实际情况合并不同的业务代码，保证所有的正确改动都被保留。</font>

合并完成后，需要通过 git add [文件名] 将合并结果add进去。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master|MERGING)
$ git add com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
```

然后在进行 git commit 提交合并结果，和普通的 commit 的区别是，不能够有文件名或者.出现。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master|MERGING)
$ git commit . -m "合并master和dev0.1"
fatal: cannot do a partial commit during a merge.

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master|MERGING)
$ git commit -m "合并master和dev0.1"
[master 7f03829] 合并master和dev0.1

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$
```

可以看到，如果加上“.”进行提交，会提示处于 merge 状态不能够进行这样的 commit ，去掉 “.”之后就可以正常commit ,可以看到 commit 成功后，master|后面的 MERGING 标识已经消失，代表本次合并已经完成。

### 4.预览差异

在合并之前，可以通过 git diff [源分支] [目标分支] 的命令查看两个分支的差异。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master|MERGING)
$ git diff dev0.1 master
diff --git a/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java b/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
index c0b1391..467ec3b 100644
--- a/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
+++ b/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
@@ -20,7 +20,7 @@ import java.util.Objects;
  *
  * @author Lee Xiang
  * @date 2020/10/21 13:36
- * master分支
+ * master分支
  **/
 public class DH {
     private static String src = "jdk security dh";
```



## 5.git commit 添加和提交

### 1.添加本地修改至暂存区

通过 git add [文件名] 或 git add * 可以将新增的文件添加到版本管理中来，

### 2.提交本地修改至本地仓库

通过 git commit [文件名或.（代表所有改动）] -m “提交说明内容” 进行修改的提交。

```sh
$ git commit . -m "feat:添加注释"
[master 556c9e4] feat:添加注释
 1 file changed, 1 insertion(+), 1 deletion(-)
```

如果不写 -m “提交说明内容”，会进入一个vim编辑器，可以在里面进行提交内容的填写，然后点击 esc 退出编辑模式，输入 i 进入编辑模式，退出编辑模式后，输入两个大写Z可以退出该vim编辑器，成功进行提交。

```SH
$ git commit .

此时会进入如下vim编辑器

feat:新增注释
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch master
# Your branch is ahead of 'origin/master' by 3 commits.
#   (use "git push" to publish your local commits)
#
# Changes to be committed:
#       modified:   com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
#
# Untracked files:
#       .idea/
#       security.iml
#       target/
#
~
~
~
~
~
~
F:/GitHub/security/.git/COMMIT_EDITMSG[+] [unix] (19:10 09/11/2020) 1,18-14 全部
-- 插入 --

退出编辑模式，双击大写Z，可以进行保存，保存后显示如下：

$ git commit .
[master 198706a] feat:新增注释
 1 file changed, 1 insertion(+), 1 deletion(-)

```

通过 git commit 命令，改动已经被提交到 HEAD中，但是还没有到远端仓库中。



## 6.git push 推送

改动已经通过 git commit 命令完成了提交，被提交到了本地的 HEAD中，接下来就是向远端进行提交了，所谓的远端，就是我们通常所说的 git 仓库，它可以是公司在服务器上搭建的私有 gitlib ，可以是 github ，也可以是 gitee，所谓远端，就是和自己的本地仓库向对应，它可能在任何地方，但通常不在自己的电脑上。

### 1.推送至远端

可以通过 git push origin [远端接收分支] 的命令进行该推送过程，命令形如：

```sh
git push origin master 
```

可以将 master 修改为 任意分支名称，推送至远端的不同分支。



## 7.git log日志

通过 git log 指令可以看到 git 的提交记录，如果运行 git log，可以看到如下输出

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git log
commit 7f038293b43e6f78638b387a053148decffe0259 (HEAD -> master)
Merge: 06345fd 9d0f8d3
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:34:25 2020 +0800

    合并master和dev0.1

commit 06345fd0e70cf9678b442113d3bd354841aa17f1
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:17:14 2020 +0800

    格式化代码

commit 9d0f8d37cca55bbd3432465a97040cd0501ee2f3 (dev0.1)
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:15:27 2020 +0800

    增加注释

commit 198706ad8c392df8c547d70b0c55a445a9789447
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:10:11 2020 +0800
```

默认不用任何参数的话，git log 会按提交时间列出所有的更新，最近的更新排在最上面。看到了吗，每次更新都有一个 SHA-1 校验和、作者的名字和电子邮件地址、提交时间，最后缩进一个段落显示提交说明。

### 1.通过 -p 查看每次提交的内容差异

我们常用 -p 选项展开显示每次提交的内容差异：

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
git log -p
commit 7f038293b43e6f78638b387a053148decffe0259 (HEAD -> master)
Merge: 06345fd 9d0f8d3
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:34:25 2020 +0800

    合并master和dev0.1

commit 06345fd0e70cf9678b442113d3bd354841aa17f1
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:17:14 2020 +0800

    格式化代码

diff --git a/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java b/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
index a237719..467ec3b 100644
--- a/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
+++ b/com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java
@@ -20,7 +20,7 @@ import java.util.Objects;
  *
  * @author Lee Xiang
  * @date 2020/10/21 13:36
- * master分支

```

### 2.用 -1 则只显示最近一次更新

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git log -1
commit 7f038293b43e6f78638b387a053148decffe0259 (HEAD -> master, origin/master)
Merge: 06345fd 9d0f8d3
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:34:25 2020 +0800

    合并master和dev0.1
	
```

### 3.用 --stat仅显示简要的修改行数统计

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git log --stat
commit 7f038293b43e6f78638b387a053148decffe0259 (HEAD -> master, origin/master)
Merge: 06345fd 9d0f8d3
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:34:25 2020 +0800

    合并master和dev0.1

commit 06345fd0e70cf9678b442113d3bd354841aa17f1
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:17:14 2020 +0800

    格式化代码

 com/snbc/java/asymmetricEncryptionAlgorithm/DH/DH.java | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 9d0f8d37cca55bbd3432465a97040cd0501ee2f3 (dev0.1)
Author: YinggangDong <believerD@aliyun.com>
Date:   Mon Nov 9 19:15:27 2020 +0800

```

### 4.--pretty用来设置不同于默认格式的方式

还有个常用的 –pretty 选项，可以指定使用完全不同于默认格式的方式展示提交历史。比如用 oneline 将每个提交放在一行显示，这在提交数很大时非常有用。另外还有 short(隐藏时间)，full（含author信息和commit信息，多了个commit信息，少了个Date信息） 和 fuller（有author、authorDate、commit、commitDate） 可以用，展示的信息或多或少有些不同，请自己动手实践一下看看效果如何。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git log --pretty=oneline
7f038293b43e6f78638b387a053148decffe0259 (HEAD -> master, origin/master) 合并master和dev0.1
06345fd0e70cf9678b442113d3bd354841aa17f1 格式化代码
9d0f8d37cca55bbd3432465a97040cd0501ee2f3 (dev0.1) 增加注释
198706ad8c392df8c547d70b0c55a445a9789447 feat:新增注释
e1d033f757c2570e4094648317df9faa3c7bf058 feat:增加注释
556c9e46b8c01ad0f45ef951e3f67219ffdb18c4 feat:添加注释
28c6e98d56a092ab01b9592f289ddfff887e4426 style:增加master分支标记
c4085d04fdbb1f9f912a6a372fe032a667f3bc40 (origin/dev0.4, origin/dev0.1, dev0.4, dev0.3, dev0.2) style:格式化代码
b9b0c3a1039c61df32f1db5b4a712153db706c45 style:修改格式
760e0ce3718b45b1ff93df525dfa0ede1d7173aa style:修改格式
d2e59d8316c8192f695b17bf1eaca104686a1812 style:修改格式
e787f139cd1bb5de21081fc4d995f10b10c15a7f style:修改格式
01ce025cfb697a21dc35caf15c669627a1061a6d feat:增加忽略文件等
2b6f91d20ba3284562e378b1d0b8516eb803fcb3 feat:项目初始化

```

还有一种比较特别的模式是format，可以定制要显示的记录格式，这样的输出便于后期编程提取分析,命令形如 

```sh
$ git log --pretty=format:"%h - %an, %ar : %s"	
```

效果如下：

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/security (master)
$ git log --pretty=format:"%h - %an, %ar : %s"
7f03829 - YinggangDong, 13 hours ago : 合并master和dev0.1
06345fd - YinggangDong, 13 hours ago : 格式化代码
9d0f8d3 - YinggangDong, 13 hours ago : 增加注释
198706a - YinggangDong, 13 hours ago : feat:新增注释
e1d033f - YinggangDong, 13 hours ago : feat:增加注释
556c9e4 - YinggangDong, 14 hours ago : feat:添加注释
28c6e98 - YinggangDong, 14 hours ago : style:增加master分支标记
c4085d0 - YinggangDong, 14 hours ago : style:格式化代码
b9b0c3a - YinggangDong, 14 hours ago : style:修改格式
760e0ce - YinggangDong, 14 hours ago : style:修改格式
d2e59d8 - YinggangDong, 14 hours ago : style:修改格式
e787f13 - YinggangDong, 14 hours ago : style:修改格式
01ce025 - YinggangDong, 3 days ago : feat:增加忽略文件等
2b6f91d - YinggangDong, 3 days ago : feat:项目初始化
```

下面列出了常用的格式占位符写法及其代表的意义。

```sh
%H  提交对象（commit）的完整哈希字串
%h  提交对象的简短哈希字串
%T  树对象（tree）的完整哈希字串
%t  树对象的简短哈希字串
%P  父对象（parent）的完整哈希字串
%p  父对象的简短哈希字串
%an 作者（author）的名字
%ae 作者的电子邮件地址
%ad 作者修订日期（可以用 -date= 选项定制格式）
%ar 作者修订日期，按多久以前的方式显示
%cn 提交者(committer)的名字
%ce 提交者的电子邮件地址
%cd 提交日期
%cr 提交日期，按多久以前的方式显示
%s  提交说明
```

你一定奇怪*作者（author）*和*提交者（committer）*之间究竟有何差别，其实作者指的是实际作出修改的人，提交者指的是最后将此工作成果提交到仓库的人。所以，当你为某个项目发布补丁，然后某个核心成员将你的补丁并入项目时，你就是作者，而那个核心成员就是提交者。

列出了一些其他常用的选项及其释义。以下是

```
-p  按补丁格式显示每个更新之间的差异。
--stat  显示每次更新的文件修改统计信息。
--shortstat 只显示 --stat 中最后的行数修改添加移除统计。
--name-only 仅在提交信息后显示已修改的文件清单。
--name-status   显示新增、修改、删除的文件清单。
--abbrev-commit 仅显示 SHA-1 的前几个字符，而非所有的 40 个字符。
--relative-date 使用较短的相对时间显示（比如，“2 weeks ago”）。
--graph 显示 ASCII 图形表示的分支合并历史。
--pretty    使用其他格式显示历史提交信息。可用的选项包括 oneline，short，full，fuller 和 format（后跟指定格式）。
```

### 5.限制输出长度

除了定制输出格式的选项之外，git log 还有许多非常实用的限制输出长度的选项，也就是只输出部分提交信息。之前我们已经看到过 -2 了，它只显示最近的两条提交，实际上，这是 - 选项的写法，其中的 n 可以是任何自然数，表示仅显示最近的若干条提交。不过实践中我们是不太用这个选项的，Git 在输出所有提交时会自动调用分页程序（less），要看更早的更新只需翻到下页即可。

另外还有按照时间作限制的选项，比如 –since 和 –until。下面的命令列出所有最近两周内的提交：

```sh
$ git log --since=2.weeks
```

你可以给出各种时间格式，比如说具体的某一天（“2008-01-15”），或者是多久以前（“2 years 1 day 3 minutes ago”）。

还可以给出若干搜索条件，列出符合的提交。用 –author 选项显示指定作者的提交，用 –grep 选项搜索提交说明中的关键字。（请注意，如果要得到同时满足这两个选项搜索条件的提交，就必须用 –all-match 选项。否则，满足任意一个条件的提交都会被匹配出来）

另一个真正实用的git log选项是路径(path)，如果只关心某些文件或者目录的历史提交，可以在 git log 选项的最后指定它们的路径。因为是放在最后位置上的选项，所以用两个短划线（–）隔开之前的选项和后面限定的路径名。

下面还列出了其他常用的类似选项。

```
-(n)    仅显示最近的 n 条提交
--since, --after    仅显示指定时间之后的提交。
--until, --before   仅显示指定时间之前的提交。
--author    仅显示指定作者相关的提交。
--committer 仅显示指定提交者相关的提交。
```

来看一个实际的例子，如果要查看 Git 仓库中，2008 年 10 月期间，Junio Hamano 提交的但未合并的测试脚本（位于项目的 t/ 目录下的文件），可以用下面的查询命令：

```sh
$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
   --before="2008-11-01" --no-merges -- t/
5610e3b - Fix testcase failure when extended attribute
acd3b9e - Enhance hold_lock_file_for_{update,append}()
f563754 - demonstrate breakage of detached checkout wi
d1a43f2 - reset --hard/read-tree --reset -u: remove un
51a94af - Fix "checkout --track -b newbranch" on detac
b0ad11e - pull: allow "git pull origin $something:$cur"
```

Git 项目有 20,000 多条提交，但我们给出搜索选项后，仅列出了其中满足条件的 6 条。



## 8.git stash 隐藏改动

git 提供了隐藏当前改动和恢复的功能。该功能通常用于不能够将本地修改 commit ，但又需要修改部分内容并且提交的情形。

例如，当前处于开发周期中，已经有本迭代的部分代码进行了编写，但此时突然接到了线上 bug 的反馈，该 bug 需要在 2 小时内完成修复。既然接到了该 bug 的修复任务，那么理所当然的会想到通过创建一个修复分支来进行修复，但是，当前正在开发的内容还没到能够提交的时候，距离当前开发周期结束还有几天，不能够进行提交。

这时，stash 功能就派上了用场。可以将当前的开发内容隐藏起来，等到解决完 bug 后再恢复改动。

参见[Bug分支-廖雪峰](https://www.liaoxuefeng.com/wiki/896043488029600/900388704535136)

### 1.隐藏改动

通过 git stach 可以隐藏当前本地的所有改动，实例如下：

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git stash
Saved working directory and index state WIP on master: acbc4e4 git隐藏功能

```

### 2.将隐藏的改动恢复

隐藏的改动有两种恢复方案，

一是用`git stash apply`恢复，但是恢复后，stash内容并不删除，你需要用`git stash drop`来删除；

恢复

```sh

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash apply
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   main/java/cn/dyg/optional/OptionalDemo.java

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        ../.idea/
        ../java8.iml
        ../target/


```

删除

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash list
stash@{0}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null
stash@{1}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null
stash@{2}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash drop
Dropped refs/stash@{0} (8a738cd01b5adcc00ed3f096535740e245b00fe5)

dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash list
stash@{0}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null
stash@{1}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null

```



另一种方式是用`git stash pop`，恢复的同时把stash内容也删了：

```sh
回到最后一个 stash 的状态，并删除这个 stash
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git stash pop
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   "git\347\254\224\350\256\260.md"

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (07dd71e48e2e21e2f1ccce32f02ba4165784b556)

```

若是存在多次 stash ,可以通过指定 stash 名称的形式完成，通过 git stash list 查看并恢复指定的 stash 。

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash pop stash@{1}
Auto-merging src/main/java/cn/dyg/optional/OptionalDemo.java
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   main/java/cn/dyg/optional/OptionalDemo.java

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        ../.idea/
        ../java8.iml
        ../target/

no changes added to commit (use "git add" and/or "git commit -a")
Dropped stash@{1} (7aee6ece7eeab4afa667f5d4656d51a02a85c168)

```



### 3.查看隐藏的list

通过 git stash list 可以查看所有的隐藏内容

```sh
dongyinggang@YF-dongyinggang MINGW64 /f/GitHub/java8/src (master)
$ git stash list
stash@{0}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null
stash@{1}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null
stash@{2}: WIP on master: 2790288 feat:增加Optional类的ifPresent和filter方法的配合进行判空且判null

```



## 9.git status 工作区状态

通过 git status 可以查看当前工作区的状态，可以看到是否存在未提交的修改，未推送的修改等信息。

### 1.存在未提交内容

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   "git\347\254\224\350\256\260.md"

no changes added to commit (use "git add" and/or "git commit -a")
```

### 2.存在未推送内容

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git commit . -m "stash场景"
[master 770e431] stash场景
 1 file changed, 7 insertions(+), 1 deletion(-)

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
```

### 3.无改动

```sh
dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git push
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 865 bytes | 96.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To github.com:YinggangDong/note.git
   1e74dc2..770e431  master -> master

dongyinggang@YF-dongyinggang MINGW64 ~/Desktop/学习笔记/git学习 (master)
$ git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

## git cherry-pick 挑拣合成

当需要将某个分支的部分 commit 应用到主干或其他分支时，git cherry-pick 可以实现该功能。

实际业务场景：

某次上线后，发现存在线上问题需要进行紧急修复，由于开发分支是一个持续分支，不是每次都重新从主干拉取，因此直接在上面进行了bug的修复，提交后，发现有同事在上线完成后，commit 了部分代码，导致开发分支出现了部分不希望上线的代码。

因此，需要从上线版本的 commit 拉取一个新的 bug 修复分支，拉取后，仅将 bug 修复的相关 commit 应用到该分支上，然后在各分支上进行标签的创建。

### 一、基本用法

`git cherry-pick`命令的作用，就是将指定的提交（commit）应用于其他分支。

```bash
$ git cherry-pick <commitHash>
```

上面命令就会将指定的提交`commitHash`，应用于当前分支。这会在当前分支产生一个新的提交，当然它们的哈希值会不一样。

举例来说，代码仓库有`master`和`feature`两个分支。

```bash
a - b - c - d   Master
         \
           e - f - g Feature
```

现在将提交`f`应用到`master`分支。

```bash
# 切换到 master 分支
$ git checkout master

# Cherry pick 操作
$ git cherry-pick f
```

上面的操作完成以后，代码库就变成了下面的样子。

```bash
a - b - c - d - f   Master
         \
           e - f - g Feature
```

从上面可以看到，`master`分支的末尾增加了一个提交`f`。

`git cherry-pick`命令的参数，不一定是提交的哈希值，分支名也是可以的，表示转移该分支的最新提交。

```bash
$ git cherry-pick feature
```

上面代码表示将`feature`分支的最近一次提交，转移到当前分支。

### 二、转移多个提交

Cherry pick 支持一次转移多个提交。

> ```bash
> $ git cherry-pick <HashA> <HashB>
> ```

上面的命令将 A 和 B 两个提交应用到当前分支。这会在当前分支生成两个对应的新提交。

如果想要转移一系列的连续提交，可以使用下面的简便语法。

> ```bash
> $ git cherry-pick A..B 
> ```

上面的命令可以转移从 A 到 B 的所有提交。它们必须按照正确的顺序放置：提交 A 必须早于提交 B，否则命令将失败，但不会报错。

注意，使用上面的命令，提交 A 将不会包含在 Cherry pick 中。如果要包含提交 A，可以使用下面的语法。

> ```bash
> $ git cherry-pick A^..B 
> ```

## 参考内容

【1】[git - 简明指南](http://rogerdudler.github.io/git-guide/index.zh.html)

【2】 [你知道如何查看git的log吗？](https://blog.csdn.net/lshemail/article/details/51787250)

【3】 [IDEA 设置项目的默认pull 和 push的远程分支](https://blog.csdn.net/sgl520lxl/article/details/88425324)

【4】[解决git push代码到github上一直提示输入用户名及密码的问题](https://blog.csdn.net/yychuyu/article/details/80186783)

【5】[Bug分支-廖雪峰](https://www.liaoxuefeng.com/wiki/896043488029600/900388704535136)

【6】[git可视化操作](https://oschina.gitee.io/learn-git-branching/)