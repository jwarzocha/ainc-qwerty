host1='localhost'
host2='localhost'
host3='localhost'

	scriptspwd=$(pwd)
	
	mkdir -p /tmp/jwarzocha/carbon 
	cd /tmp/jwarzocha/carbon 
	mkdir -p data-{1,2,3}
	
	cd $scriptspwd	
	mongod --replSet rs0 --port 27017 --bind_ip $host1 --dbpath /tmp/jwarzocha/carbon/data-1 --smallfiles --oplogSize 128 > /dev/null &
sleep 15	
	mongod --replSet rs0 --port 27018 --bind_ip $host2 --dbpath /tmp/jwarzocha/carbon/data-2 --smallfiles --oplogSize 128 > /dev/null &
sleep 15
	mongod --replSet rs0 --port 27019 --bind_ip $host3 --dbpath /tmp/jwarzocha/carbon/data-3 --smallfiles --oplogSize 128 > /dev/null &
sleep 15
	mongo --host $host1:27017 --shell ./repl_set_init.js > /dev/null &
sleep 15
	start_time=`date +%s`
	
	time mongoimport --host rs0/$host1:27017,$host2:27018,$host3:27019 --db test --type csv  --collection londoncrimes1 --drop --file ./london_crime_m.csv --headerline 
	#time mongoimport --host rs0/$host1:27017,$host2:27018,$host3:27019 --db test --type csv  --collection londoncrimes1 --drop --file ./london_crime_test.csv --headerline 

	end_time=`date +%s`
	echo execution time was `expr $end_time - $start_time` s.
