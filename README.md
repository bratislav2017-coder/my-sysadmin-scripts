# Мониторинг ресурсов Linux

Скрипт каждые 5 секунд добавляет в лог временную метку и результаты команд free -h, df -h и uptime. Остановка — Ctrl+C. По умолчанию лог monitor.log сохраняется рядом со скриптом; другой путь можно задать через переменную LOG_FILE.

## Docker Compose

Из корня репозитория создай каталог данных и запусти приложение:

    mkdir -p docker-data
    sudo chown 1000:1000 docker-data
    sudo docker compose build
    sudo docker compose up -d

Контейнер my-app запускает скрипт мониторинга и HTTP-сервер на порту 8080. Файл monitor.log доступен по адресу http://127.0.0.1:8080/monitor.log.

## Nginx, HTTPS и systemd

Nginx проксирует запросы к контейнеру. HTTP перенаправляется на HTTPS. В учебной среде используется самоподписанный сертификат, поэтому для curl применяется параметр -k.

Конфигурации Nginx и systemd сохранены в каталоге deploy. Запросы Nginx записываются в /var/log/nginx/access.log, журнал службы доступен через journalctl -u my-app.

Проверить сервис можно командами curl -I http://127.0.0.1/, curl -kI https://127.0.0.1/ и systemctl status my-app.

sample_output.txt содержит пример вывода скрипта.
