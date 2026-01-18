#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Blad uzycia"
    exit 1
fi

# Parametry
SOURCE_DIR=$1
REMOTE_TARGET=$2
shift 2
EXCLUDES=$@

# Ścieżka do Pulpitu
DESKTOP="/c/Users/$USERNAME/Desktop"

# Data
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="$DESKTOP/backup_$DATE.tar.gz"

# Budowanie wykluczeń
EXCLUDE_PARAMS=""
for pattern in $EXCLUDES; do
    EXCLUDE_PARAMS+=" --exclude=$pattern"
done

echo "Tworzenie backupu na pulpicie..."

# Tworzenie archiwum
tar -czf "$BACKUP_NAME" $EXCLUDE_PARAMS -C "$SOURCE_DIR" .

# Sprawdzenie błędu
if [ $? -ne 0 ]; then
    echo "Blad podczas tworzenia backupu!"
    exit 2
fi

echo "Backup zapisany:"
echo "$BACKUP_NAME"

# Podzial adresu serwera
USER_HOST=$(echo $REMOTE_TARGET | cut -d':' -f1)
REMOTE_DIR=$(echo $REMOTE_TARGET | cut -d':' -f2)

echo "Wysylanie na serwer..."

# SFTP
sftp $USER_HOST <<EOF
cd $REMOTE_DIR
put "$BACKUP_NAME"
bye
EOF

# Sprawdzenie
if [ $? -eq 0 ]; then
    echo "Backup wyslany poprawnie."
else
    echo "Blad podczas wysylania!"
fi



