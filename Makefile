APPNAME := isuports.service

.PHONY: *
gogo: stop-services build logs/clear start-services

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop $(APPNAME)
	# sudo systemctl stop mysql
	ssh isucon-s2 "sudo systemctl stop mysql"

build:
	echo 'do nothing'
	# cd go && make

logs: limit=10000
logs: opts=
logs:
	journalctl -ex --since "$(shell systemctl status isuports.service | grep "Active:" | awk '{print $$6, $$7}')" -n $(limit) -q $(opts)

logs/error:
	$(MAKE) logs opts=' --grep "(error|panic|- 500)" --no-pager -q'

logs/clear:
	sudo journalctl --vacuum-size=1K
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	# sudo truncate --size 0 /var/log/mysql/mysql-slow.log && sudo chmod 666 /var/log/mysql/mysql-slow.log
	# sudo truncate --size 0 /var/log/mysql/error.log
	ssh isucon-s2 "sudo truncate --size 0 /var/log/mysql/mysql-slow.log && sudo  chmod 666 /var/log/mysql/mysql-slow.log"
	ssh isucon-s2 "sudo truncate --size 0 /var/log/mysql/error.log"

start-services:
	sudo systemctl daemon-reload
	ssh isucon-s2 "sudo systemctl start mysql"
	# sudo systemctl start mysql
	sudo systemctl start $(APPNAME)
	sudo systemctl start nginx

kataribe: timestamp=$(shell TZ=Asia/Tokyo date "+%Y%m%d-%H%M%S")
kataribe:
	mkdir -p ~/kataribe-logs
	sudo cp /var/log/nginx/access.log /tmp/last-access.log && sudo chmod 0666 /tmp/last-access.log
	cat /tmp/last-access.log | kataribe -conf kataribe.toml > ~/kataribe-logs/$$timestamp.log
	cat ~/kataribe-logs/$$timestamp.log | grep --after-context 20 "Top 20 Sort By Total"

bench: 
	ssh isucon-bench "cd bench && ./bench -target-addr 172.31.36.27:443 -target-url=https://t.isucon.local"

pprof: time=90
pprof: prof_file=/tmp/pprof/pprof.samples.$(shell TZ=Asia/Tokyo date +"%H%M").$(shell git rev-parse HEAD | cut -c 1-8).pb.gz
pprof:
	@mkdir -p /tmp/pprof
	curl -sSf "http://localhost:6060/debug/fgprof?seconds=$(time)" > $(prof_file)
	go tool pprof $(prof_file)

bench:
	ssh isucon-s3 "cd bench && ./bench -target-addr 172.31.36.27:443 -target-url=https://t.isucon.local"
