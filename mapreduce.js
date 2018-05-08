var mapFunction1 = function() {
			   emit(this.year, this.value);
		   };
		   
var reduceFunction1 = function(year, value) {
				  return Array.sum(value);
			  };
			  
db.londoncrimes1.mapReduce(
			 mapFunction1,
			 reduceFunction1,
			 { out: "map_reduce_example" }
		   );
		   
db.map_reduce_example.find().sort({
	value: -1
}).limit(9);
