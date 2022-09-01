# MoveDAO backend
# 安装rust
    apt install curl build-essential gcc make -y
    curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh
    source ~/.profile
source ~/.cargo/env
# 安装postgres (ubuntu)
    sudo apt install postgresql
    #启动
    sudo /etc/init.d/postgresql start
    #停止
    sudo /etc/init.d/postgresql stop
    #重启
    sudo /etc/init.d/postgresql restart
    sudo -u postgres psql
    进入数据库修改密码
    ALTER USER postgres WITH PASSWORD '123456';
    #创建数据库
    CREATE DATABASE movedao;
    \c movedao
    #建表
    CREATE TABLE project(
    ID INT PRIMARY KEY     NOT NULL,
    NAME           TEXT    NOT NULL
    );

# 安装postgres (MacOS[M1])
    #安装 1
    brew install postgresql 
    brew services start postgresql
    #安装 2
    https://postgresapp.com/downloads.html
    打开 PostgreSQL 14 并点击Start

    创建role
    /opt/homebrew/bin/createuser -s postgres
    
    使用postgres终端
    psql postgres
    进入数据库修改密码
    ALTER USER postgres WITH PASSWORD '123456';
    #创建数据库
    CREATE DATABASE movedao;
    \c movedao
    #建表
    CREATE TABLE project(
    ID INT PRIMARY KEY     NOT NULL,
    NAME           TEXT    NOT NULL
    );

# 运行程序
    修改.env 文件里的配置
    cd backend
    cargo install
    cargo run 
    浏览器里访问:
    http://localhost:3000/

# TODO
    集成graphql
