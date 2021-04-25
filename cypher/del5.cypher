MATCH (:Person {id: $personId})-[hm:HAS_MEMBER]->(:Forum {id: $forumId})
DELETE hm
