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

#create recipe
post('/recipes') do
  new_name = params['recipe-name'] #[] are the same as .fetch but defult to nil or NULL
  new_ingedients = params['ingedients']
  new_instructions = params['instructions']
  new_rating = params['rating']
  new_tag = Tag.find(params['tag_id'].to_i)
  #creates new recipe with data it fetched above
  @recipes = Recipe.create({:name => new_name, :ingredients => new_ingedients, :instructions => new_instructions, :ratings => new_rating})
  #pushes new tag to the recipe you just created
  @recipes.tags.push(new_tag)
  if @recipes.save
  redirect "/recipes"
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
  #finds the recipe that matches the id
  @recipe = Recipe.find(params["id"].to_i)
  #update the recipe with the data fetched above
  @recipe.update({:name => new_recipe_name, :ingredients => new_recipe_ingedients, :instructions => new_recipe_instructions, :ratings => new_recipe_rating})
  #destroys all tags associated with recipe
  @recipe.tags.destroy_all
  #pushes new tag based on the id that was fetched above to the recipe
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
  #create a new tag with the value in the form and name it @tag
  @tag = Tag.create({:name  => new_tag})
  redirect "/"
end

#tags - multiple
get('/tags') do
  #get all your tags
  @tags = Tag.all()
  erb(:tags)
end

#tags - single
get('/tags/:id') do
  #find the specific tag by id
  @tags = Tag.find(params['id'].to_i)
  erb(:tag)
end


#update tag
patch('/tags/:id') do
  #grab the new tag name
  new_tag_name = params['new_tag']
  #find the tag with the  id
  @tags = Tag.find(params['id'].to_i)
  #update that found tag with the new name
  @tags.update({:name => new_tag_name})
  @tags = Tag.all()
  erb(:tags)
end

#delete tag
delete('/tags/:id') do
  Tag.find(params['id'].to_i).destroy
  redirect '/tags'
end
