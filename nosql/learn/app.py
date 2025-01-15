from mongoengine import connect, disconnect


from odm import User, Post, PostMetatag, PostCategory

connect(db='test', host='127.0.0.1', port=27017)


# Creating new document of collection schema
# user = User(email='test@gmail.com', first_name='Avtor', last_name='Petrovich')
# user.save()


# Static params field update
# user = User.objects(email='test@gmail.com')
# user.update(first_name='Arthas')
#
# # Dynamic params field update
# user2 = User.objects(email='test@gmail.com')
# fields = {
#     'first_name': 'Dyadya',
#     'last_name': 'Bogdan',
# }
# user.update(**fields)


post_metatag = PostMetatag(title='Test meta title', description='Test meta description')
post_metatag.title = 'Test meta title'
post_metatag.description = 'Test meta description'

post = Post()
post.title = "Hello World"
post.url = "hello-world"
post.content = "This is a test post"
post.metatag = post_metatag
post.status = "published"


post_category = PostCategory()
post_category.title = 'cat title 1'
post_category.id = '6783fd3c9b3590067459286b'

post.categories.append(post_category)

post.save()





disconnect()