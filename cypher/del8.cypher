MATCH (:Person {id: $person1Id})-[k:KNOWS]-(:Person {id: $person2Id})
DELETE k
