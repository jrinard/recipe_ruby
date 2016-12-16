require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)


describe('Main Route', {:type => :feature}) do
  describe('Create Tag') do
    it "allows user to create a tag" do
      visit('/')
      fill_in('tag', :with => "Snack")
      click_button('Create Tag')
      visit('/tags')
      expect(page).to have_content 'Snack'
    end
    it "allows user to create a recipe" do
      visit('/')
      fill_in('new-recipe-name', :with => "pizza")
      fill_in('new-ingedients', :with => "cheese")
      fill_in('new-instructions', :with => "cook")
      fill_in('new-rating', :with => "5.1")
      fill_in('tag', :with => "Cookie")
      click_button('Create Recipe')
      visit('/recipes')
      expect(page).to have_content 'Recipe List'
    end
  end

  describe('show a recipe') do
    it "allows user to view individual recipe" do
      Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :instructions => "cook", :ratings => 5.1})
      visit("/recipes")
      expect(page).to have_content 'Cookies'
    end
  end

  describe('show a specific recipe') do
    it "allows user to view individual recipe" do
      rec = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :instructions => "cook", :ratings => 5.1})
      visit("/recipe/#{rec.id}")
      expect(page).to have_content 'Cookies'
    end
  end

  # describe('Modify a recipe', {:type => :feature}) do
  #   it "allows user to update a recipe" do
  #     rec = Recipe.create({:name => 'Cookies', :ingredients => 'Flour sugar milk', :instructions => "cook", :ratings => 5.1})
  #     visit("/recipe/#{rec.id}")
  #     fill_in('new-name', :with => "Pepperoni")
  #     fill_in('new-ingedients', :with => "Pepperoni")
  #     fill_in('new-instructions', :with => "Pepperoni")
  #     fill_in('new-rating', :with => "Pepperoni")
  #     Tag.create({:name => "Dinner"})
  #     fill_in('tag_id', :with => "Dinner")
  #     click_button("Update")
  #     expect(page).to have_content 'Pepperoni'
  #   end
  # #   it "allows user to delete a recipe" do
  # #     recipe = Recipe.create({:name => "Pizza"})
  # #     visit("/recipes/#{recipe.id}")
  # #     click_button("Delete Recipe")
  # #     expect(page).not_to have_content 'Pizza'
  # #   end
  # end

  describe('Modify a Tag', {:type => :feature}) do
    it "allows user to update a tag" do
      tag = Tag.create({:name => "Dinner"})
      visit("/tags/#{tag.id}")
      fill_in('new_tag', :with => "Lunch")
      click_button("Save")
      expect(page).to have_content 'Lunch'
    end
    it "allows user to delete a tag" do
      tag = Tag.create({:name => "Dinner"})
      visit("/tags/#{tag.id}")
      click_button("Delete")
      expect(page).not_to have_content 'Dinner'
    end
  end




end
