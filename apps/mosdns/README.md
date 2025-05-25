# mosdns


## 开放端口

- 53 （mosdns）
- 4000 （Grafana）

## 服务

- mosdns
- Prometheus
- Grafana
- vector
- loki

## 使用镜像

mosdns 使用自制 `shelken/mosdns`，目前基于mosdns 4.5.*

其他则为官方最新


## 持久化数据

保存在当前目录下data目录，可更改`.env`中变量

