#!/bin/bash

# Pfad zur Ausgabe-Datei
DUMP_FILE="sqldump.sql"

# Datenbank-Dump Befehl
mysqldump -h 127.0.0.1 -P 3306 -u root -pRoot2024! ps5_games > $DUMP_FILE

# Überprüfen, ob der Dump erfolgreich erstellt wurde
if [ $? -eq 0 ]; then
    # Füge 'USE ps5_games;' an den Anfang der Dump-Datei hinzu
    sed -i '1iUSE ps5_games;' $DUMP_FILE
    echo "Datenbank-Dump erfolgreich erstellt: $DUMP_FILE"
else
    echo "Fehler beim Erstellen des Dumps."
fi