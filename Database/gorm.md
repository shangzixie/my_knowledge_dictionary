# gorm

## on conflict

```go
type user struct {
    brain_id: "234",
    scene: 1,
    language: 1,
    Template: "123",
}

result := r.db.Clauses(clause.OnConflict{
    Columns: []clause.Column{{Name: "brain_id"}, {Name: "scene"}, {Name: "language"}},
    UpdateAll: true,
}).Create(&user)
```

is equivalent to:

```go
INSERT INTO user (brain_id, scene, language)
VALUES ("123", 1, 1)
ON CONFLICT () DO UPDATE
SET brain_id = "234", scene = 1, language = 1, Template = "123";
```
