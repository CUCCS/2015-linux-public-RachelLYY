# web服务器

## 环境安装

* 端口配置
  * nginx：80
  * verynginx：8000
  * dvwa和wordpress配置在nginx下


* [nginx、php、mysql、php-fpm等安装](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04)

* verynginx

  * ```bash
    git clone https://github.com/alexazhou/VeryNginx.git
    python install.py install
    # error: the HTTP rewrite module requires the PCRE library.
    apt install libpcre3 libpcre3-dev libssl-dev build-essential
    ```

  * ![1](1.png)

  * 启动

    * 报错
    * ![1](3.png)
    * 查看端口占用情况
      * `netstat -ntpl`
      * ![4](4.png)
      * `kill 14135`
      * 重新启动
        * 由于开启代理导致使用chrome没法访问verynginx首页，只能使用firefox。
    * ![1](2.png)

* [wordpress](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-on-ubuntu-16-04)

  * ![6](6.png)

* [dvwa](http://www.dvwa.co.uk/)

  * 复制安装包到/var/www/html目录下
  * ![5](5.png)

## 实验检查点

* **基本要求**
  * 在一台主机（虚拟机）上同时配置Nginx和VeryNginx
    * nginx	
      * ![1](7.png)
      * verynginx
        * ![1](2.png)
  * VeryNginx作为本次实验的Web App的反向代理服务器和WAF
  * PHP-FPM进程的反向代理配置在nginx服务器上，VeryNginx服务器不直接配置Web站点服务
    * ![1](9.png)
  * ![8](8.png)
  * 使用[Wordpress](https://wordpress.org/)搭建的站点对外提供访问的地址为： [https://wp.sec.cuc.edu.cn](https://wp.sec.cuc.edu.cn/) 和 [http://wp.sec.cuc.edu.cn](http://wp.sec.cuc.edu.cn/)
  * ![1](11.png)
  * ​
  * 使用dvwa搭建的站点对外提供访问的地址为： [http://dvwa.sec.cuc.edu.cn](http://dvwa.sec.cuc.edu.cn/)
    * ![14](14.png)
* **安全加固要求**
  * 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的**友好错误提示信息页面-1 **
    * matcher
      * ![21](21.png)
    * response
      * ![2](30.png)
    * filter
      * ![2](20.png)
    * 效果
      * ![1](19.png)
  * Damn Vulnerable Web Application (DVWA)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-2
    * matcher
      * 这里禁止了所有来源ip不是192.168.13.1的用户
      * ![22](22.png)
    * response
      * ![2](29.png)
    * filter
      * ![24](24.png)
    * 本机访问时，由于ip不在白名单上
      * ![23](23.png)
  * 在不升级Wordpress版本的情况下，通过定制VeryNginx的访问控制策略规则，热修复WordPress < 4.7.1 - Username Enumeration
    * 漏洞简介：可以通过浏览器地址栏直接访问/wp-json/wp/v2/users/，进而获取wordpress的用户信息
    * matcher
      * ![27](27.png)
    * response
      * ![2](28.png)
    * filter
      * ![26](26.png)
    * 效果
      * ![25](25.png)
  * 通过配置VeryNginx的Filter规则实现对Damn Vulnerable Web Application (DVWA)的SQL注入实验在低安全等级条件下进行防护
    * matcher
      * ![1](31.png)
    * response
      * ![2](32.png)
    * filter
      * ![3](33.png)
    * 效果
      * ![3](34.png)
* **verynginx配置要求**
  * VeryNginx的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-3
    * matcher
      * ![2](35.png)
    * response
      * ![3](36.png)
    * filter
      * ![3](37.png)
    * 效果
      * ![38](38.png)
  * 通过定制VeryNginx的访问控制策略规则实现：
    * 限制DVWA站点的单IP访问速率为每秒请求数 < 50
    * 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
    * 超过访问频率限制的请求直接返回自定义**错误提示信息页面-4**
      * ![3](39.png)
      * ![4](40.png)
      * 命令`curl http://wp.sec.cuc.edu.cn?[1-21]`
      * ![4](41.png)
    * 禁止curl访问
      * matcher
        * ![4](42.png)
      * filter
        * ![2](43.png)
      * 效果
        * ![4](44.png)



## 遇到的问题

* ssl自签发的问题
  * ![4](45.png)
  * verynginx配置过了，证书也成功导入浏览器，但是显示连接不是私密连接，没法访问https页面
* nginx配置文件，配置多个端口
  * 开始尝试的是8000和8081，开启nginx没报错，并且查看端口状态都是开启的，但是没法访问页面
  * 后来把端口换成8082就可以了
