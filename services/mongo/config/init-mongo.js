db.createUser(
    {
        user: "mongo_user",
        pwd: "mongo_password",
        roles: [
            {
                role: "readWrite",
                db: "test"
            }
        ]
    }
)

db.createCollection('test_delete-me');
