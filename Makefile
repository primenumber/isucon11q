all: app

app:
	cd webapp/go; GOOS=linux GOARCH=amd64 go build

deploy:
	ssh isucon@isucondition-1.t.isucon.dev rm /home/isucon/webapp/go/isucondition
	scp webapp/go/isucondition isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/go/
	scp etc/isucondition.go.service isucon@isucondition-1.t.isucon.dev:/tmp/isucondition.go.service
	scp webapp/sql/init.sh isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/sql/
	ssh isucon@isucondition-1.t.isucon.dev 'sudo cp /tmp/isucondition.go.service /etc/systemd/system/isucondition.go.service; sudo systemctl daemon-reload; sudo systemctl restart isucondition.go.service'
	curl https://isucondition-1.t.isucon.dev/

deploy-3-db:
	scp etc/isucondition-3.50-server.cnf isucon@isucondition-3.t.isucon.dev:/tmp/50-server.cnf
	ssh isucon@isucondition-3.t.isucon.dev 'sudo mv /tmp/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf; sudo systemctl restart mariadb.service'
