require 'rails_helper'

RSpec.describe 'Login', type: :system do
  describe 'login' do
    describe 'successful login' do
      let!(:user) { create(:user) }
      it 'allows the user to login' do
        visit root_path
        fill_in 'Email', with: 'bradenwrich@gmail.com'
        fill_in 'Password', with: 'password'
        click_on 'Login'
        expect(page).to have_content('Games')
      end
    end

    describe 'failed login' do
      it 'provides a flash message upon failed login' do
        visit root_path
        fill_in 'Email', with: 'bradenwrich@gmail.com'
        fill_in 'Password', with: 'foobar'
        click_on 'Login'
        expect(page).to have_content('Invalid email or password')
      end
    end
  end

  describe 'signup' do
<<<<<<< HEAD

=======
>>>>>>> 79fbff04577234602b731de022ae0cc89da23c04
    describe 'successful signup' do
      it 'signs in successfully' do
        visit signup_path
        fill_in 'Name', with: 'Braden'
        fill_in 'Email', with: 'example@example.com'
        fill_in 'Password', with: 'foobar', match: :first
        fill_in 'Password confirmation', with: 'foobar'
        click_on 'Sign up'
        expect(page).to have_content('Games')
      end
<<<<<<< HEAD

=======
>>>>>>> 79fbff04577234602b731de022ae0cc89da23c04
    end

    describe 'failed signup' do
      it 'does not allows a user to sign up twice' do
        visit signup_path
        create(:user, name: 'Braden', email: 'example@example.com', password: 'foobar', password_confirmation: 'foobar')
        fill_in 'Name', with: 'Braden'
        fill_in 'Email', with: 'example@example.com'
        fill_in 'Password', with: 'foobar', match: :first
        fill_in 'Password confirmation', with: 'foobar'
        click_on 'Sign up'
        expect(page).not_to have_content('Games')
        expect(page).to have_content('has already been taken')
      end
    end
  end

  describe 'logout' do
    it 'does not show the log out option to someone not logged in' do
      visit root_path
      expect(page).not_to have_content('Log out')
    end

    it 'allows the user to log out if they are logged in' do
      create(:user)
      visit root_path
      fill_in 'Email', with: 'bradenwrich@gmail.com'
      fill_in 'Password', with: 'password'
      click_on 'Login'
      expect(page).to have_content('Log out')
      click_on 'Log out'
      expect(page.current_path).to eq '/login'
      expect(page).not_to have_content('Log out')
    end
  end

  def login(user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Login'
  end
end
