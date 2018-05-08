var asc = -1;
db.londoncrimes1.aggregate(
  { $match : { borough : "Croydon" } },
  { $group: {_id: { year: "$year" } , crimesNumber: {$sum: "$value"}} },
  { $sort: {crimesNumber: asc} },
  { $limit: 9 }
);
