!/bin/bash

# Verifica si Nmap está instalado
test -f /usr/bin/nmap

if [ "$(echo $?)" == 0 ]; then
        echo "Nmap está instalado"
else
        echo "Nmap NO está instalado" && sudo apt update > /dev/null && sudo apt install nmap -y > /dev/null
fi

# IP objetivo
ip=$1

# Hacemos ping a la IP objetivo y guardamos el resultado
ping -c 1 $ip > ping.log

# Comprobamos si es un sistema Linux (TTL entre 60 y 70)
for i in $(seq 60 70); do
        if [ "$(grep -c ttl=$i ping.log)" -eq 1 ]; then
                echo "Es un Linux"
        fi
done

# Comprobamos si es un sistema Windows (TTL entre 100 y 200)
for i in $(seq 100 200); do
        if [ "$(grep -c ttl=$i ping.log)" -eq 1 ]; then
                echo "Es un Windows"
        fi
done

# Eliminamos el archivo de log de ping
rm ping.log

# Ejecutamos el escaneo Nmap
nmap -p- -sV -sC --open -sS -n -Pn $ip -oN escaneo
