RSpec.describe 'Friendship feature', type: :feature do
  before(:each) do
    @testuser1 = User.create(name: 'Test user 1', email: 'test1@friend.com', password: '123456')
    @testuser2 = User.create(name: 'Test user 2', email: 'test2@friend.com', password: '123456')
  end

  # rubocop: disable Metrics/BlockLength
  context 'Logged user' do
    scenario 'view posts on timeline' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      expect(page).to have_content('Signed in successfully.')

      friendship = Friendship.create(user_id: @testuser1.id, rqstuser_id: @testuser2.id)
      friendship.confirm_friend

      post1 = @testuser1.posts.create(content: 'TEST TIMELINE POST')
      post2 = @testuser2.posts.create(content: 'TEST TIMELINE POST 2')

      visit root_path

      expect(page).to have_content post1.content
      expect(page).to have_content post2.content
    end

    scenario 'Not send friend request on self view' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      click_link 'My profile'
      expect(page).not_to have_content('Send friend request')
    end

    scenario 'send friendship request available' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      expect(page).to have_content('Send friend request')
    end

    scenario 'send friendship request' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      first(:link, 'Send friend request').click
      expect(page).to have_content('Friend request waiting for acceptance. Decline request')
    end

    scenario 'cancel friendship request' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      first(:link, 'Send friend request').click
      first(:link, 'Friend request waiting for acceptance. Decline request').click
      expect(page).to have_content('Friend request declined or Frienship finished')
    end

    scenario 'view friendship request' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      first(:link, 'Send friend request').click

      expect(page).to have_content('Friend request waiting for acceptance. Decline request')
      click_link 'Sign out'

      within('form') do
        fill_in 'Email', with: 'test2@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'Invitations'

      expect(page).to have_content('Confirm Friendship Request')

      expect(page).to have_content('Decline Friendship Request')
    end

    scenario 'accept friendship request' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      first(:link, 'Send friend request').click

      expect(page).to have_content('Friend request waiting for acceptance. Decline request')
      click_link 'Sign out'

      within('form') do
        fill_in 'Email', with: 'test2@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'Invitations'

      click_link 'Confirm Friendship Request'

      expect(page).to have_content('Now you are friends')
    end

    scenario 'decline friendship request' do
      visit new_user_session_path
      within('form') do
        fill_in 'Email', with: 'test1@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'All users'
      first(:link, 'See Profile').click
      first(:link, 'Send friend request').click

      expect(page).to have_content('Friend request waiting for acceptance. Decline request')
      click_link 'Sign out'

      within('form') do
        fill_in 'Email', with: 'test2@friend.com'
        fill_in 'Password', with: '123456'
      end

      click_button 'Log in'

      click_link 'Invitations'

      click_link 'Decline Friendship Request'

      expect(page).to have_content('Friend request declined or Frienship finished')
    end
  end

  # rubocop: enable Metrics/BlockLength
end
