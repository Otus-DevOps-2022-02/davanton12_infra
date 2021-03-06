# davanton12_infra

davanton12 Infra repository
add file test.py
```
- /github subscribe Otus-DevOps-2022-02/davanton12_infra commits:*
- git branch
- git checkout main
- git pull
- git mv
- git add .
- git commit -m 'comment'
- git push --set-upstream origin <branch>
- git update-index --chmod=+x script.sh
```
```
- cat output.json | jq -r ' .builds[0].artifact_id'
```
## Лекция 5

### задание 1:
```
ssh -i ~/.ssh/appuser -J appuser@51.250.66.252 appuser@10.128.0.30
```
### задание 2:
```
alias someinternalhost='ssh -i ~/.ssh/appuser -J appuser@51.250.66.252 appuser@10.128.0.30'
```
### задание 3:
```  
bastion_IP = 51.250.66.252
someinternalhost_IP = 10.128.0.30
```
## Лекция 6

### Задание 1:
```  
testapp_IP = 51.250.67.179
testapp_port = 9292
```
### Задание 2:
```
yc compute instance create \
  --name test-app \
  --hostname test-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --zone ru-central1-a \
  --metadata-from-file user-data=./metadata.yaml
```
## Лекция 7

- Поработал с Packer
- Запек immutable образ с приложением, которое стартует при разворачивании VM (immutable.json)
- Создал скрипт create-reddit-vm.sh в директории config-scripts, который из шаблона immutable.json создает образ и поднимает виртуалку на базе этого диска.
- Попробовал выгружать значения с помощью jq
  
  команды:
  ```
  - yc config list
  - yc compute image list
  - yc compute image list | grep reddit-full | awk '{print $2}'
  - packer -v
  - packer validate -var-file=./variables.json ./immutable.json
  - packer build -var-file=./variables.json ./immutable.json
  ```
## Лекция 8

- Поработал с terraform
- Научился описывать инфраструктуру, планировать изменения, применять изменения, пересоздавать необходимые компоненты и удалять их.
- Создал балансировщик нагрузки в облаке и привязал к нему две виртуалки с приложением.
- Сократил код, добавив возможность указывать количество виртуалок.

Установка:
  ```
  - Скачать образ с зеркала https://hashicorp-releases.website.yandexcloud.net/terraform/
  - Распаковать в /usr/local/bin/
  ```

Команды:
  ```
  yc config list
  terraform -v
  terraform init
  yc compute image list
  terraform apply -auto-approve
  terraform show | grep nat_ip_address
  terraform refresh
  terraform output
  terraform output external_ip_address_app
  terraform taint yandex_compute_instance.app # пересоздать ресурс VM при следующем применении изменений
  terraform destroy
  terraform fmt
  ```
  
Замечание:
  - После 0.13 версии terraform нельзя использовать писанину в виде:
  ```
  provider "yandex" {
  version                  = "~> 0.35"
  ```
  - Нужно использовать
  ```
  terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.35"
  }
  ```

## Лекция 9

 - Создали отдельные образы для приложений app и db в packer
 - Создали отдельные конфигурационные файлы для приложений app и db в terraform
 - Познакомились с модулями
 - Узнали, что модули можно подключать из разных реп
 - Настроили хранение стейт файла в удаленном бекенде используя Yandex Object Storage

 Команды:
  ```
  yc iam service-account list
	yc iam access-key create --service-account-name <name>
	terraform get
	terraform init -reconfigure
	terraform init -migrate-state
  ```
## Лекция 10

 - Рассмотрели инструмен ansible
 - Рассмотрели inventory файлы
 - Рассмотрели ansible.cfg
 - Проверили ввыполнение различных команд
 - Написали простой плейбук и потестили его
 - Задание со свездочкой не привело к успешным решениям с моей стороны. То, для чего мы на этом курсе (ищем помощи и ответов), приходится искать самому, заниматься самообразованием. В Интернете нашел только нормальное, человеческое описание, для чего нужен динамический inventory, но как его реализовать через скрипт и потом какую команду запустить, по пунктам никто не рассказывает, как-будто какой-то секрет. Нашел у коллеги в репке, как он сделал, но там простыня из кода на питоне и в README содранный текст из статьи, которую предлагают почитать в ДЗ(мутная статья).

 Установка Ansible:
  ```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
  ```

 Команды:
  ```
ansible dbserver -m command -a uptime
ansible app -m ping
ansible all -m ping -i inventory.yml
ansible app -m command -a 'ruby -v'
ansible app -m shell -a 'ruby -v; bundler -v'
ansible db -m command -a 'systemctl status mongod'
ansible db -m shell -a 'systemctl status mongod'
ansible db -m systemd -a name=mongod
ansible db -m service -a name=mongod
ansible app -m shell -a 'sudo apt update && sudo apt install -y git'
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
ansible app -m shell -a 'rm -rf /home/ubuntu/reddit'
ansible app -m command -a 'rm -rf ~/reddit'
ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/ubuntu/reddit'
ansible-playbook clone.yml
  ```

## Лекция 11

 - Рассмотрели подход в одном плейбуке в одном таске
 - Рассмотрели подход в одном плейбуке в нескольких тасках
 - Рассмотрели подход с набором плейбуков
 - Подготовили плейбуки для app и db для packer
 - Cоздал bash скрипт для подстановки новых ip инвентори и app.yaml

 Команды:
  ```
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
ansible-playbook reddit_app.yml--limit app --tags deploy-tag

ansible-playbook reddit_app2.yml --tags db-tag --check
ansible-playbook reddit_app2.yml --tags db-tag

ansible-playbook site.yml --check
ansible-playbook site.yml
  ```

## Лекция 12

 - Рассмотрели подход c ролями
 - Рассмотрели подход с ansible-galaxy
 - Рассмотрели подход по средам со своими переменными, инвентори
 - Поработали с vault
 - Cоздал bash скрипт для каждой среды, для прохождения валидации

 Команды:
  ```
ansible-galaxy -h
ansible-galaxy init db
tree db
ansible-playbook playbooks/site.yml
ansible-playbook -i environments/prod/inventory playbooks/site.yml --check
ansible-galaxy install -r environments/stage/requirements.yml
ansible-vault encrypt environments/prod/credentials.yml
ansible-vault edit <file>
ansible-vault decrypt <file>
  ```
  
## Лекция 13

 - Рассмотрели работу с vagrant
 - Рассмотрели подход с использованием vagrant provision
 - Рассмотрели работу с molecule для тестирования

 Команды:
  ```
vagrant -v
vagrant box list
vagrant status
vagrant ssh appserver
ping -c 2 10.10.10.10
vagrant provision dbserver
telnet 10.10.10.10 27017
cat .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
vagrant destroy -f
vagrant up
pip install -r requirements.txt
molecule --version
molecule init scenario --scenario-name default -r db -d vagrant
molecule create
molecule list
molecule login -h instance
molecule converge
molecule verify
  ```
