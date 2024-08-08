echo "# crear databases "

export PGPASSWORD='qwerty123'

# Crear y restaurar la base de datos DBCHINO
echo "## Crear y restaurar base de datos DBCHINO"
psql -X -h localhost -U postgres -c "DROP DATABASE IF EXISTS Chinook_PostgreSql"
psql -X -h localhost -U postgres -c "CREATE DATABASE Chinook_PostgreSql"
# Este comando es para que al ejecutar el .sql y se creen las tablas con relaciones e inserten los datos. 
psql -X -h localhost -U postgres -d Chinook_PostgreSql -f /tmp/Chinook_PostgreSql.sql

# Este comnado es para levantar desde un respaldo/backup hecho.
#pg_restore -h localhost -U postgres -d db_nombre1 "/tmp/nombre1.sql"


echo "####################"
echo "# fin" 
