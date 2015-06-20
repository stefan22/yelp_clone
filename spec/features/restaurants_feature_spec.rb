require 'rails_helper'

feature 'restaurants' do

  def sign_up(email='test@example.com')
    visit '/'
    click_link 'Sign up'
    fill_in "Email", with: email
    fill_in "Password", with: 'testtest'
    fill_in "Password confirmation", with: 'testtest'
    click_button 'Sign up'
  end

  def create_restaurant(name='KFC')
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: name
    click_button 'Create Restaurant'
  end

  def sign_out
    visit '/'
    click_link 'Sign out'
  end

  context 'no restaurants have been added' do
    scenario 'must be logged in to create a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurant for you! Sign in first!'
      expect(page).to have_link 'Sign up'
    end
  end



  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do
    scenario 'let a user edit a restaurant' do
     sign_up
     create_restaurant
     visit '/restaurants'
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
      scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up
      create_restaurant
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'cannot edit or delete restaurants' do
    scenario 'that i have not create' do
      visit '/'
      sign_up
      expect(page).not_to have_content 'Edit KFC'
      expect(page).not_to have_content 'Delete KFC'
    end

    scenario 'that i have created' do
      visit '/'
      sign_up
      create_restaurant
      expect(page).to have_content 'Edit KFC'
      expect(page).to have_content 'Delete KFC'
    end

  end

  context 'an invalid restaurant' do
    it 'does not let you submit a name that is too short' do
      sign_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'adding a restaurant' do
    it 'only adds a restaurant when logged in' do
      visit '/restaurants'
      expect(page).not_to have_content 'Add a restaurant'
    end
  end



end
