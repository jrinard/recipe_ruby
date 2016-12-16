require('spec_helper')

describe Recipe do
  it "will check if the tables are setup right" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk'})
      expect(Recipe.all).to eq [new_recipe]
  end

  it "will check to see the recipe has tags" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk'})
    new_tag = Tag.create({:name => "Snack"})
    new_tag2 = Tag.create({:name => "Cookie"})
    new_tag3 = Tag.create({:name => "Desert"})
    expect(new_recipe.tags.push(new_tag, new_tag2, new_tag3)).to(eq(new_recipe.tags))
    expect(Tag.all).to eq [new_tag, new_tag2, new_tag3]
  end

  it "will show the rating exists and grab a specific recipe rating" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 5.1})
    new_recipe2 = Recipe.create({:name => 'Pie', :ingredients => 'Flour sugar milk', :ratings => 4})
    new_recipe3 = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 10})
    new_recipe4 = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 1.2})
    expect(Recipe.all).to eq [new_recipe, new_recipe2, new_recipe3, new_recipe4]
    expect(new_recipe3.ratings).to eq 10
  end

  it "will show the order from least to greatest" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 5.1})
    new_recipe2 = Recipe.create({:name => 'Pie', :ingredients => 'Flour sugar milk', :ratings => 4})
    new_recipe3 = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 10})
    new_recipe4 = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :ratings => 1.2})
    expect(Recipe.order(:ratings => :desc)).to eq [new_recipe3, new_recipe, new_recipe2, new_recipe4] 
  end

  it "will find all recipes containing a spefic ingredient" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour', :ratings => 5.1})
    new_recipe2 = Recipe.create({:name => 'Pie', :ingredients => 'Flour sugar milk', :ratings => 4})
    new_recipe3 = Recipe.create({:name => 'Cookies', :ingredients => ' milk', :ratings => 10})
    new_recipe4 = Recipe.create({:name => 'Cookies', :ingredients => 'sugar milk', :ratings => 1.2})
    expect(Recipe.where('Ingredients like ?', '%Flour%')).to eq [new_recipe, new_recipe2]
    expect(Recipe.where('Ingredients like ?', '%milk%')).to eq [new_recipe2, new_recipe3, new_recipe4]
  end
end
