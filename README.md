
![图片](https://dn-coding-net-production-pp.qbox.me/f5beb81a-abf9-424b-a92e-625b008d30b7.gif)

[V2EX](https://www.v2ex.com/t/431802)
## 常用特效代码
出现在句子中的特效代码会对其后的字符产生影响
```
咕咕{\i1}{\fs40}咕咕咕{\r}咕
```
![示例](https://dn-coding-net-production-pp.qbox.me/2d664d1c-c691-42ae-a02c-0687f6fa17d2.png)
```
\n 折行
\h 空格

{\i1} 斜体
{\i0} 取消斜体

{\b1} 粗体
{\b0} 取消粗体

{\u1} 下划线
{\u0} 取消下划线

{\fs60} 调整字号

{\fad(100,200)} 100ms淡入，200ms淡出

{\r} 重置所有特效
```
## 源代码库

```
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── public                  # 静态文件目录
├── views                   # 主页目录
├── templates               # 模板目录
├── README.md
├── site_config.yml         # 站点配置文件
├── src                     # 这里就是源代码
└── temp                    # 把临时文件安放在这里
```
另有
- [python版](https://github.com/East196/sorrypy)，由@East196编写
- [java版](https://github.com/li24361/sorryJava)，由@li24361编写
- [nodejs版](https://github.com/q809198545/node-sorry)，由@q809198545编写
- [C# ASP.NET版](https://github.com/shuangrain/SorryNet)，由@shuangrain编写
- [微信小程序](https://github.com/CoXier/iemoji-wechat)，由@CoXier编写
- [nodejs版(使用Drawtext filter渲染)](https://github.com/SnailDev/SnailDev.GifMaker)，由@SnailDev编写
- [网页版(使用Canvas渲染)](https://coding.net/u/hhhhhg/p/wjzGif-JavaScript/git)，由@hhhhhg编写
- [PHP版](https://github.com/PrintNow/php-sorry-gif)，由@PrintNow编写
- [Golang版](https://github.com/Hentioe/sorry-generator)，由@Hentioe编写
- [AlfredWork版](https://github.com/BlackDragonF/AlfredWorkflows)，由@BlackDragonF编写
- [nodejs版(使用koa2)](https://github.com/wadejs/sorry-template)，由@wadejs编写
- [VuePress版](https://github.com/fritx/SorryPress)，由@fritx编写
- [网页版](https://github.com/WincerChan/Meme-generator)，由@WincerChan编写

## API

制作GIF：
```
POST https://sorry.xuty.tk/api/<template_name>/make
{
    "0": "好啊",
    "1": "...",
    ...
}

# 返回GIF下载地址
-> 200 /cache/c2f4069ed207dc38e0f2d9359a2fa6b7.gif

# 或服务器忙
-> 503
```
目前支持的template_name有：
```
- sorry
- wangjingze
- jinkela        # 金坷垃
- marmot         # 土拨鼠
- dagong         # 窃格瓦拉
- diandongche    # 窃格瓦拉偷电动车
```

## 部署指南

### 使用Docker
```
docker build -t sorry .
docker run --rm -it -p 4567:4567 sorry
```

### 手工部署
首先，机器上得安装好ruby :gem:

接下来：
```bash
# 安装bundler
gem install bundler

# [可选] 使用国内镜像
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

# [可选] Linux服务器一般需要安装中文字体
apt install ttf-wqy-microhei 

# 安装编译依赖
apt install ruby-dev build-essential

# 安装ffmpeg
apt install ffmpeg

# 安装依赖
bundle install

# 运行
ruby src/sorry.rb

# 生产环境
APP_ENV=production ruby src/sorry.rb

```

#### [可选] 使用PM2监控&自动重启

```
npm install pm2 -g

pm2 start process.yml --env production

# [可选] 非root用户使用80端口
sudo apt-get install authbind
sudo touch /etc/authbind/byport/80
sudo chown %user% /etc/authbind/byport/80
sudo chmod 755 /etc/authbind/byport/80

alias pm2='authbind --deep pm2'
authbind --deep pm2 update

# [可选] 定时重启服务
crontab -e
10   22  *   *   *     pm2 start sorry       
```

### 定时清除缓存
```
crontab -e

# 在每小时的第10分钟 清除700分钟以前的gif

10  *  *   *   *     find /root/sorry/public/cache -name '*.gif' -mmin +700  -exec rm {} \;       
```

## 添加GIF模板
向网站中添加模板需要加入以下文件

```
templates/<template_name>/template.mp4  # 视频模板
templates/<template_name>/template.ass  # 字幕模板
public/<template_name>/example.png   # 展示图片
views/<template_name>.erb    # 模板主页
```

其中`index.erb` 参考其他模板主页，增减`<input>`的数量即可

然后发个Pull request

如果你不熟悉aegisub的使用，也可以只提供视频模板。如果你是github用户，可以发个issue， 也可以[发送邮件](mailto:xty50337@hotmail.com)

## 制作字幕模板template.ass
首先使用aegisub为模板视频创建字幕，保存为template.ass（aegisub教程可以看这个 https://tieba.baidu.com/p/1360405931 ）
![图片](https://dn-coding-net-production-pp.qbox.me/56a213df-9ff7-41e0-9b6c-96b1f0fe2cb6.png)

然后把文本替换成模板字符串 <%= sentences[n] %>
![图片](https://dn-coding-net-production-pp.qbox.me/6b07bc65-c3d7-4251-aad2-bd7b05af9102.png)

## TODO

- [ ] 重新设计主页
- [ ] 重新设计404页面
- [ ] 把gif的渲染弄成队列，提高响应速度
- [x] 定时删除缓存，不然有多少硬盘空间也不够用
- [ ] 写个脚本，自动配置新的gif
- [ ] 写测试

## 服务器

- [Cloudcone](https://app.cloudcone.com/?ref=940) sorry.xuty.tk部署在Cloudcone上
- [Vultr 最低2.5$/月](https://www.vultr.com/?ref=7019614)
- [DigitalOcean 注册送10美金](https://m.do.co/c/67a58d6cf3da)
