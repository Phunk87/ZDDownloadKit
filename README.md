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

## Donate 捐赠

You can donate me 您可以支持我
via:
* [Alipay | 支付宝](https://me.alipay.com/0dayzh)

## License 许可协议
This code is distributed under the terms of the GNU General Public License.  
代码使用 GNU General Public License 许可发布.
