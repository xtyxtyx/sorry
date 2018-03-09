
![图片](https://dn-coding-net-production-pp.qbox.me/f5beb81a-abf9-424b-a92e-625b008d30b7.gif)

另有[python版](https://github.com/East196/sorrypy)

# 部署指南

## 使用Docker
```
docker build -t sorry .
```

## 手工部署
首先，机器上得安装好ruby :gem:

接下来：
```bash
# 安装bundler
gem install bundler

# [可选] 使用国内镜像
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

# [可选] Linux服务器一般需要安装中文字体
apt install language-pack-zh-hans
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

### [可选] 使用PM2监控&自动重启

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

## 定时清除缓存
```
crontab -e

# 在每小时的第10分钟 清除700分钟以前的gif

10  *  *   *   *     find /root/sorry/public/cache -name '*.gif' -mmin +700  -exec rm {} \;       
```

## 适配新Gif
目前，想要适配新的gif,需要改动3个文件
```
public/index.html
resource/sorry.mp4
resource/sorry.erb
```
其中
```
index.html  按照句子的多少删掉或者增加<input>即可
sorry.mp4   替换成新视频
sorry.erb   替换成新的字幕模板
```

### 字幕模板sorry.erb
首先使用aegisub为模板视频创建字幕，保存为sorry.ass（aegisub教程可以看这个 https://tieba.baidu.com/p/1360405931 ）
![图片](https://dn-coding-net-production-pp.qbox.me/56a213df-9ff7-41e0-9b6c-96b1f0fe2cb6.png)

然后把文本替换成模板字符串 <%= sentences[n] %>
![图片](https://dn-coding-net-production-pp.qbox.me/6b07bc65-c3d7-4251-aad2-bd7b05af9102.png)

最后保存为sorry.erb

现在这个网站就可以制作新的gif了

如果你不熟悉aegisub的使用，也可以发个issue，同时附上模板视频🎞️

## TODO

- [ ] 重新设计主页
- [ ] 重新设计404页面
- [ ] 把gif的渲染弄成队列，提高响应速度
- [x] 定时删除缓存，不然有多少硬盘空间也不够用
- [ ] 写个脚本，自动配置新的gif
- [ ] 写测试
