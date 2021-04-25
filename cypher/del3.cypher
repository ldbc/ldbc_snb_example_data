MATCH (:Person {id: $personId})-[likes:LIKES]->(:Comment {id: $commentId})
DELETE likes
