
//Creacion de cada uno de los nodos sin incluir las claves ajenas de las tablas

LOAD CSV WITH HEADERS FROM "file:///library/Tema.csv" as line
FieldTerminator ','
CREATE (n:Tema)
SET n=line;

LOAD CSV WITH HEADERS FROM "file:///library/Autor.csv" as line
FieldTerminator ','
CREATE (n:Autor)
SET n.cod_autor=ToInteger(line.cod_autor),
n.nombre_tema=line.nombre_tema,
n.pais=line.pais,
n.fecha_nac=line.fecha_nac,
n.fecha_fall=line.fecha_fall,
n.bio=line.bio;

LOAD CSV WITH HEADERS FROM "file:///library/Obra.csv" as line
FieldTerminator ','
CREATE (n:Obra)
SET n.cod_obra=ToInteger(line.cod_obra),
n.titulo=line.titulo,
n.nombre_tema=line.nombre_tema,
n.cod_autor=line.cod_autor
n.resumen=line.resumen;


LOAD CSV WITH HEADERS FROM "file:///library/Solicitud.csv" as line
FieldTerminator ','
CREATE (n:Solicitud)
SET n.fecha_sol=line.fecha_sol,
n.cod_obra=ToInteger(line.cod_obra),
n.dni_socio=line.dni_socio,
n.atendida=ToBoolean(line.atendida);


LOAD CSV WITH HEADERS FROM "file:///library/Volumen.csv" as line
FieldTerminator ','
CREATE (n:Volumen)
SET n.isbn=ToInteger(line.isbn),
n.ref=line.ref,
n.num_edic=line.num_edic,
n.paginas=ToInteger(line.paginas);

LOAD CSV WITH HEADERS FROM "file:///library/Cuota.csv" as line
FieldTerminator ','
CREATE (n:Cuota)
SET n.anyo=ToInteger(line.anyo),
n.mes=ToInteger(line.mes),
n.dni_socio=line.dni_socio,
n.pagada=ToBoolean(line.pagada);

LOAD CSV WITH HEADERS FROM "file:///library/Prestamo.csv" as line
FieldTerminator ','
CREATE (n:Prestamo)
SET n=line;

LOAD CSV WITH HEADERS FROM "file:///library/Socio.csv" as line
FieldTerminator ','
CREATE (n:Socio)
SET n=line;

LOAD CSV WITH HEADERS FROM "file:///library/Ejemplar.csv" as line
FieldTerminator ','
CREATE (n:Ejemplar)
SET n=line;

LOAD CSV WITH HEADERS FROM "file:///library/Edicion.csv" as line
FieldTerminator ','
CREATE (n:Edicion)
SET n.ref=line.ref,
n.cod_obra=line.cod_obra,
n.disponible=ToBoolean(line.disponible);

//Creacion de cada relacion entre los nodos
//Utilizamos las tablas en las que se encuentran 
//las claves ajenas para poner entablar las relaciones

//Tema-clasifica-Obra
MATCH (o_ob:Obra),(t_tema:Tema)
WHERE o_ob.nombre_tema=t_tema.nombre_tema
MERGE (o_ob)-[r:CLASIFICA]->(t_tema);

//Autor-escribe-Obra
MATCH (o:Obra),(a:Autor)
WHERE o.cod_autor=a.cod_autor
MERGE (o)-[r:ESCRIBE]->(a);

//Obra-es_prestado-Solicitud
MATCH (s:Solicitud),(o:Obra)
WHERE s.cod_obra=o.cod_obra
CREATE (s)-[r:ES_PRESTADO]-(o);

//Obra-publica-Edicion
MATCH (e:Edicion)(o:Obra)
WHERE e.cod_obra=o.cod_obra
CREATE (e)-[r:PUBLICA]->(o);

//Edicion-se_compone_de-Volumen
MATCH (v:Volumen),(e:Edicion)
WHERE v.num_edic=e.num_edic
CREATE (v)-[r:SE_COMPONE_DE]->(e);

//Ejemplar-se_dispone-Volumen
MATCH (v:Volumen),(e:Ejemplar)
WHERE v.ref=e.ref
CREATE (v)-[r:SE_DISPONE]->(e);

//Ejemplar-es_prestado_por-Prestamo
MATCH (p:Prestamo),(e:Ejemplar)
WHERE p.ref=e.ref
CREATE (p)-[r:ES_PRESTADO_POR]->(e);

//Socio-toma_prestado-Prestamo
MATCH (p:Prestamo),(s:Socio)
WHERE p.dni_socio=s.dni_socio
CREATE (p)<-[r:TOMA_PRESTADO]-(s);

//Socio-toma_prestado_por-Prestamo
MATCH (p:Solicitud),(s:Socio)
WHERE p.dni_socio=s.dni_socio
CREATE (p)-[r:TOMA_PRESTADO_POR]->(s);

//Cuota-paga-Socio
MATCH (c:Cuota),(s:Socio)
WHERE c.dni_socio=s.dni_socio
CREATE (c)<-[r:PAGA]-(s);


