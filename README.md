# Projekt na egzamin
## Autorzy
- Jędrzej Warzocha
- Mateusz Zweigert

#### Dane
[London Crime Data, 2008-2016](https://www.kaggle.com/jboysen/london-crime/data)
Crime Counts, by Borough, Category, and Month.
Dane te zawierają 13 490 604 rekordów i ograniczone zostały do 1 000 000
```sh
$ head -1000001 london_crime_by_lsoa.csv > london_crime_m.csv
```
Rozmiar wyniósł 66 MB.

#### Docker
Wykorzystany został najnowszy obraz mongo.
```sh
docker pull mongo:latest
```
Uruchomiony poleceniem:
```sh
docker run -it mongo:latest /bin/bash
```
Zostało zainstalowane git i nano:
```sh
apt-get update
apt-get install git-core
apt-get install nano
```
A repozytorium zostało sklonowane:
```sh
git clone https://github.com/my-docker-nosql/ainc-qwerty
```
a więc wszystkie pliki znajdują się w obrazie w folderze ainc-qwerty.

W celu wypchnięcia obrazu do docker hub zostały wykonane następujące komendy:
```sh
docker commit 753f872400e0 mongo:projekt2
docker tag mongo:projekt2 warjed/projekt1
docker push warjed/projekt1
```
A docker ze wszystkimi danymi można pobrać za pomocą:
```sh
docker pull warjed/projekt1
```
#### Replica set
Można uruchomić za pomocą skrytptu repset.sh:
```sh
./repset.sh
```
Skrypt importuje plik z milionem danych i import danych zajął:
```sh
real    6m32.507s
user    0m17.580s
sys     0m0.550s
```
#### Agregacja pipeline i map reduce
Agregacja pipeline znajduje się w pliku agregation.js, a map reduce w pliku mapreduce.js. Można je uruchomić za pomocą pliku agregacje.sh:
```sh
./agregacje.sh
```
i otrzymać pomiary czasu.

Agregacja pipeline:
```sh
var asc = -1;
db.londoncrimes1.aggregate(
  { $match : { borough : "Westminster" } },
  { $group: {_id: "$year" , value: {$sum: "$value"}} },
  { $sort: {value: asc} },
  { $limit: 9 }
);
```
Map reduce:
```sh
var asc = -1;
var mapFunction1 = function() {
	emit(this.year, this.value);
};
var reduceFunction1 = function(year, value) {
	return Array.sum(value);
};
db.londoncrimes1.mapReduce(
	mapFunction1,
	reduceFunction1,
	{ 
		query: {borough: "Westminster"},
		out: "map_reduce_example" 
	}
);
db.map_reduce_example.find().sort({
	value: asc
}).limit(9);
```
Obie agregacje dla miliona danych zwracają:
```sh
{ "_id" : 2012, "value" : 5415 }
{ "_id" : 2013, "value" : 4235 }
{ "_id" : 2015, "value" : 3733 }
{ "_id" : 2016, "value" : 3592 }
{ "_id" : 2014, "value" : 3559 }
{ "_id" : 2011, "value" : 3504 }
{ "_id" : 2009, "value" : 2955 }
{ "_id" : 2008, "value" : 2928 }
{ "_id" : 2010, "value" : 2594 }
```
I są to lata od największej do najmniejszej ilości przestępstw w dzielnicy Westminster.
