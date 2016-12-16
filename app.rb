require("sinatra")
require("sinatra/reloader")
require('sinatra/activerecord')
also_reload("lib/**/*.rb")
require("pg")
require('./lib/recipe')
require('./lib/tag')

#fix active record issue
after do
  ActiveRecord::Base.clear_active_connections!
end

#home route
get('/') do
  @tags = Tag.all() #grabs all tags and makes them available
  erb(:index)
end

#recipe - multiple
get('/recipes') do
  @recipes = Recipe.all() #grabs all recipes and makes them available
  erb(:recipes)
end

#recipe - single
get('/recipe/:id') do
  @recipes = Recipe.find(params.fetch("id").to_i) #finding the single recipe with that id
  @tags = @recipes.tags
  @alltags = Tag.all
  erb(:recipe_detail)
end

#create cecipe
post('/recipes') do
  new_name = params['recipe-name'] #[] are the same as .fetch but defult to nil or NULL
  new_ingedients = params['ingedients']
  new_instructions = params['instructions']
  new_rating = params['rating']
  new_tag = Tag.find(params['tag_id'].to_i)
  @recipes = Recipe.create({:name => new_name, :ingredients => new_ingedients, :instructions => new_instructions, :ratings => new_rating})
  @recipes.tags.push(new_tag)
  if @recipes.save
    redirect "/"
  else
    erb(:errors)
  end
end

#update recipe
patch('/recipe/:id') do
  new_recipe_name = params["new-name"]
  new_recipe_ingedients = params["new-ingedients"]
  new_recipe_instructions = params["new-instructions"]
  new_recipe_rating = params["new-rating"]
  @recipe = Recipe.find(params["id"].to_i)
  @recipe.update({:name => new_recipe_name, :ingredients => new_recipe_ingedients, :instructions => new_recipe_instructions, :ratings => new_recipe_rating})
  @recipe.tags.destroy_all
  @recipe.tags.push(Tag.find(params["tag_id"]))
  redirect '/recipes'
end

#delete recipe
delete('/recipe/:id') do
  Recipe.find(params['id'].to_i).destroy
  redirect '/recipes'
end


#----------  tag related

#create tag
post('/tags') do
  new_tag = params['tag']
  @tag = Tag.new({:name  => new_tag})
  if @tag.save
    redirect "/"
  else
    erb(:errors)
  end
end

#tags - multiple
get('/tags') do
  @tags = Tag.all()
  erb(:tags)
end

#tags - single
get('/tags/:id') do
  @tags = Tag.find(params['id'].to_i)
  erb(:tag)
end

#delete tag
delete('/tags/:id') do
  Tag.find(params['id'].to_i).destroy
  redirect '/tags'
end

#update tag
patch('/tags/:id') do
  new_tag_name = params['new_tag']
  @tags = Tag.find(params['id'].to_i)
  @tags.update({:name => new_tag_name})
  @tags = Tag.all()
  erb(:tags)
end
