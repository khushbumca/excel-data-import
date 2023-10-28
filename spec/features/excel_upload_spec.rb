require 'rails_helper'

RSpec.feature 'Excel File Upload', type: :feature do

  scenario 'User uploads an Excel file and data is stored in the database' do
    visit root_path
    attach_file 'file_data', Rails.root.join('spec', 'fixtures', 'files', 'valid.xlsx')
    click_button 'Import Data'
    expect(page).to have_content('Excel Result')

    # Ensure the data is correctly stored in the database
    user = User.first
    expect(user.first_name).to eq('Sample')
    expect(user.last_name).to eq('User')
    expect(user.email_id).to eq('sampleuser@yopmail.com')

    # Ensure the total no of users equal to valid rows from test excel
    user_cnt = User.all.count
    expect(user_cnt).to eq(6)

    #Ensure no records with firstname having nil in database
    first_name_nil = User.where(first_name: nil)
    expect(first_name_nil).to eq([])

    #Ensure no records with lastname having nil in database
    last_name_nil = User.where(last_name: nil)
    expect(last_name_nil).to eq([])

    #Ensure no records with email having nil in database
    email_nil = User.where(email_id: nil)
    expect(email_nil).to eq([])
  end

  scenario 'User uploads an invalid Excel file' do
    visit root_path
    attach_file 'file_data', Rails.root.join('spec', 'fixtures', 'files', 'invalid.txt')
    click_button 'Import Data'
    expect(page).to have_content("Please select a valid excel file to upload.")
  end

  scenario 'Not selected any file' do
    visit root_path
    attach_file 'file_data', nil
    click_button 'Import Data'
    expect(page).to have_content("Please select a file to upload.")
  end
end
