# sorry 为所欲为

![图片](https://dn-coding-net-production-pp.qbox.me/f5beb81a-abf9-424b-a92e-625b008d30b7.gif)

## 代码库

```
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── public                  # 静态文件目录
├── README.md
├── resource                # 模板文件目录，里边存放用于生成gif的文件
├── site_config.yml         # 站点配置文件
├── src                     # 这里就是源代码
└── temp                    # 把临时文件安放在这里
```

## 部署
首先，机器上得安装好ruby :gem:

接下来：
```bash
# 安装bundle
gem install bundler

# [可选] 使用国内镜像
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

# 安装依赖
bundle install

# 运行
ruby src/sorry.rb

# 生产环境
APP_ENV=production ruby src/sorry.rb

```


## TODO

- [ ] 把gif的渲染弄成队列，提高响应速度
- [ ] 定时删除缓存，不然有多少硬盘空间也不够用
- [ ] 写个脚本，自动配置新的gif
- [ ] 写测试