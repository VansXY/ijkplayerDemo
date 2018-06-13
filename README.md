# ijkplayerDemo

# 基于ijkplayer做的直播demo

### 一、下载ijkplayer

在一个合适的位置新建一个文件夹, 假设为桌面, 文件夹名为 **ijkplayer**

```
# 进入到刚刚新建的文件夹内
cd ~/Desktop/ijkplayer/

# 获取ijkplayer源码
git clone https://github.com/Bilibili/ijkplayer.git ijkplayer-ios

# 进入源码目录
cd ijkplayer-ios

```

> 目录结构：

![image](https://upload-images.jianshu.io/upload_images/1803339-c3b8f8bcae855612.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/430)

### 二、编译 ijkplayer

#### 获取 ffmpeg 并初始化
> ./init-ios.sh

#### 添加 https 支持
最后会生成支持 https 的静态文件 libcrypto.a 和 libssl.a, 如果不需要可以跳过这一步

```
# 获取 openssl 并初始化
./init-ios-openssl.sh

cd ios

# 在模块文件中添加一行配置 以启用 openssl 组件
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-openssl"' >> ../config/module.sh

```

#### 编译
```
./compile-ffmpeg.sh clean

# 编译openssl, 如果不需要https可以跳过这一步
./compile-openssl.sh all

# 编译ffmpeg
./compile-ffmpeg.sh all
```

**如果提示错误:**

```
./libavutil/arm/asm.S:50:9: error: unknown directive
        .arch armv7-a
        ^
make: *** [libavcodec/arm/aacpsdsp_neon.o] Error 1
```

> 报错原因是因为xcode对32位的支持弱化了，可以在compile-ffmpeg.sh里面删除**armv7**
FF_ALL_ARCHS_IOS8_SDK="arm64 i386 x86_64"

> 再次执行
./compile-ffmpeg.sh all

### 三、打包IJKMediaFramework.framework框架

### 四、集成ijkplayer
