# PicList

![](https://cdn.jsdelivr.net/gh/xiaoY233/PicList@main/public/assets/PicList.png)

![](https://img.shields.io/badge/Copyright-arch3rPro-ff9800?style=flat&logo=github&logoColor=white)

## 简介
PicList是一款高效的云存储和图床平台管理工具，基于PicGo深度二次开发，提供完整的图床功能和全面的云存储管理能力，主要特点包括：

- 完整保留PicGo所有功能，兼容大部分PicGo插件
- 扩展了内置图床平台，如WebDav、本地图床和SFTP等
- 相册支持同步云端删除文件
- 全面的云存储管理功能，包括文件操作、搜索和预览
- 内置图像处理工具，如水印、压缩、缩放、旋转和格式转换

## 官方网址

请访问 PicList官网 piclist.cn 获取更多信息。

此外，你也可以访问DeepWiki of PicList了解更多关于项目架构和开发的内容。

## 如何从PicGo迁移

PicList V1.5.0以上版本提供 一键迁移功能，进入 设置页面，然后在 从PicGo迁移选项点击右侧按钮即可，迁移后请重启应用生效。

## PicList-Core
PicList的内核使用PicList-core，这是基于原版PicGo-Core修改的版本，具有以下增强功能：

- 水印添加
- 图片压缩、缩放、旋转和格式转换
- CLI命令行支持
- 通过picgo-server命令启动上传服务器
- 如果您希望单独使用PicList-core，请访问GitHub仓库或npm包。

## 特色功能
- 完全兼容性：适用于Typora、Obsidian和大多数PicGo插件
- 扩展平台支持：新增WebDav、兰空图床、本地图床、SFTP等，原内置imgur图床额外支持账号登录上传
- 云端同步相册：支持同步删除云端图片，兼容所有内置图床和多个插件
- 高级相册功能：高级搜索、排序和批量URL修改
- 内置图像工具：水印添加、图片压缩、图片缩放、图片旋转和格式转换，支持高级重命名
- 表单上传：支持多电脑共享使用
- 配置同步：支持配置同步至GitHub/Gitee/Gitea仓库
- 云存储管理：云端目录查看、文件搜索、批量操作等功能
- 多格式预览：支持预览图片、视频、文本和Markdown文件（查看支持的文件格式列表）
- 批量操作：支持使用正则表达式批量重命名云端文件
- 链接分享：为私有存储桶生成预签名链接
- 易用性改进：软件自动更新、多种启动模式、界面优化等
