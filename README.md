# TT
### 大家好,我是一个努力的程序员,目前,对自己日常开发中用到的一个功能性的部分进行了整理,名为TTFrameWork,希望大家多多支持,多多指教</br>
#### 要是喜欢的,多点点星星

<br>更新时间:2017.7.24</br>
### 目前进度:</br>
1.1 版本发布</br>

<br>如果有问题可以通过以下联系方式,我们一起交流:
* 邮箱:122674287@qq.com(QQ)
* 微博:单细胞的逻辑

<br>1.1 Version</br>
*1.更新Aliyun SDK, SMS SDK
*2.修改AliyunManager上传多个数据的bug,并优化了上传
*3.优化AppPurchaseManager,实现请求失败重试,并优化验证流程
*4.添加TTBaseDownloadRequest,进行先关的下载请求.
*5.添加TTSeverManager,可以在开发模式下,进行服务器的切换,这个需要手动设置相关参数
*6.添加TTBaseReqCommon,将网络数据请求情况进行统一管理

<br>根据日常开发需求,基本分为一下内容</br>
## TTOtherPayManager</br>
第三方支付,整合了微信支付和支付宝支付,目前采用的是客户端集成方案,建议将签名方案放到服务端去做,安全</br>
## Models</br>
这里是model的基类</br>
## View</br>
这里是项目中常用的View,如TTAlert弹框,TTTextView(占位符)</br>
## Controller</br>
这里可以作为项目的ViewController的基类</br>
## Category(目前已经归入Common中)</br>
这里主要是针对苹果自带的控件的功能的拓展,如获取View的高度,宽度,动画设置等等</br>

## NetWork</br>
这里主要针对项目中的数据请求进行封装</br>
## ShareKit</br>
这里主要是项目中的分享模块的封装</br>

## Common</br>
这里是工具类的整合</br>
## ResourceFiles</br>
TTFrameWork中涉及到的资源选项</br>

