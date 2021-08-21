all: app

app:
	cd webapp/go; GOOS=linux GOARCH=amd64 go build

deploy-app: app
	ssh isucon@isucondition-1.t.isucon.dev rm -f /home/isucon/webapp/go/isucondition
	scp webapp/go/isucondition isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/go/
	ssh isucon@isucondition-2.t.isucon.dev rm -f /home/isucon/webapp/go/isucondition
	scp webapp/go/isucondition isucon@isucondition-2.t.isucon.dev:/home/isucon/webapp/go/

deploy-conf:
	scp etc/isucondition.go.service isucon@isucondition-1.t.isucon.dev:/tmp/isucondition.go.service
	scp env.sh isucon@isucondition-1.t.isucon.dev:/home/isucon/env.sh
	scp webapp/sql/0_Schema.sql isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/sql/
	scp webapp/sql/init.sh isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/sql/
	scp etc/1-isucondition.conf isucon@isucondition-1.t.isucon.devgi:/tmp
	ssh isucon@isucondition-1.t.isucon.dev 'sudo cp /tmp/isucondition.go.service /etc/systemd/system/isucondition.go.service; sudo systemctl daemon-reload; sudo systemctl restart isucondition.go.service; sudo cp /tmp/1-isucondition.conf /etc/nginx/sites-available/isucondition.conf; sudo systemctl restart nginx'
	curl https://isucondition-1.t.isucon.dev/
	scp etc/isucondition.go.service isucon@isucondition-2.t.isucon.dev:/tmp/isucondition.go.service
	scp env.sh isucon@isucondition-2.t.isucon.dev:/home/isucon/env.sh
	scp etc/2-isucondition.conf isucon@isucondition-2.t.isucon.dev:/tmp
	ssh isucon@isucondition-2.t.isucon.dev 'sudo cp /tmp/isucondition.go.service /etc/systemd/system/isucondition.go.service; sudo systemctl daemon-reload; sudo systemctl restart isucondition.go.service; sudo cp /tmp/2-isucondition.conf /etc/nginx/sites-available/isucondition.conf; sudo systemctl restart nginx'

deploy: deploy-app deploy-conf

deploy-nginx-only:
	scp -r etc/nginx isucon@isucondition-1.t.isucon.dev:/tmp
	ssh isucon@isucondition-1.t.isucon.dev 'sudo cp -rT /tmp/nginx /etc/nginx ; sudo systemctl restart nginx'

deploy-3-db:
	scp etc/isucondition-3.50-server.cnf isucon@isucondition-3.t.isucon.dev:/tmp/50-server.cnf
	ssh isucon@isucondition-3.t.isucon.dev 'sudo mv /tmp/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf; sudo systemctl restart mariadb.service'

get-nginx-log:
	scp isucon@isucondition-1.t.isucon.dev:/var/log/nginx/nazo-access.log /tmp

alp:
	cat /tmp/nazo-access.log| alp ltsv -m '/api/isu/[-a-z0-9]+,/api/condition/[-a-z0-9]+,/isu/[-a-z0-9]+'
