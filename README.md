# Como levantar una base de datos postgres dentro de docker

### Descripcion de funcionamiento:
Se va a levantar un deamon de docker con una base de datos postgreSQL con version a eleccion.

## Configuracion inicial 

### Instalar las siguientes dependencias:

- Docker 
`sudo apt-get install docker-ce docker-ce-cli containerd.io`

- PotsgreSQL
`sudo apt install postgresql postgresql-contrib`

## Generar el archivo YML que contiene la configuracion de la imagen de docker y la postgreSQL 

Nombre archivo: docker-compose.yml
Contenido:

`
version: "3.1"
services:

    dbTodo:
      image: postgres:14               # Version de postgres que se quiere instalar
      container_name: dbTodo 
      environment:                     # Credenciales para acceder a postgres
        - POSTGRES_USER=postgres
        - POSTGRES_PASSWORD=qwerty123
      ports:
        - "65432:5432"                 # puerto de entrada de docker : puerto de postgres
`


## Pasos para llevar a cabo lo planteado.

1- Moverse a la carpeta donde esta el archivo docker-compose.yml y correr el siguiente script para crear la imagen de docker y levantarla como daemon.

`docker-compose up -d`  

2- Desde un terminal generar el script que vamos a copair, consecuente, dentro de la imagen de docker dbTodo. Esto nos sirve para ejecutarlo desde dentro de la imagen de docker para: borrar, crear y restarutar/insertar la db dentro y por ende podamos conectarlo con nuestro servidor backend.

#### En el ejemplo se utiliza el archivo .sql que contiene la definicion de tablas, con sus relaciones e INSERT's('xx','xx') 
 https://github.com/lerocha/chinook-database - elegir la version -> `Chinook_PostgreSql.sql`
- Este archivo .sql tiene las instrucciones para crear las tablas, generar relaciones y ejecutar los inserts con datos para popular las tablas.

### Generar el script inicializador de las bases de datos.

#### Nombre achivo: 

`local_inicializador_dbs.sh`

#### Contenido:

################################################################

echo "# crear databases "

export PGPASSWORD='qwerty123'

echo "## Crear y restaurar base de datos DBCHINO"
psql -X -h localhost -U postgres -c "DROP DATABASE IF EXISTS Chinook_PostgreSql"
psql -X -h localhost -U postgres -c "CREATE DATABASE Chinook_PostgreSql"
psql -X -h localhost -U postgres -d Chinook_PostgreSql -f /tmp/Chinook_PostgreSql.sql


echo "####################"
echo "# fin" 
################################################################


## NOTA: Esto se puede hacer con n bases de datos, el siguiente ejemplo muestra con n=2


#### Ejemplo n2

################################################################
echo "# crear databases "

export PGPASSWORD='qwerty123'

# Crear y restaurar la base de datos NOMBRE1
echo "## Crear y restaurar base de datos NOMBRE1"
psql -X -h localhost -U postgres -c "DROP DATABASE IF EXISTS db_nombre1"
psql -X -h localhost -U postgres -c "CREATE DATABASE db_nombre1"
psql -X -h localhost -U postgres -d db_nombre1 -f "/tmp/nombre1.sql"

# Crear y restaurar la base de datos NOMBRE2
echo "## Crear y restaurar base de datos NOMBRE2"
psql -X -h localhost -U postgres -c "DROP DATABASE IF EXISTS db_nombre2"
psql -X -h localhost -U postgres -c "CREATE DATABASE db_nombre2"
psql -X -h localhost -U postgres -d db_nombre2 - f"/tmp/dbnombre2.sql"

echo "####################"
echo "# fin" 
################################################################

## NOTA: para restaurtar una base de datos, es decir: importar un dump/backup es necesario cambiar la instruccion a ejecutar:

#### quitar - PSQL:  
  `psql -X -h localhost -U postgres -d db_nombre1 -f "/tmp/nombre1.sql`

#### agregar - PG_RESTORE: 

`pg_restore -h localhost -U postgres -d db_nombre1 "/tmp/Chinook_PostgreSql.sql"`


3 - Copiar los archivos de los dumps/sql y el script local_inicializador para ejecutar dentro de docker.

Estando en carpeta que se encuentran los archivos y en un terminal, fuera de la imagen de docker, ejecutar:

`docker cp local_inicializador_dbs.sh dbTodo:/tmp/local_inicializador_dbs.sh`

`docker cp Chinook_PostgreSql.sql dbTodo:/tmp/Chinook_PostgreSql.sql`


4- Con los archivos en docker, nos falta ingresar y ejecutar el script
Para ingresar ejecutar el script:

 `docker exec -it dbTodo bash` 

5- Una vez conectados tenemos que asignar permisos de ejecucion al script con el comando

`chmod +x /tmp/local_inicializador_dbs.sh`

6- Ejecutar el script:

  `/tmp/local_inicializador_dbs.sh`

  
