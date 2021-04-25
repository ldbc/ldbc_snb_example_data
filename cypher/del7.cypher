MATCH (:Comment {id: $commentId})<-[:REPLY_OF*0..]-(comment:Comment)
DETACH DELETE comment
