var asc = -1;
db.londoncrimes1.aggregate(
  { $match : { borough : "Westminster" } },
  { $group: {_id: "$year" , value: {$sum: "$value"}} },
  { $sort: {value: asc} },
  { $limit: 9 }
);
