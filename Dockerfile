# 版本信息
FROM centos:7.2.1511
MAINTAINER llf "898959800@qq.com"

# 设置当前工具目录
# 该命令不会新增镜像层
WORKDIR /home

# 定义变量
ENV JDK_FILE jdk-8u191-linux-x64.tar.gz
ENV TOMCAT_FILE apache-tomcat-7.0.92.tar.gz

COPY ./$JDK_FILE /home
COPY ./$TOMCAT_FILE /home

# 安装必要的工具
RUN yum install -y tar && \
    mkdir -p /home/jdk && \
    tar -xvzf $JDK_FILE -C /home/jdk --strip-components 1 && \
    rm -f $JDK_FILE && \
    mkdir -p /home/tomcat && \
    tar -xvzf $TOMCAT_FILE -C /home/tomcat --strip-components 1 && \ 
    rm -f $TOMCAT_FILE && \   
    mkdir -p /home/jxdx/eismp/fileDir/uploadFile/  && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum clean all

# 设置环境变量
ENV JAVA_HOME /home/jdk
ENV CATALINA_HOME /home/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
ENV TZ Asia/Shanghai
ENV LANG en_US.utf8

# 暴露tomcat 8080端口
EXPOSE 8080

# 启动容器执行下面的命令
ENTRYPOINT /home/tomcat/bin/startup.sh && tail -f /home/tomcat/logs/catalina.out

# 创建容器启动tomcat，由于ENTRYPOINT优先级比CMD高，所以这里的CMD不会执行
CMD ["/home/tomcat/bin/startup.sh"]
