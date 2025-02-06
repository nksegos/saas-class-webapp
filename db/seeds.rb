
def seed_users
  user_id = 0
  10.times do
    User.create(
      name: "user#{user_id}",
      email: "user#{user_id}@mail.com",
      password: '123456',
      password_confirmation: '123456'
    )
    user_id = user_id + 1
  end
end


def seed_categories

  cat_list = ['Software Development', 'Programming Languages', 'Logic Design', 'Databases', 'Data Analytics', 'Algorithms', 'Security', 'Off Topic']

  cat_list.each do |name|
    Category.create(name: name)
  end
end

def seed_posts
  categories = Category.all

  categories.each do |category|
    5.times do
      Post.create(
        title: Faker::Lorem.sentences[0],
        content: Faker::Lorem.sentences[0],
        user_id: rand(1..9),
        category_id: category.id
      )
    end
  end
end

seed_users
seed_categories
seed_posts
