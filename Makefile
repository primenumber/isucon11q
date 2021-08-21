all: app

app:
	cd webapp/go; GOOS=linux GOARCH=amd64 go build

deploy:
	ssh isucon@isucondition-1.t.isucon.dev rm /home/isucon/webapp/go/isucondition
	scp webapp/go/isucondition isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/go/
	scp etc/isucondition.go.service isucon@isucondition-1.t.isucon.dev:/tmp/isucondition.go.service
	scp etc/nginx.conf isucon@isucondition-1.t.isucon.dev:/etc/nginx/nginx.conf
	ssh isucon@isucondition-1.t.isucon.dev 'sudo cp /tmp/isucondition.go.service /etc/systemd/system/isucondition.go.service; sudo systemctl daemon-reload; sudo systemctl restart isucondition.go.service'
	ssh isucon@isucondition-1.t.isucon.dev 'sudo systemctl restart nginx'
	curl https://isucondition-1.t.isucon.dev/
