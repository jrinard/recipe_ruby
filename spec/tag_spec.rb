require('spec_helper')

describe Tag do
  it "will check if the tables are setup right" do
    new_tag = Tag.create({:name => 'Snack'})
      expect(Tag.all).to eq [new_tag]
  end

  it "will check to see the tags has a recipe" do
    new_recipe = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :instructions => "cook", :ratings => 4})
    new_tag = Tag.create({:name => "Snack"})
    new_tag2 = Tag.create({:name => "Cookie"})
    new_tag3 = Tag.create({:name => "Desert"})
    expect(new_tag.recipes.push(new_recipe)).to(eq(new_tag.recipes))
    expect(Tag.all).to eq [new_tag, new_tag2, new_tag3]
  end

  it("validates presence of name field in tag") do
    tag = Tag.new({:name => ""})
    expect(tag.save()).to(eq(false))
  end
  it("converts the name to Capitalized") do
    tag = Tag.new({:name => "french"})
    tag.save()
    expect(tag.name()).to(eq("French"))
  end


end
