# XiaoMusic: 无限听歌，解放小爱音箱

使用小爱音箱播放音乐，音乐使用 yt-dlp 下载。

<https://github.com/hanxi/xiaomusic>

文档: <https://xdocs.hanxi.cc/>

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/XiaoMusic.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

> [!TIP]
> 初次安装遇到问题请查阅 [💬 FAQ问题集合](https://github.com/hanxi/xiaomusic/issues/99) ，一般遇到的问题都已经有解决办法。

### 🤐 支持语音口令

- 【播放歌曲】，播放本地的歌曲
- 【播放歌曲+歌名】，比如：播放歌曲周杰伦晴天
- 【上一首】
- 【下一首】
- 【单曲循环】
- 【全部循环】
- 【随机播放】
- 【关机】，【停止播放】，两个效果是一样的。
- 【刷新列表】，当复制了歌曲进 music 目录后，可以用这个口令刷新歌单。
- 【播放列表+列表名】，比如：播放列表其他。
- 【加入收藏】，把当前播放的歌曲加入收藏歌单。
- 【取消收藏】，把当前播放的歌曲从收藏歌单里移除。
- 【播放列表收藏】，这个用于播放收藏歌单。
- 【播放本地歌曲+歌名】，这个口令和播放歌曲的区别是本地找不到也不会去下载。
- 【播放列表第几个+列表名】，具体见： <https://github.com/hanxi/xiaomusic/issues/158>
- 【搜索播放+关键词】，会搜索关键词作为临时搜索列表播放，比如说【搜索播放林俊杰】，会播放所有林俊杰的歌。
- 【本地搜索播放+关键词】，跟搜索播放的区别是本地找不到也不会去下载。

> [!TIP]
> 隐藏玩法: 对小爱同学说播放歌曲小猪佩奇的故事，会先下载小猪佩奇的故事，然后再播放小猪佩奇的故事。

## 🛠️ pip 方式安装运行

```shell
> pip install -U xiaomusic
> xiaomusic --help
 __  __  _                   __  __                 _
 \ \/ / (_)   __ _    ___   |  \/  |  _   _   ___  (_)   ___
  \  /  | |  / _` |  / _ \  | |\/| | | | | | / __| | |  / __|
  /  \  | | | (_| | | (_) | | |  | | | |_| | \__ \ | | | (__
 /_/\_\ |_|  \__,_|  \___/  |_|  |_|  \__,_| |___/ |_|  \___|
          XiaoMusic v0.3.69 by: github.com/hanxi

usage: xiaomusic [-h] [--port PORT] [--hardware HARDWARE] [--account ACCOUNT]
                 [--password PASSWORD] [--cookie COOKIE] [--verbose]
                 [--config CONFIG] [--ffmpeg_location FFMPEG_LOCATION]

options:
  -h, --help            show this help message and exit
  --port PORT           监听端口
  --hardware HARDWARE   小爱音箱型号
  --account ACCOUNT     xiaomi account
  --password PASSWORD   xiaomi password
  --cookie COOKIE       xiaomi cookie
  --verbose             show info
  --config CONFIG       config file path
  --ffmpeg_location FFMPEG_LOCATION
                        ffmpeg bin path
> xiaomusic --config config.json
```

其中 `config.json` 文件可以参考 `config-example.json` 文件配置。见 <https://github.com/hanxi/xiaomusic/issues/94>

不修改默认端口 8090 的情况下，只需要执行 `xiaomusic` 即可启动。

## 已测试支持的设备

| 型号   | 名称                                                                                             |
| ---- | ---------------------------------------------------------------------------------------------- |
| L06A | [小爱音箱](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.l06a)             |
| L07A | [Redmi小爱音箱 Play](https://home.mi.com/webapp/content/baike/product/index.html?model=xiaomi.wifispeaker.l7a)                     |
| S12/S12A/MDZ-25-DA | [小米AI音箱](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.s12)            |
| LX5A | [小爱音箱 万能遥控版](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.lx5a)       |
| LX05 | [小爱音箱Play（2019款）](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.lx05)  |
| L15A | [小米AI音箱（第二代）](https://home.mi.com/webapp/content/baike/product/index.html?model=xiaomi.wifispeaker.l15a#/) |
| L16A | [Xiaomi Sound](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.l16a)     |
| L17A | [Xiaomi Sound Pro](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.l17a) |
| LX06 | [小爱音箱Pro](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.lx06)          |
| LX01 | [小爱音箱mini](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.lx01)         |
| L05B | [小爱音箱Play](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.l05b)         |
| L05C | [小米小爱音箱Play 增强版](https://home.mi.com/baike/index.html#/detail?model=xiaomi.wifispeaker.l05c)   |
| L09A | [小米音箱Art](https://home.mi.com/webapp/content/baike/product/index.html?model=xiaomi.wifispeaker.l09a) |
| LX04 X10A X08A | 已经支持的触屏版 |
| X08C X08E X8F | 需要设置【型号兼容模式】选项为 true |
| M01/XMYX01JY | 小米小爱音箱HD 需要设置【特殊型号获取对话记录】选项为 true 才能语音播放|

型号与产品名称对照可以在这里查询 <https://home.miot-spec.com/s/xiaomi.wifispeaker>

> [!NOTE]
> 如果你的设备支持播放，请反馈给我添加到支持列表里，谢谢。
> 目前应该所有设备类型都已经支持播放，有问题随时反馈。
> 其他触屏版不能播放可以设置【型号兼容模式】选项为 true 试试。见 <https://github.com/hanxi/xiaomusic/issues/30>

## 🎵 支持音乐格式

- mp3
- flac
- wav
- ape
- ogg
- m4a

> [!NOTE]
> 本地音乐会搜索目录下上面格式的文件，下载的歌曲是 mp3 格式的。
> 已知 L05B L05C LX06 L16A 不支持 flac 格式。
> 如果格式不能播放可以打开【转换为MP3】和【型号兼容模式】选项。具体见 <https://github.com/hanxi/xiaomusic/issues/153#issuecomment-2328168689>

## 🌏 网络歌单功能

可以配置一个 json 格式的歌单，支持电台和歌曲，也可以直接用别人分享的链接，同时配备了 m3u 文件格式转换工具，可以很方便的把 m3u 电台文件转换成网络歌单格式的 json 文件，具体用法见  <https://github.com/hanxi/xiaomusic/issues/78>

> [!NOTE]
> 欢迎有想法的朋友们制作更多的歌单转换工具。

## 🍺 更多其他可选配置

见 <https://github.com/hanxi/xiaomusic/issues/333>

## ⚠️ 安全提醒

> [!IMPORTANT]
>
> 1. 如果配置了公网访问 xiaomusic ，请一定要开启密码登陆，并设置复杂的密码。且不要在公共场所的 WiFi 环境下使用，否则可能造成小米账号密码泄露。
> 2. 强烈不建议将小爱音箱的小米账号绑定摄像头，代码难免会有 bug ，一旦小米账号密码泄露，可能监控录像也会泄露。

## 🤔 高级篇

- 自定义口令功能 <https://github.com/hanxi/xiaomusic/issues/105>
- [ ] 缺少一篇教程 [如何写自定义插件](https://github.com/hanxi/xiaomusic/issues/105)

### 👉 其他教程

更多功能见 [📝 文档汇总](https://github.com/hanxi/xiaomusic/issues/211)

