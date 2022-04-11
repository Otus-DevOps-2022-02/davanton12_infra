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
