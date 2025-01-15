from mongoengine import Document, StringField, EmailField, DictField, ListField, DateTimeField, EmbeddedDocument, \
    EmbeddedDocumentField, ObjectIdField


# Collection scheme declaration
class User(Document):
    email = EmailField(required=True, unique=True)
    first_name = StringField(max_length=50)
    last_name = StringField(max_length=50)


class PostMetatag(EmbeddedDocument):
    title = StringField(max_length=50)
    description = StringField(max_length=500)


class PostCategory(EmbeddedDocument):
    id = ObjectIdField()
    title = StringField(max_length=50)



class Post(Document):
    title = StringField(max_length=50)
    url = StringField(max_length=50)
    content = StringField(max_length=500)
    metatag = EmbeddedDocumentField(PostMetatag)
    categories = ListField(EmbeddedDocumentField(PostCategory))
    authors = ListField(ObjectIdField())
    status = StringField(choices=['draft', 'published'], default='draft')
    updated_at = DateTimeField()
    created_at = DateTimeField()

    meta = {
        'auto_create_index': True, # default one
        'index_background': True, # default is False - index creation does not block operations on the collection
        'indexes': [
            {
              'name': 'status',
              'fields':  ('status','created_at') # combined index, useful when filtering by multiple fields. order of fields matter
            },
            {
                'name': 'url',
                'fields': ('url',),
                'unique': True # uniques constraint is enforced by creating unique index, can be created directly in field
            }
        ]
    }