# ZDDownloadKit

ZDDownloadKit是一个用于iOS的轻量级下载framework，具有很高的可扩展性。


## 使用

### 创建一个单线程下载任务
```
// Using instance method
ZDSingleThreadDownloadTask *task = [[ZDSingleThreadDownloadTask alloc] initWithURL:sourceURL];

// Using class method
ZDSingleThreadDownloadTask *task = [ZDSingleThreadDownloadTask taskWithURL:sourceURL];
```

### 获取默认的下载管理器
```
ZDDownloadManager *downloadManager = [ZDDownloadManager defaultManager];
```

### 添加下载任务到下载管理器中
```
[downloadManager addTask:task startImmediately:YES];
```


## 可扩展性

### 从何开始
如果你想定制自己的下载任务，你需要从ZDDownloadTask开始。
ZDDownloadTask是所有ZDDownloadKit下载任务的基类。

### 该做些什么

* 继承ZDDownloadTask
* 实现下面的两个方法

```
- (void)startTask;
- (void)stopTask;
```
* 确保state和progress按照你的意愿被设置


## 捐赠

您可以支持我
通过：
* [支付宝](https://me.alipay.com/0dayzh)
* 比特币 1DK98CTQ3hXb2j3VD7Tbz4v16ytZJhtPWv

## 许可协议
代码使用 GNU General Public License 许可发布.
