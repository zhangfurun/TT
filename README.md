![](/SourceFile/Default.png)
### 大家好,我是一个努力的程序员,目前,对自己日常开发中用到的一个功能性的部分进行了整理,名为TTFrameWork,希望大家多多支持,多多指教</br>
#### 要是喜欢的,多点点星星

[![Build Status](https://travis-ci.org/zhangfurun/TT.svg?branch=master)](https://travis-ci.org/zhangfurun/TT)

---
## 版本内容
### 1.1 Version (2017-07-24)
* [更新]Aliyun SDK, SMS SDK
* [修改]AliyunManager上传多个数据的bug,并优化了上传
* [优化]AppPurchaseManager,实现请求失败重试,并优化验证流程
* [添加]TTBaseDownloadRequest,进行先关的下载请求.
* [添加]TTSeverManager,可以在开发模式下,进行服务器的切换,这个需要手动设置相关参数
* [添加]TTBaseReqCommon,将网络数据请求情况进行统一管理

### 1.0 Version(2017-03-20)
* [上传]上传初期项目

---
## 目录
#### TTOtherPayManager
第三方支付,整合了微信支付和支付宝支付,目前采用的是客户端集成方案,建议将签名方案放到服务端去做,安全
#### Models
这里是model的基类
#### View
这里是项目中常用的View,如TTAlert弹框,TTTextView(占位符)

#### Controller
这里可以作为项目的ViewController的基类

#### NetWork
这里主要针对项目中的数据请求进行封装
#### ShareKit
这里主要是项目中的分享模块的封装

#### Common
这里是工具类的整合</br>
* Libs</br>
这里是使用的第三方源码,包括第三方类库
* Category</br>
这里主要是针对苹果自带的控件的功能的拓展,如获取View的高度,宽度,动画设置等等
* Tools</br>
自定义实际使用Tool 或者 Manager
#### ResourceFiles
TTFrameWork中涉及到的资源选项

---
## 联系
如果有问题可以通过以下联系方式,我们一起交流:
* 邮箱:122674287@qq.com(QQ)
* 微博:单细胞的逻辑

