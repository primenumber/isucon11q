all: app

app:
	cd webapp/go; GOOS=linux GOARCH=amd64 go build

deploy:
	ssh isucon@isucondition-1.t.isucon.dev rm /home/isucon/webapp/go/isucondition
	scp webapp/go/isucondition isucon@isucondition-1.t.isucon.dev:/home/isucon/webapp/go/
	ssh isucon@isucondition-1.t.isucon.dev sudo systemctl restart isucondition.go.service
	curl https://isucondition-1.t.isucon.dev/
