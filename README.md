# ZDDownloadKit

ZDDownloadKit is a light-weight download framework in iOS, which is scalable.
ZDDownloadKit是一个用于iOS的轻量级下载framework，具有很高的可扩展性。


## Usage 使用

### Create a single-thread download task 创建一个单线程下载任务
```
// Using instance method
ZDSingleThreadDownloadTask *task = [[ZDSingleThreadDownloadTask alloc] initWithURL:sourceURL];

// Using class method
ZDSingleThreadDownloadTask *task = [ZDSingleThreadDownloadTask taskWithURL:sourceURL];
```

### Access to default download manager 获取默认的下载管理器
```
ZDDownloadManager *downloadManager = [ZDDownloadManager defaultManager];
```

### Add download task to download manager 添加下载任务到下载管理器中
```
[downloadManager addTask:task startImmediately:YES];
```


## Scalability 可扩展性

### Where to start 从何开始
If you wanna custom your own download task, you should start from ZDDownloadTask.  
如果你想定制自己的下载任务，你需要从ZDDownloadTask开始。

ZDDownloadTask is the Base Class of all task in ZDDownloadKit.  
ZDDownloadTask是所有ZDDownloadKit下载任务的基类。

### What to do 该做些什么

* Inherit ZDDownloadTask 继承ZDDownloadTask
* Implement the following two method 实现下面的两个方法

```
- (void)startTask;
- (void)stopTask;
```
* Make sure you set the state and progress value conform to your desire 确保state和progress按照你的意愿被设置


## Donate 捐赠

You can donate me 您可以支持我
via:
* [Alipay | 支付宝](https://me.alipay.com/0dayzh)

## License 许可协议
This code is distributed under the terms of the GNU General Public License.  
代码使用 GNU General Public License 许可发布.
