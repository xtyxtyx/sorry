# sorry 为所欲为

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
首先，机器上得安装好ruby :ruby:

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

```

### 增加文件描述符数量限制
如果运行在Linux服务器上，可能需要增加文件描述符限制

// 不然会定期地挂掉
```
ulimit -n 65536
```

## TODO

- [ ] 把gif的渲染弄成队列，提高响应速度
- [ ] 定时删除缓存，不然有多少硬盘空间也不够用
- [ ] 写个脚本，自动配置新的gif
- [ ] 写测试

## 话说后端语言不是crystal么？

crystal现在还在beta阶段，实际使用时会有一些问题

所以用ruby重写了