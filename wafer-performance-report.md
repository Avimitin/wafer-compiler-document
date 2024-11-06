新晶圆项目执行方式
=================

晶圆项目分两个路径，一个是总控制脚本的路径，一个是项目输出，程序的路径：
* 脚本执行时的路径，下面会用词 "RUN_DIR" 来表示这条路径：`/home/newdisk/kt/sowProject`
* 脚本的位置，下面会用词 "主控脚本" 来表示这个文件: `/home/newdisk/kt/sowProject/subject2_test/mainTest.py`
* 程序和其他文件的路径，下面会用 "BUILD_DIR" 来代表这条路径: `/home/newdisk/kt/sowProject/tests/sow_test_20241028_161849_subject2`

程序执行统一由 `mainTest.py` 来控制，脚本负责：
1. 生成晶圆配置
2. 编译样例程序
3. 调用 sst 模拟器执行程序


修改晶圆配置
-----------

在 `mainTest.py` 里，有如下几个变量控制最终生成的架构环境：
* `module_num`: 核组数量
* `k1`: CPU 负载比例，值域为 `[0, 1]`
* `k2`: GPU 负载比例，值域为 `[0, 1]`

k1 k2 之间约束条件为 `k1 + k2 == 1`，且有以下特殊情况：
* k1 = 1, k2 = 0 时，负载仅分配到 CPU 上
* k2 = 0, k1 = 1 时，负载仅分配到 GPU 上


修改编译文件
-----------
目前主控脚本 `mainTest.py` 会每次尝试从 `"BUILD_DIR"/ProjectSetting.json` 文件里读 `*ApplicationName` 数组里的值，
取第一位作为编译源文件路径，并从 `"BUILD_DIR"/applications/` 目录下寻找同名的文件夹。
比如默认设置里 `"compilerApplicationName"` 数组值是 `[ "app1" ]`，那么就会在 `"BUILD_DIR"/application/app1` 里搜索文件。
下面会用 "app1" 作为默认 app 名字。

编译源文件的控制由 `"BUILD_DIR"/application/app1` 里的 `args.json` 来控制编译源文件，`args.json` 是如下格式：

```json
{
  "source_file": "MD5Example.cpp",
  "compile_type": "crypto"
}
```


对主控脚本的修改
----------------
目前整个项目设计上也没有很好的支持课题二的开发流程，同时脚本操作逻辑不支持更换编译器路径或者执行文件路径。
在课题二的开发过程中，可能会需要随时修改编译器，产生的编译结果也大相径庭。同时还需要 gcc 编译 OpenSSL 去做性能对比。
因此目前最好的办法就是注释掉主控脚本里编译部分的代码，替换掉 "BUILD_DIR" 下面的 `kt_run_exe` 可执行文件，让脚本只调用 SST 仿真器而不调用任何编译器。

为了方便，目前的 `mainTest.py` 新增了一个判断逻辑，只有设置了环境变量 "RUN_COMPILER" 的时候才会调用脚本原来的编译方式。
默认将不让主控脚本跑编译。

同时，在课题二开发过程中会需要生成不同核组的配置用来做性能对比，因此课题二的 `mainTest.py` 也新增了一个判断逻辑，
如果设置了环境变量 `ARCHJSON_ONLY`，那么脚本会在生成出 `design.json` 后直接退出，不继续进行任何操作。


实际执行程序
------------
接下来以 `md5multi` 为例子，对整个项目开发流程做一个完整介绍：

* 生成必要的核组配置，如果当前的配置不需要改动，跳过这一步

```bash
cd /home/newdisk/kt/sowProject
ARCHJSON_ONLY=1 python3 subject2_test/mainTest.py
```

* 进入自己的编译器目录，此处我用的 `/home/newdisk/kt/wafer-md5-sm3-test/wafer-compiler`

```bash
pushd /home/newdisk/kt/wafer-md5-sm3-test/wafer-compiler
```

* 进入 md5multi 的样例文件夹，编译并复制可执行文件到运行目录

```bash
pushd example/md5multi

_RUN_DIR=/home/newdisk/kt/sowProject/tests/sow_test_20241028_161849_subject2
make DESIGN_JSON_FILE="$_RUN_DIR"/design.json
cp -f build/md5_multi "$_RUN_DIR"/kt_run_exe
cp -f build/wafer_gpu.out "$_RUN_DIR"/wafer_gpu.out

popd
```

* 返回运行目录，执行主控脚本

```bash
popd
python3 subject2_test/mainTest.py
```
