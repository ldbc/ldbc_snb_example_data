MATCH (:Person {id: $personId})-[likes:LIKES]->(:Post {id: $postId})
DELETE likes
