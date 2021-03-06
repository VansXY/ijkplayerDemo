# ijkplayerDemo

# 基于ijkplayer做的直播demo

废话不多说，如果大家不想通过以下方法制作framework，下面链接有现成的，由于GitHub上上传的文件不能大于100M，导致 Framework 上传不上来，需要的可以从下面链接取

> 链接:https://pan.baidu.com/s/1wJEGaACYHAEvzlpZmWnHEQ  
> 密码:tb7e

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

#### 1.获取 ffmpeg 并初始化
> ./init-ios.sh

#### 2.添加 https 支持
最后会生成支持 https 的静态文件 libcrypto.a 和 libssl.a, 如果不需要可以跳过这一步

```
# 获取 openssl 并初始化
./init-ios-openssl.sh

cd ios

# 在模块文件中添加一行配置 以启用 openssl 组件
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-openssl"' >> ../config/module.sh

```

#### 3.编译
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

#### 1.首先打开工程IJKMediaPlayer.xcodeproj, 位置如下图:

![image](https://upload-images.jianshu.io/upload_images/1803339-607cc84c212faf90.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700)

#### 2.添加 openssl 相关包以支持 https

![image](https://blog.wskfz.com/usr/uploads/2018/04/2087622254.png)

#### 3.打包 framwork
> 1.配置 Release 模式如果下图

![image](https://blog.wskfz.com/usr/uploads/2018/04/666544080.png)

![image](https://blog.wskfz.com/usr/uploads/2018/04/4092292338.png)

> 2. 配置模拟器 framework

![image](https://blog.wskfz.com/usr/uploads/2018/04/3861753393.png)

> 如图操作，然后 command+b 编译即可

![image](https://blog.wskfz.com/usr/uploads/2018/04/3830063398.png)

#### 4.合并 framework

![image](https://blog.wskfz.com/usr/uploads/2018/04/234251722.png)

> 准备合并:

打开终端, 先 cd 到 Products 目录下

然后执行: lipo -create 真机framework路径 模拟器framework路径 -output 合并的文件路径

```
lipo -create Release-iphoneos/IJKMediaFramework.framework/IJKMediaFramework Release-iphonesimulator/IJKMediaFramework.framework/IJKMediaFramework -output IJKMediaFramework

```
![image](https://blog.wskfz.com/usr/uploads/2018/04/1012295434.png)

![image](https://blog.wskfz.com/usr/uploads/2018/04/3198101866.png)



### 四、集成ijkplayer

#### 1.导入 framework

直接将 IJKMediaFramework.framework 拖入到工程中即可

注意记得勾选 Copy items if needed 和 对应的 target

#### 2.添加依赖库

![image](https://blog.wskfz.com/usr/uploads/2018/04/1293654705.png)

### 五、demo
添加ijkplayer头文件
```
#import <IJKMediaFramework/IJKMediaFramework.h>
```
编译无误，表示集成成功~


