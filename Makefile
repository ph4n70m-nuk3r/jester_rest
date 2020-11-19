.PHONY: prerequisites install_deps run ping pid kill clean

list_targets:
	@echo 'Make targets:'
	@printf '  - %s\n' \
	  'prerequisites  (installs gcc,binutils,coreutils,openssl,nim on Debian/Ubuntu)' \
	  'install_deps   (nimble install --depsOnly --verbose)' \
	  'jester_rest    (nimble -d:useStdLib -d:release build --verbose)' \
	  'run            (./jester_rest 1> out.log 2> err.log &)' \
	  'ping           (hits the ping endpoint using curl)' \
	  'pid            (gets PID of the running process)' \
	  'kill           (kills the running process)' \
	  'clean          (deletes executable and log files)'

prerequisites:
	sudo apt install -y binutils coreutils gcc openssl
	snap install nim-lang --classic
	echo 'PATH="/snap/nim-lang/current/bin:${PATH}"' >> ~/.bashrc
	@echo ''
	@echo 'To refresh your PATH variable, use command:'
	@echo '    . ~/.bashrc'

install_deps:
	nimble install --depsOnly --verbose

jester_rest: install_deps
	nimble -d:useStdLib -d:release build --verbose

run: jester_rest
	./jester_rest 1>out.log 2>err.log &

.ONESHELL:
ping:
	@MESG="$$(curl -s -o resp localhost:5000/ping -w 'HTTP %{http_version} [%{http_code}] %{content_type} =>')"
	@if [ "$$PID" != "" ]; then  echo "$${MESG} '$$(cat resp)'";  fi
	@rm -f resp

.ONESHELL:
pid:
	@PID="$$(ps -aux | grep './jester_rest$$' | awk '{print $$2}')"
	@if [ "$$PID" != "" ]; then  echo "$$PID";  fi

kill:
	kill $$(ps -aux | grep './jester_rest$$' | awk '{print $$2}')

clean:
	rm -f out.log err.log jester_rest

