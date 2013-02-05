# ZDDownloadKit

ZDDownloadKit is a light-weight download framework in iOS, which is scalable.  


## Usage

### Create a single-thread download task
```
// Using instance method
ZDSingleThreadDownloadTask *task = [[ZDSingleThreadDownloadTask alloc] initWithURL:sourceURL];

// Using class method
ZDSingleThreadDownloadTask *task = [ZDSingleThreadDownloadTask taskWithURL:sourceURL];
```

### Access to default download manager
```
ZDDownloadManager *downloadManager = [ZDDownloadManager defaultManager];
```

### Add download task to download manager
```
[downloadManager addTask:task startImmediately:YES];
```


## Scalability

### Where to start
If you wanna custom your own download task, you should start from ZDDownloadTask.  

ZDDownloadTask is the Base Class of all task in ZDDownloadKit.  

### What to do

* Inherit ZDDownloadTask
* Implement the following two method

```
- (void)startTask;
- (void)stopTask;
```
* Make sure you set the state and progress value conform to your desire


## Donate 捐赠

You can donate me
via:
* [Alipay | 支付宝](https://me.alipay.com/0dayzh)

## License
This code is distributed under the terms of the GNU General Public License.
